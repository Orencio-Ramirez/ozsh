###########################################################################
# modules/python.zsh
#
# Estado de entorno Python.
###########################################################################

typeset -g __ZSH_PYTHON_ENV=""

###########################################################################
# python::update()
#
# Detecta entorno activo.
###########################################################################

python::update() {

    if [[ -n "$VIRTUAL_ENV" ]]; then
        __ZSH_PYTHON_ENV="${VIRTUAL_ENV:t}"
        return
    fi

    if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        __ZSH_PYTHON_ENV="$CONDA_DEFAULT_ENV"
        return
    fi

    __ZSH_PYTHON_ENV=""
}

###########################################################################
# python::symbol()
###########################################################################

python::symbol() {

    [[ -n "$__ZSH_PYTHON_ENV" ]] || return

    printf "%s %s" \
        "$I_PYTHON" \
        "$__ZSH_PYTHON_ENV"

}

###########################################################################
# Hook
###########################################################################

__zsh_python_chpwd() {
    python::update
}

add-zsh-hook chpwd __zsh_python_chpwd

python::update