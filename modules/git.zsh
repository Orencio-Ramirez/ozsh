###########################################################################
# modules/git.zsh
#
# Estado de Git para el prompt.
#
# IMPORTANTE:
# - No se ejecuta en cada prompt
# - Solo se actualiza al cambiar de directorio (chpwd)
#
# Objetivo: cero coste en precmd.
###########################################################################

autoload -Uz add-zsh-hook

###########################################################################
# Variables globales del estado Git
###########################################################################

typeset -g __ZSH_GIT_BRANCH=""
typeset -g __ZSH_GIT_DIRTY=0
typeset -g __ZSH_IN_GIT_REPO=0

###########################################################################
# git::detect()
#
# Detecta si estamos en un repositorio Git.
###########################################################################

git::detect() {

    git rev-parse --is-inside-work-tree >/dev/null 2>&1

}

###########################################################################
# git::update()
#
# Actualiza TODO el estado Git.
# Se ejecuta SOLO en chpwd.
###########################################################################

git::update() {

    if ! git::detect; then
        __ZSH_IN_GIT_REPO=0
        __ZSH_GIT_BRANCH=""
        __ZSH_GIT_DIRTY=0
        return
    fi

    __ZSH_IN_GIT_REPO=1

    # Rama actual (rápido y sin forks pesados)
    __ZSH_GIT_BRANCH=$(git symbolic-ref --quiet --short HEAD 2>/dev/null)

    # Si no hay rama (detached HEAD)
    if [[ -z "$__ZSH_GIT_BRANCH" ]]; then
        __ZSH_GIT_BRANCH=$(git rev-parse --short HEAD 2>/dev/null)
    fi

    # Estado dirty (solo staged/unstaged)
    if git diff --quiet --ignore-submodules --cached &&
       git diff --quiet --ignore-submodules; then
        __ZSH_GIT_DIRTY=0
    else
        __ZSH_GIT_DIRTY=1
    fi
}

###########################################################################
# git::symbol()
#
# Devuelve representación visual para el prompt.
###########################################################################

git::symbol() {

    [[ $__ZSH_IN_GIT_REPO -eq 1 ]] || return

    local status_symbol=""

    if [[ "$__ZSH_GIT_DIRTY" -eq 1 ]]; then
        status_symbol="*"
    fi

    printf "%s %s%s" \
        "$I_GIT" \
        "$__ZSH_GIT_BRANCH" \
        "$status_symbol"

}

###########################################################################
# Hook: cambio de directorio
###########################################################################

__zsh_git_chpwd() {
    git::update
}

add-zsh-hook chpwd __zsh_git_chpwd

# Inicialización
git::update