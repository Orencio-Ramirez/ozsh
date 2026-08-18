#!/usr/bin/env bash
###############################################################################
# install.sh
#
# Instalador del entorno ZSH.
#
# Características
#   - Detecta automáticamente la distribución (Debian, Ubuntu y derivadas,
#     además de Fedora).
#   - Instala las dependencias necesarias.
#   - Descarga o actualiza los plugins externos.
#   - Genera un .zshrc limpio.
#   - Cambia la shell por defecto.
#
# El script es idempotente y puede ejecutarse varias veces.
###############################################################################

set -Eeuo pipefail

###############################################################################
# Variables globales
###############################################################################

readonly SCRIPT_NAME="$(basename "$0")"
readonly ZSH_DIR="$HOME/ozsh"
readonly ZSHRC="$HOME/.zshrc"
readonly BACKUP="$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
readonly PLUGIN_DIR="$ZSH_DIR/externos"
readonly LOG_FILE="$HOME/ozsh-install.log"

# OZSH_VERSION se resuelve más adelante, una vez comprobado que
# $ZSH_DIR existe (ver check_requirements + set_version).
OZSH_VERSION=""

###############################################################################
# Colores (solo si la salida es un terminal)
###############################################################################

if [[ -t 1 ]]; then
    readonly RED="\033[31m"
    readonly GREEN="\033[32m"
    readonly YELLOW="\033[33m"
    readonly BLUE="\033[34m"
    readonly RESET="\033[0m"
else
    readonly RED=""
    readonly GREEN=""
    readonly YELLOW=""
    readonly BLUE=""
    readonly RESET=""
fi

###############################################################################
# Logging
###############################################################################

# Todo lo que se imprima a partir de aquí queda también registrado en
# $LOG_FILE, conservando la salida por pantalla.
exec > >(tee -a "$LOG_FILE") 2>&1

###############################################################################
# Mensajes
###############################################################################

info() {
    printf "${BLUE}==>${RESET} %s\n" "$*"
}

success() {
    printf "${GREEN}==>${RESET} %s\n" "$*"
}

warning() {
    printf "${YELLOW}==>${RESET} %s\n" "$*"
}

error() {
    printf "${RED}==>${RESET} %s\n" "$*" >&2
}

###############################################################################
# Gestión de errores
###############################################################################

on_error() {
    local exit_code="$?"
    error "Error durante la instalación."
    error "Línea : ${BASH_LINENO[0]}"
    error "Código: ${exit_code}"
    error "Log completo en: $LOG_FILE"
    exit "${exit_code}"
}

trap on_error ERR

###############################################################################
# Sudo keep-alive
###############################################################################

SUDO_KEEPALIVE_PID=""

start_sudo_keepalive() {
    # Refresca el timestamp de sudo cada 60s en segundo plano para que
    # instalaciones largas no pidan la contraseña de nuevo a mitad de proceso.
    while true; do
        sudo -n true
        sleep 60
    done 2>/dev/null &
    SUDO_KEEPALIVE_PID="$!"
}

stop_sudo_keepalive() {
    if [[ -n "$SUDO_KEEPALIVE_PID" ]]; then
        kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true
        wait "$SUDO_KEEPALIVE_PID" 2>/dev/null || true
    fi
}

trap stop_sudo_keepalive EXIT

###############################################################################
# Ejecutar paso
###############################################################################

run_step() {
    local description="$1"
    shift
    info "$description"
    "$@"
}

###############################################################################
# Backup de configuración existente
###############################################################################

backup_zshrc() {
    if [[ ! -f "$ZSHRC" ]]; then
        info "No existe un .zshrc previo."
        return
    fi
    info "Creando copia de seguridad"
    cp "$ZSHRC" "$BACKUP"
    success "Backup creado: $BACKUP"
}

###############################################################################
# Comprobaciones
###############################################################################

check_requirements() {
    if [[ ! -d "$ZSH_DIR" ]]; then
        error "No existe el directorio:"
        error "  $ZSH_DIR"
        exit 1
    fi
    if [[ ! -f "$ZSH_DIR/install.sh" ]]; then
        warning "No parece que estés ejecutando el instalador desde el repositorio."
    fi
    if [[ ! -f "$ZSH_DIR/VERSION" ]]; then
        error "No se encontró el archivo VERSION en:"
        error "  $ZSH_DIR/VERSION"
        exit 1
    fi
}

###############################################################################
# Resolver versión de ozsh
###############################################################################

set_version() {
    OZSH_VERSION="$(<"$ZSH_DIR/VERSION")"
}

###############################################################################
# Detección del sistema operativo
###############################################################################

detect_os() {
    if [[ ! -f /etc/os-release ]]; then
        error "/etc/os-release no encontrado."
        exit 1
    fi
    source /etc/os-release

    # Se comprueba tanto ID como ID_LIKE para cubrir todas las distros
    # derivadas de Debian (Ubuntu, Linux Mint, Pop!_OS, elementary OS,
    # Zorin OS, Raspberry Pi OS, MX Linux, Kali, etc.), no solo Debian puro.
    local id_like="${ID_LIKE:-}"

    case "$ID $id_like" in
        *debian*|*ubuntu*)
            OS="debian"
            ;;
        *fedora*)
            OS="fedora"
            ;;
        *)
            error "Distribución no soportada: $ID"
            exit 1
            ;;
    esac
    success "Sistema detectado: $PRETTY_NAME (familia: $OS)"
}

###############################################################################
# Comprobar conexión de red
###############################################################################

check_network() {
    info "Comprobando conexión a Internet"
    if ! curl \
        --silent \
        --head \
        --fail \
        https://github.com >/dev/null; then
        error "No hay conexión a Internet."
        exit 1
    fi
}

###############################################################################
# Comprobar Git
###############################################################################

check_git() {
    command -v git >/dev/null 2>&1 || {
        error "Git no está instalado."
        exit 1
    }
}

###############################################################################
# Solicitar privilegios
###############################################################################

check_sudo() {
    sudo -v
    start_sudo_keepalive
    success "Privilegios concedidos"
}

###############################################################################
# Instalar dependencias
###############################################################################

install_packages() {
    local packages=(
        zsh
        git
        curl
        bat
        eza
        fzf
        direnv
        zoxide
    )
    case "$OS" in
        debian)
            info "Actualizando repositorios"
            sudo apt update
            info "Instalando paquetes"
            sudo apt install -y "${packages[@]}"
            ;;
        fedora)
            info "Instalando paquetes"
            sudo dnf install -y "${packages[@]}"
            ;;
    esac
    success "Dependencias instaladas"
}

###############################################################################
# Plugins externos
###############################################################################

readonly PLUGINS=(
    "https://github.com/zsh-users/zsh-completions.git"
    "https://github.com/zsh-users/zsh-autosuggestions.git"
    "https://github.com/zsh-users/zsh-syntax-highlighting.git"
    "https://github.com/zsh-users/zsh-history-substring-search.git"
)

###############################################################################
# Instalar o actualizar un plugin
###############################################################################

install_plugin() {
    local repo="$1"
    local name
    local dir
    name="$(basename "$repo" .git)"
    dir="$PLUGIN_DIR/$name"
    if [[ -d "$dir/.git" ]]; then
        info "Actualizando $name"
        # Los clones son --depth=1, así que un pull --ff-only puede fallar
        # si el remoto reescribió historia. Como son plugins de solo
        # lectura (no se hacen commits locales), es más robusto forzar
        # el estado al del remoto.
        git -C "$dir" fetch \
            --depth=1 \
            --quiet \
            origin
        git -C "$dir" reset \
            --hard \
            --quiet \
            origin/HEAD
    else
        info "Descargando $name"
        git clone \
            --depth=1 \
            --single-branch \
            --quiet \
            "$repo" \
            "$dir"
    fi
}

###############################################################################
# Instalar plugins externos
###############################################################################

install_external_plugins() {
    mkdir -p "$PLUGIN_DIR" || {
        error "No se pudo crear el directorio de plugins."
        return 1
    }
    local plugin
    for plugin in "${PLUGINS[@]}"; do
        install_plugin "$plugin"
    done
}

###############################################################################
# Generar el .zshrc
###############################################################################

create_zshrc() {
    cat > "$ZSHRC" <<'EOF'
###############################################################################
# Archivo generado automáticamente.
###############################################################################

export ZSH_DIR="$HOME/ozsh"
export ZSH_CONFIG="$ZSH_DIR"
zmodload zsh/datetime

###############################################################################
# Core
###############################################################################

source "$ZSH_CONFIG/core/options.zsh"
source "$ZSH_CONFIG/core/exports.zsh"
source "$ZSH_CONFIG/core/colors.zsh"
source "$ZSH_CONFIG/core/icons.zsh"
source "$ZSH_CONFIG/core/history.zsh"
source "$ZSH_CONFIG/core/hooks.zsh"
source "$ZSH_CONFIG/core/prompt.zsh"
source "$ZSH_CONFIG/core/keybindings.zsh"

###############################################################################
# Modules
###############################################################################

source "$ZSH_CONFIG/modules/git.zsh"
source "$ZSH_CONFIG/modules/docker.zsh"
source "$ZSH_CONFIG/modules/python.zsh"
source "$ZSH_CONFIG/modules/ssh.zsh"
source "$ZSH_CONFIG/modules/root.zsh"
source "$ZSH_CONFIG/modules/timer.zsh"
source "$ZSH_CONFIG/modules/terraform.zsh"

###############################################################################
# Plugins
###############################################################################

source "$ZSH_CONFIG/plugins/fzf.zsh"
source "$ZSH_CONFIG/plugins/bat.zsh"
source "$ZSH_CONFIG/plugins/eza.zsh"
source "$ZSH_CONFIG/plugins/zoxide.zsh"
source "$ZSH_CONFIG/plugins/direnv.zsh"
source "$ZSH_CONFIG/plugins/completions.zsh"
source "$ZSH_CONFIG/plugins/autosuggestions.zsh"
source "$ZSH_CONFIG/plugins/syntax-highlighting.zsh"
source "$ZSH_CONFIG/plugins/history-substring-search.zsh"
EOF
    success ".zshrc generado"
}

###############################################################################
# Cambiar shell por defecto
###############################################################################

change_shell() {
    local current_shell
    local zsh_shell
    current_shell="$(getent passwd "$USER" | cut -d: -f7)"
    zsh_shell="$(command -v zsh)"
    if [[ "$current_shell" == "$zsh_shell" ]]; then
        success "Zsh ya es la shell por defecto."
        return
    fi
    if ! grep -Fxq "$zsh_shell" /etc/shells; then
        error "La shell '$zsh_shell' no está registrada en /etc/shells."
        return 1
    fi
    chsh -s "$zsh_shell"
    success "Shell configurada correctamente."
}

###############################################################################
# Instalación
###############################################################################

run_step "Comprobando requisitos" check_requirements
run_step "Resolviendo versión" set_version

info "Instalando ozsh $OZSH_VERSION"
run_step "Comprobando conexión de red" check_network
run_step "Solicitando privilegios" check_sudo
run_step "Detectando sistema operativo" detect_os
run_step "Instalando dependencias" install_packages
run_step "Comprobando Git" check_git
run_step "Instalando plugins externos" install_external_plugins
run_step "Realizando copia de seguridad" backup_zshrc
run_step "Generando .zshrc" create_zshrc
run_step "Configurando shell" change_shell

echo
success "Instalación completada correctamente."
echo
echo "Es recomendable cerrar la sesión para comenzar a utilizar Zsh."
