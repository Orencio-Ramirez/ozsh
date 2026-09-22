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

# ------------------------------------------------------------------------
# limpiar_nombres
# Aplica, en orden, una serie de pasadas de zmv para dejar los nombres de
# archivo limpios: sin paréntesis/corchetes, sin espacios dobles/sueltos
# al inicio o final, y con la primera letra de cada palabra en mayúscula.
# ------------------------------------------------------------------------
limpiar_nombres() {
    setopt localoptions extendedglob nullglob

    # Eliminar paréntesis, corchetes y su contenido; puntos internos -> espacio
    noglob zmv -Q '(*).(*)' '${${${1//\[[^]]#\]/}//\([^)]#\)/}//./ }.$2'

    # Cambiar espacios dobles por simples
    noglob zmv -Q '(*)  (*).(*)' '$1 $2.$3'

    # Eliminar espacio al final del nombre (antes de la extensión)
    noglob zmv -Q '(*) .(*)' '$1.$2'

    # Eliminar espacio al principio del nombre
    noglob zmv -Q ' (*).(*)' '$1.$2'

    # Capitalizar la primera letra de cada palabra
    noglob zmv -Q '(*).(*)' '${(C)1}.${2}'
}
alias limpiar_nombres='limpiar_nombres'

# ------------------------------------------------------------------------
# eliminar_cadena <parametro>
# Elimina la cadena <parametro> de todos los nombres de archivo del
# directorio actual.
# ------------------------------------------------------------------------
eliminar_cadena() {
    if [[ -z "$1" ]]; then
        print -u2 "Uso: eliminar_cadena <cadena_a_eliminar>"
        return 1
    fi

    local cadena="$1"
    # Escapamos los caracteres especiales de glob para que zmv la trate
    # como texto literal y no como patrón.
    local cadena_esc="${(q)cadena}"

    noglob zmv -Q "(*)${cadena_esc}(*).(*)" '$1$2.$3'
}
alias eliminar_cadena='eliminar_cadena'

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

    noglob zmv -Q '(*)' '${(l:3::0:)$((COUNTER++))} - $1'
}
alias agregar_contador='agregar_contador'

# ------------------------------------------------------------------------
# normalizar_nombres <parametro>
# Normaliza nombres del tipo "<parametro> 1x02 Resto del título.ext" a
# "T01 E02 - Resto del título.ext", eliminando la cadena <parametro>.
# ------------------------------------------------------------------------
normalizar_nombres() {
    if [[ -z "$1" ]]; then
        print -u2 "Uso: normalizar_nombres <cadena_a_eliminar>"
        return 1
    fi

    local cadena_esc="${(q)1}"

    noglob zmv -Q "${cadena_esc} ([0-9]##)x([0-9]##) (*)" \
        'T${(l:2::0:)1} E${(l:2::0:)2} - $3'
}
alias normalizar_nombres='normalizar_nombres'

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
        'Ã'  'Á'
        'Ã‰' 'É'
        'Ã'  'Í'
        'Ã“' 'Ó'
        'Ãš' 'Ú'
        'Ã‘' 'Ñ'
        'Ã¤' 'ä'
        'Â¿' '¿'
        'Â¡' '¡'
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
alias corregir_letras='corregir_letras'
