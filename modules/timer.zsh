###########################################################################
# modules/timer.zsh
#
# Formateo del tiempo de ejecución.
###########################################################################

typeset -g __ZSH_TIMER=0

###########################################################################
# timer::update()
#
# Convierte segundos a formato humano.
###########################################################################

timer::update() {

    local t="$__ZSH_LAST_CMD_TIME"

    __ZSH_TIMER=""

    # No mostrar si es menor de 1 segundo
    (( $(echo "$t < 1" | bc -l 2>/dev/null) )) && return

    # ms si es pequeño
    if (( $(echo "$t < 10" | bc -l 2>/dev/null) )); then
        __ZSH_TIMER="$(printf "%.0fms" "$(echo "$t * 1000" | bc -l)")"
    else
        __ZSH_TIMER="$(printf "%.2fs" "$t")"
    fi
}

###########################################################################
# timer::symbol()
###########################################################################

timer::symbol() {

    [[ -n "$__ZSH_TIMER" ]] || return

    printf "%s %s" "$I_TIMER" "$__ZSH_TIMER"

}