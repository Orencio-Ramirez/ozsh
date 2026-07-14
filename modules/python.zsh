###########################################################################
# modules/python.zsh
#
# Estado del entorno Python.
#
# IMPORTANTE:
# - No registra hooks.
# - python::update() debe llamarse desde precmd.
###########################################################################

###########################################################################
# Variables globales
###########################################################################

typeset -g __ZSH_PYTHON_ENV=""

###########################################################################
# python::update()
#
# Detecta el entorno Python activo.
###########################################################################

python::update() {

    if [[ -n $VIRTUAL_ENV ]]; then
        __ZSH_PYTHON_ENV=${VIRTUAL_ENV:t}
    elif [[ -n $CONDA_DEFAULT_ENV ]]; then
        __ZSH_PYTHON_ENV=$CONDA_DEFAULT_ENV
    else
        __ZSH_PYTHON_ENV=""
    fi
}

###########################################################################
# Inicialización
###########################################################################

python::update