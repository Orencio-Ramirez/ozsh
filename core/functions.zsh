###########################################################################
# core/functions.zsh
#
# Funciones utilitarias globales del sistema ZSH.
#
# REGLAS:
# - No debe contener lógica de módulos (git/docker/python/etc)
# - No debe modificar estado del prompt
# - Solo helpers reutilizables
###########################################################################

###########################################################################
# command_exists
#
# Comprueba si un comando existe en el sistema.
###########################################################################

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

###########################################################################
# is_git_repo
#
# Detecta si estamos dentro de un repositorio git.
# (helper genérico, no estado de prompt)
###########################################################################

is_git_repo() {
    git rev-parse --is-inside-work-tree >/dev/null 2>&1
}

###########################################################################
# current_dir
#
# Devuelve directorio actual de forma segura.
###########################################################################

current_dir() {
    print -P "%~"
}

###########################################################################
# is_root
#
# Detecta si el usuario actual es root.
###########################################################################

is_root() {
    [[ "$EUID" -eq 0 ]]
}

###########################################################################
# is_ssh_session
#
# Detecta si la sesión es remota (SSH).
###########################################################################

is_ssh_session() {
    [[ -n "$SSH_CONNECTION" || -n "$SSH_CLIENT" ]]
}

###########################################################################
# stopwatch_start
#
# Utilidad simple de tiempo (fallback o debug).
###########################################################################

stopwatch_start() {
    __ZSH_SW_START=$EPOCHREALTIME
}

###########################################################################
# stopwatch_stop
#
# Devuelve duración desde stopwatch_start.
###########################################################################

stopwatch_stop() {
    local end=$EPOCHREALTIME
    print "$(( end - __ZSH_SW_START ))"
}

###########################################################################
# mkcd
#
# Crear directorio y entrar en él.
###########################################################################

mkcd() {
    mkdir -p "$1" && cd "$1"
}

###########################################################################
# extract
#
# Extractor universal básico.
###########################################################################

extract() {

    [[ -f "$1" ]] || return 1

    case "$1" in
        *.tar.gz) tar -xzf "$1" ;;
        *.tar.bz2) tar -xjf "$1" ;;
        *.tar.xz) tar -xJf "$1" ;;
        *.zip) unzip "$1" ;;
        *.7z) 7z x "$1" ;;
        *) echo "Formato no soportado: $1" ;;
    esac
}