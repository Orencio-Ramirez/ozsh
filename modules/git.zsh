###########################################################################
# modules/git.zsh
#
# Estado Git para el prompt.
#
# IMPORTANTE:
# - No registra hooks.
# - git::update() debe llamarse desde precmd.
###########################################################################

###########################################################################
# Variables globales
###########################################################################

typeset -g __ZSH_GIT_BRANCH=""
integer -g __ZSH_GIT_DIRTY=0
integer -g __ZSH_IN_GIT_REPO=0

###########################################################################
# git::update()
#
# Actualiza el estado del repositorio Git.
###########################################################################

git::update() {

    local branch

    #######################################################################
    # Detectar rama actual
    #######################################################################

    branch=$(git branch --show-current 2>/dev/null)

    #######################################################################
    # Detached HEAD
    #######################################################################

    if [[ -z $branch ]]; then
        branch=$(git rev-parse --short HEAD 2>/dev/null) || {
            __ZSH_IN_GIT_REPO=0
            __ZSH_GIT_BRANCH=""
            __ZSH_GIT_DIRTY=0
            return
        }
    fi

    __ZSH_IN_GIT_REPO=1
    __ZSH_GIT_BRANCH=$branch

    #######################################################################
    # Estado dirty
    #######################################################################

    if git diff --quiet --ignore-submodules --cached &&
       git diff --quiet --ignore-submodules; then
        __ZSH_GIT_DIRTY=0
    else
        __ZSH_GIT_DIRTY=1
    fi
}

###########################################################################
# Inicialización
###########################################################################

git::update