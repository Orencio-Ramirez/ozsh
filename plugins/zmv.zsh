###########################################################################
# plugins/zmv.zsh
# Integración de zmv y limpieza masiva de nombres de archivo.
###########################################################################

###########################################################################
# Activación de zmv
###########################################################################

autoload -Uz zmv
setopt extended_glob

alias zmv='noglob zmv'

###########################################################################
# Funciones de limpieza de nombres para zmv
###########################################################################

# ------------------------------------------------------------------------
# limpiar_nombres
# Aplica, en orden, una serie de pasadas de zmv para dejar los nombres de
# archivo limpios: sin paréntesis/corchetes, sin espacios dobles/sueltos
# al inicio o final, y con la primera letra de cada palabra en mayúscula.
# ------------------------------------------------------------------------
limpiar_nombres() {
    setopt localoptions extendedglob nullglob

    # NOTA sobre el último paso (capitalizar): ${(C)...} depende del
    # locale del sistema para saber qué cuenta como "letra". Si tu
    # servidor tiene el locale en C/POSIX (comprueba con `locale`), las
    # vocales acentuadas y la ñ no se reconocen como parte de la palabra
    # y la capitalización sale mal (p. ej. "tiburón" -> "TiburóN"). La
    # solución es tener un locale UTF-8 activo en el sistema (por ejemplo
    # es_ES.UTF-8: `sudo locale-gen es_ES.UTF-8` y exportarlo en tu shell),
    # no algo que forcemos aquí dentro de la función, ya que forzar el
    # locale sólo para esta función puede causar comportamiento inestable
    # dependiendo de qué locales tenga generados el sistema.

    # Cada paso puede no tener ninguna coincidencia (por ejemplo, si ya no
    # quedan paréntesis, o no hay espacios dobles). zmv termina con código
    # de error en ese caso; el "|| true" evita que la función se detenga
    # y el "2>/dev/null" silencia el mensaje "zmv: no files matched".

    # Eliminar paréntesis, corchetes y su contenido; puntos internos -> espacio
    noglob zmv '(*).(*)' '${${${1//\[[^]]#\]/}//\([^)]#\)/}//./ }.$2' 2>/dev/null || true

    #Eliminar simbolos problematicos
    noglob zmv '(*).(*)' '${1:gs/¿//:gs/¡//:gs#:##:gs/?//:gs/\!//:gs/º//:gs/ª//}.$2' 2>/dev/null || true
    
    # Cambiar espacios dobles por simples
    noglob zmv '(*)  (*).(*)' '$1 $2.$3' 2>/dev/null || true

    # Eliminar espacio al final del nombre (antes de la extensión)
    noglob zmv '(*) .(*)' '$1.$2' 2>/dev/null || true

    # Eliminar espacio al principio del nombre
    noglob zmv ' (*).(*)' '$1.$2' 2>/dev/null || true

    # Capitalizar la primera letra de cada palabra
    noglob zmv '(*).(*)' '${(C)1}.${2}' 2>/dev/null || true
}

# ------------------------------------------------------------------------
# eliminar_cadena <parametro>
# Elimina la cadena <parametro> de todos los nombres de archivo del
# directorio actual.
# ------------------------------------------------------------------------
eliminar_cadena() {
    setopt localoptions extendedglob

    if [[ -z "$1" ]]; then
        print -u2 "Uso: eliminar_cadena <cadena_a_eliminar>"
        return 1
    fi

    local cadena="$1"
    # Escapamos los caracteres especiales de glob para que zmv la trate
    # como texto literal y no como patrón.
    local cadena_esc="${(b)cadena}"

    noglob zmv "(*)${cadena_esc}(*).(*)" '$1$2.$3'
}

# ------------------------------------------------------------------------
# agregar_contador [parametro]
# Antepone un contador de 3 dígitos (000, 001, 002...) al nombre de cada
# archivo. [parametro] es el número inicial (por defecto 1).
# ------------------------------------------------------------------------
agregar_contador() {
    local COUNTER="${1:-1}"
    [[ "$COUNTER" == <-> ]] || {
        print -u2 "Uso: agregar_contador [numero_inicial]"
        return 1
    }

    noglob zmv '(*)' '${(l:3::0:)$((COUNTER++))} - $1'
}

# ------------------------------------------------------------------------
# normalizar_nombres <parametro>
# Normaliza nombres del tipo "<parametro> 1x02 Resto del título.ext" a
# "T01 E02 - Resto del título.ext", eliminando la cadena <parametro>.
# ------------------------------------------------------------------------
normalizar_nombres() {
    setopt localoptions extendedglob

    if [[ -z "$1" ]]; then
        print -u2 "Uso: normalizar_nombres <cadena_a_eliminar>"
        return 1
    fi

    # Quitamos espacios sobrantes al final del parámetro, ya que la
    # plantilla ya añade un único espacio de separación antes del patrón
    # de temporada/episodio (evita el doble espacio "Vegas  11x01").
    local cadena="${1%%[[:space:]]##}"
    local cadena_esc="${(b)cadena}"

    noglob zmv "${cadena_esc} ([0-9]##)x([0-9]##) (*)" \
        'T${(l:2::0:)1} E${(l:2::0:)2} - $3'
}

# ------------------------------------------------------------------------
# corregir_letras
# Corrige nombres de archivo con errores de codificación (mojibake) en
# castellano: tildes y eñe mal decodificadas (p. ej. UTF-8 leído como
# Latin-1/ISO-8859-1 y viceversa).
# ------------------------------------------------------------------------
corregir_letras() {
    setopt localoptions nullglob

    # Mapa de secuencias erróneas -> carácter correcto.
    # Cubre tanto la variante con "Ã" (mayúscula, la más habitual) como
    # la variante en minúscula "ã" mencionada en el enunciado.
    local -A mapa=(
        'Ã¡' 'á'  'ã¡' 'á'
        'Ã©' 'é'  'ã©' 'é'
        'Ã­' 'í'  'ã­' 'í'
        'Ã³' 'ó'  'ã³' 'ó'
        'Ãº' 'ú'  'ãº' 'ú'
        'Ã±' 'ñ'  'ã±' 'ñ'
        'Ã¼' 'ü'  'ã¼' 'ü'
        'Ã¤' 'ä'
        'Â¿' '¿'
        'Â¡' '¡'
        # Nota: las vocales acentuadas en MAYÚSCULA (Á, É, Í, Ó, Ú, Ñ) no se
        # incluyen porque, al codificarlas en UTF-8 y reinterpretarlas como
        # Latin-1, el segundo byte cae en la zona de caracteres de control
        # (no imprimibles), por lo que no aparecen como una secuencia de
        # texto reconocible en un nombre de archivo real.
    )

    local f nuevo clave valor
    for f in *; do
        [[ -e "$f" ]] || continue
        nuevo="$f"
        for clave valor in "${(@kv)mapa}"; do
            nuevo="${nuevo//$clave/$valor}"
        done
        if [[ "$nuevo" != "$f" ]]; then
            mv -n -- "$f" "$nuevo"
        fi
    done
}
