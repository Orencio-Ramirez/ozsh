###########################################################################
# hooks.zsh (FIX)
#
# Corrección del sistema de medición de tiempo.
###########################################################################

typeset -gF __ZSH_CMD_START=0
typeset -gF __ZSH_LAST_CMD_TIME=0
typeset -g __ZSH_LAST_EXIT=0

###########################################################################
# PREEXEC
#
# Se ejecuta justo antes de ejecutar el comando.
###########################################################################

__zsh_preexec() {
    __ZSH_CMD_START=$EPOCHREALTIME
}

###########################################################################
# PRECMD
#
# Se ejecuta justo antes de mostrar el prompt.
###########################################################################

__zsh_precmd() {

    local last_exit=$?

    __ZSH_LAST_EXIT=$last_exit

    if (( __ZSH_CMD_START > 0 )); then
        __ZSH_LAST_CMD_TIME=$(( EPOCHREALTIME - __ZSH_CMD_START ))
        __ZSH_CMD_START=0
    else
        __ZSH_LAST_CMD_TIME=0
    fi

    timer::update
    git::update
}

###########################################################################
# REGISTRO DE HOOKS (IMPORTANTE ORDEN)
###########################################################################

autoload -Uz add-zsh-hook

add-zsh-hook preexec __zsh_preexec
add-zsh-hook precmd  __zsh_precmd