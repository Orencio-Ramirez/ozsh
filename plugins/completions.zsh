###########################################################################
# plugins/completions.zsh
#
# Integración de zsh-completions.
#
# Aumenta el numero de comandos con autocompletar
###########################################################################

###########################################################################
# Comprobación de existencia del plugin
###########################################################################

if [[ -f $ZSH_DIR/externos/zsh-completions/zsh-completions.plugin.zsh ]]; then
    source $ZSH_DIR/externos/zsh-completions/zsh-completions.plugin.zsh
else
    return
fi

###########################################################################
# Comprobación de existencia del complemento Linux
###########################################################################

[[ -d /usr/share/zsh/functions/Completion/Linux ]] &&
    fpath=(/usr/share/zsh/functions/Completion/Linux $fpath)

###########################################################################
# Comprobación de existencia del complemento Debian
###########################################################################

[[ -d /usr/share/zsh/functions/Completion/Debian ]] &&
    fpath=(/usr/share/zsh/functions/Completion/Debian $fpath)

###########################################################################
# Comprobación de existencia del complemento Unix
###########################################################################

[[ -d /usr/share/zsh/functions/Completion/Unix ]] &&
    fpath=(/usr/share/zsh/functions/Completion/Unix $fpath)

###########################################################################
# Cargamos el Plugin
###########################################################################
autoload -Uz compinit
compinit

###########################################################################
# Visuales
###########################################################################
# Menu de seleccion
zstyle ':completion:*' menu select

# Colores
autoload -Uz colors && colors
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Coincidencia flexible
zstyle ':completion:*' matcher-list \
    'm:{a-z}={A-Z}' \
    'r:|=*' \
    'l:|=*'

# Agrupar resultados
zstyle ':completion:*' group-name ''

# Descripciones más legibles
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
###########################################################################
# Fin
###########################################################################