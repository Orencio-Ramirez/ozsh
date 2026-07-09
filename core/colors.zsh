###########################################################################
# core/colors.zsh
#
# Colores base del sistema.
# Este archivo puede ser sobrescrito por themes/.
###########################################################################

autoload -U colors
colors

# Reset
export C_RESET="%f"

# Base
export C_GRAY="%F{245}"
export C_DARK="%F{240}"
export C_WHITE="%F{255}"

# Acciones
export C_GREEN="%F{76}"
export C_BLUE="%F{39}"
export C_YELLOW="%F{220}"
export C_CYAN="%F{45}"
export C_MAGENTA="%F{177}"
export C_RED="%F{196}"

# Semantic colors
export C_USER="$C_GREEN"
export C_ROOT="$C_RED"
export C_PATH="$C_BLUE"
export C_GIT="$C_YELLOW"
export C_DOCKER="$C_CYAN"
export C_PYTHON="$C_MAGENTA"
export C_SSH="$C_CYAN"
export C_ERROR="$C_RED"
export C_TIMER="$C_GRAY"