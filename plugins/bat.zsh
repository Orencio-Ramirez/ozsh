###########################################################################
# plugins/bat.zsh
#
# Integración de bat (cat moderno con resaltado de sintaxis).
#
# Proporciona:
# - resaltado de sintaxis
# - numeración de líneas
# - integración con Git
# - paginación automática
#
# En Debian el ejecutable se llama "batcat".
###########################################################################

###########################################################################
# Comprobación de existencia
###########################################################################

if ! command -v batcat >/dev/null 2>&1; then
    return
fi

###########################################################################
# Configuración base
###########################################################################

# Opciones comunes para todos los comandos bat
export BAT_OPTIONS="--style=numbers,changes --paging=auto"

###########################################################################
# Alias principales
###########################################################################

# Alias estándar
alias cat="batcat $BAT_OPTIONS"

# Mantener acceso al ejecutable original con opciones
alias bat="batcat $BAT_OPTIONS"

###########################################################################
# Fin
###########################################################################