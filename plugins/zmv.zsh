###########################################################################
# plugins/zmv.zsh
# Integración de zmv y limpieza masiva de nombres de archivo.
###########################################################################

###########################################################################
# Activación de zmv
###########################################################################

autoload -Uz zmv

alias zmv='noglob zmv'
alias limpiar_parentesis='noglob zmv '(*).(*)' '${${${1//\[[^]]#\]/}//\([^)]#\)/}//./ }.$2''
alias limpiar_espacio_final='noglob zmv '(*) .(*)' '$1.$2''
alias agregar_contador='noglob zmv '*' '${(l:3::0:)$((COUNTER++))} - $f''
setopt extended_glob



###########################################################################
# Función de limpieza de nombres de archivo
###########################################################################
# _limpiar_rellenar_numeros() {
#     emulate -L zsh
#     setopt extended_glob

#     local resto="$1" resultado="" previo numero

#     while [[ -n "$resto" ]]; do
#         if [[ "$resto" == (#b)([^0-9]#)([0-9]##)(*) ]]; then
#             previo="$match[1]"
#             numero="$match[2]"
#             resto="$match[3]"
#             (( ${#numero} < 3 )) && numero="${(l:3::0:)numero}"
#             resultado+="${previo}${numero}"
#         else
#             resultado+="$resto"
#             resto=""
#         fi
#     done

#     print -r -- "$resultado"
# }


# _limpiar_sustituir_guion() {
#     emulate -L zsh
#     setopt extended_glob

#     local nombre="$1"

#     if [[ "$nombre" == (#b)([^0-9]#[0-9]##)(\ )(*) ]]; then
#         nombre="${match[1]} - ${match[3]}"
#     fi

#     print -r -- "$nombre"
# }


# _limpiar_nombre_individual() {
#     emulate -L zsh
#     setopt extended_glob

#     local original="$1"
#     local nombre="${original:r}"
#     local extension="${original:e}"

#     local tiene_extension=0
#     [[ -n "$extension" && "$extension" != "$original" ]] && tiene_extension=1

#     local cadena_eliminar="$2"
#     local n_inicio="$3"
#     local n_final="$4"
#     local usar_prefijo="$5"
#     local usar_guion="$6"

#     if [[ -n "$cadena_eliminar" ]]; then
#         nombre="${nombre//${(b)cadena_eliminar}/}"
#     fi

#     nombre="${nombre//\([^()]#\)/}"
#     nombre="${nombre//\[[^][]#\]/}"

#     nombre="${nombre//[[:space:]]##/ }"
#     nombre="${nombre## }"
#     nombre="${nombre%% }"

#     if [[ -n "$n_inicio" && "$n_inicio" -gt 0 ]]; then
#         nombre="${nombre:$n_inicio}"
#     fi

#     if [[ -n "$n_final" && "$n_final" -gt 0 ]]; then
#         nombre="${nombre:0:$(( ${#nombre} - n_final ))}"
#     fi

#     if [[ "$usar_prefijo" == "1" ]]; then
#         nombre="${nombre##[^0-9]#}"
#     fi

#     nombre="$(_limpiar_rellenar_numeros "$nombre")"

#     if [[ "$usar_guion" == "1" ]]; then
#         nombre="$(_limpiar_sustituir_guion "$nombre")"
#     fi

#     if (( tiene_extension )); then
#         print -r -- "${nombre}.${extension}"
#     else
#         print -r -- "$nombre"
#     fi
# }


# limpiar-nombres() {
#     emulate -L zsh
#     setopt extended_glob null_glob

#     local patron="*"

#     local -a args_e args_i args_f args_p args_g args_n args_h
#     zparseopts -D -E -- \
#         e:=args_e -eliminar:=args_e \
#         i:=args_i -inicio:=args_i \
#         f:=args_f -final:=args_f \
#         p=args_p -prefijo=args_p \
#         g=args_g -guion=args_g \
#         n=args_n -simular=args_n \
#         h=args_h -ayuda=args_h

#     if (( ${#args_h} )); then
#         cat <<'EOF'
# Uso: limpiar-nombres [opciones] [patron]

#   patron         Patron glob de los archivos a procesar (por defecto: *)

# Opciones:
#   -e, --eliminar CADENA   Elimina esa cadena literal del nombre
#   -i, --inicio N          Elimina N caracteres del principio del nombre
#   -f, --final N           Elimina N caracteres del final del nombre
#   -p, --prefijo           Elimina todo lo anterior a la primera cifra
#   -g, --guion             Sustituye el espacio tras la 1a cifra por ' - '
#   -n, --simular           Muestra los cambios sin renombrar (modo prueba)
#   -h, --ayuda             Muestra esta ayuda
# EOF
#         return 0
#     fi

#     local cadena_eliminar="${args_e[2]:-}"
#     local n_inicio="${args_i[2]:-0}"
#     local n_final="${args_f[2]:-0}"
#     local usar_prefijo=0 usar_guion=0 simular=0
#     (( ${#args_p} )) && usar_prefijo=1
#     (( ${#args_g} )) && usar_guion=1
#     (( ${#args_n} )) && simular=1

#     (( $# )) && patron="$1"

#     local -a opciones_zmv
#     (( simular )) && opciones_zmv+=(-n)
#     opciones_zmv+=(-v -Q)

#     zmv $opciones_zmv "(${patron})(.)" \
#         '$(_limpiar_nombre_individual "$1" "'"$cadena_eliminar"'" "'"$n_inicio"'" "'"$n_final"'" "'"$usar_prefijo"'" "'"$usar_guion"'")'
# }
