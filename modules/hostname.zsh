###########################################################################
# modules/hostname.zsh
#
# Hostname simplificado para SSH.
###########################################################################

typeset -g __ZSH_HOSTNAME=""

hostname::update() {
    __ZSH_HOSTNAME=$(hostname -s 2>/dev/null)
}

hostname::update