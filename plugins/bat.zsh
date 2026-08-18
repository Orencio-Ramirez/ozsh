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
# El nombre del ejecutable varía según la distribución:
#   - Fedora y derivadas (RHEL, CentOS Stream, Rocky, AlmaLinux): "bat"
#   - Debian, Ubuntu y derivadas: "batcat"
#     (el paquete "bat" en Debian/Ubuntu instala el binario como "batcat"
#     por un conflicto de nombre con otro paquete preexistente)
###########################################################################

###########################################################################
# Detección del ejecutable
###########################################################################

if command -v bat >/dev/null 2>&1; then
    BAT_CMD="bat"
elif command -v batcat >/dev/null 2>&1; then
    BAT_CMD="batcat"
else
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
alias cat="$BAT_CMD $BAT_OPTIONS"

# Mantener acceso al ejecutable con opciones bajo el nombre "bat",
# independientemente de cómo se llame el binario real.
alias bat="$BAT_CMD $BAT_OPTIONS"

###########################################################################
# Limpieza
###########################################################################

unset BAT_CMD

###########################################################################
# Fin
###########################################################################