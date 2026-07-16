###########################################################################
# plugins/eza.zsh
#
# Integración de eza (reemplazo moderno de ls).
#
# Proporciona:
# - colores mejorados
# - iconos (Nerd Font)
# - vista árbol
# - integración con git
#
# No modifica comportamiento de core, solo alias visuales.
###########################################################################

###########################################################################
# Comprobación de existencia
###########################################################################

if ! command -v eza >/dev/null 2>&1; then
    return
fi

###########################################################################
# Configuración base
###########################################################################

# Opciones comunes para todos los comandos eza
export EZA_OPTIONS="--icons --git --group-directories-first --group"

###########################################################################
# Alias principales
###########################################################################

# Sustituye ls completamente
alias ls="eza $EZA_OPTIONS"

# Lista simple
alias l="eza $EZA_OPTIONS"

# Lista detallada
alias ll="eza -lah $EZA_OPTIONS"

# Mostrar archivos ocultos
alias la="eza -la $EZA_OPTIONS"

###########################################################################
# Vista en árbol
###########################################################################

# Árbol ligero
alias lt="eza --tree --level=2 $EZA_OPTIONS"

# Árbol profundo
alias ltt="eza --tree --level=4 $EZA_OPTIONS"

###########################################################################
# Vista solo directorios
###########################################################################

alias lsd="eza -D $EZA_OPTIONS"

###########################################################################
# Fin
###########################################################################