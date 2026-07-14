###########################################################################
# core/prompt.zsh
#
# Prompt principal del sistema.
#
# RESPONSABILIDAD:
# - NO calcula estado
# - NO ejecuta comandos externos
# - SOLO renderiza variables ya preparadas
###########################################################################

autoload -Uz add-zsh-hook

###########################################################################
# Reset visual rápido
###########################################################################

setopt PROMPT_SUBST

###########################################################################
# Línea 1: estado del sistema
###########################################################################

zle-line-init() {
    zle reset-prompt
}
zle -N zle-line-init

###########################################################################
# Construcción de línea superior (status bar)
###########################################################################

__zsh_prompt_top() {

    local parts=()

    # Fecha y hora
    parts+="${C_GRAY}${I_CLOCK} %D{%Y-%m-%d %H:%M:%S}${C_RESET}"

    # Timer (solo si existe)
    if [[ -n "$__ZSH_TIMER" ]]; then
        parts+="${C_TIMER}${I_TIMER} $__ZSH_TIMER${C_RESET}"
    fi

    # Error code
    if [[ "$__ZSH_LAST_EXIT" -ne 0 ]]; then
        parts+="${C_ERROR}${I_ERROR}$__ZSH_LAST_EXIT${C_RESET}"
    fi

    # SSH
    if [[ "$__ZSH_IN_SSH" -eq 1 ]]; then
        parts+="${C_SSH}${I_SSH} SSH${C_RESET}"
    fi

    printf "%s\n" "${(j: :)parts}"
}

###########################################################################
# Línea 2: contexto de trabajo
###########################################################################

__zsh_prompt_bottom() {

    local parts=()
    local host_color user_color

    #######################################################################
    # Colores de host y usuario
    #######################################################################

    # Usuario root siempre en rojo
    if (( EUID == 0 )); then
        user_color="$C_ERROR"
    else
        user_color="$C_USER"
    fi

    # Host rojo únicamente si es una sesión SSH
    if [[ "$__ZSH_IN_SSH" -eq 1 ]]; then
        host_color="$C_ERROR"
    else
        host_color="$C_USER"
    fi

    # Host@usuario
    parts+="${host_color}%m${C_RESET}${C_GRAY}@${C_RESET}${user_color}%n${C_RESET}"

    # Path
    parts+="${C_PATH}%~${C_RESET}"

    # Git
    if [[ -n "$__ZSH_GIT_BRANCH" ]]; then
        if [[ "$__ZSH_GIT_DIRTY" -eq 1 ]]; then
            parts+="${C_GIT}${I_GIT} ${__ZSH_GIT_BRANCH}*${C_RESET}"
        else
            parts+="${C_GIT}${I_GIT} ${__ZSH_GIT_BRANCH}${C_RESET}"
        fi
    fi

    # Python
    if [[ -n "$__ZSH_PYTHON_ENV" ]]; then
        parts+="${C_PYTHON}${I_PYTHON} ${__ZSH_PYTHON_ENV}${C_RESET}"
    fi

    # Docker
    if [[ "$__ZSH_DOCKER_PROJECT" -eq 1 ]]; then
        parts+="${C_DOCKER}${I_DOCKER}${C_RESET}"
    fi

    # Terraform
    if [[ "$__ZSH_TERRAFORM_PROJECT" -eq 1 ]]; then
        parts+="${C_TERRAFORM}${I_TERRAFORM}${C_RESET}"
    fi

    printf "%s\n" "${(j: :)parts}"
}

###########################################################################
# Prompt final
###########################################################################

PROMPT='
$(__zsh_prompt_top)
$(__zsh_prompt_bottom)
${C_CYAN}❯${C_RESET} '