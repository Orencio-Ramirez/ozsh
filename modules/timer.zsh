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

    local -F t=$__ZSH_LAST_CMD_TIME

    __ZSH_TIMER=""

    if (( t < 1.0 )); then
        return
    elif (( t < 10.0 )); then
        printf -v __ZSH_TIMER "%.0fms" "$(( t * 1000.0 ))"
    else
        printf -v __ZSH_TIMER "%.2fs" "$t"
    fi
}

###########################################################################
# timer::symbol()
###########################################################################

timer::symbol() {

    [[ -n "$__ZSH_TIMER" ]] || return

    printf "%s %s" "$I_TIMER" "$__ZSH_TIMER"

}