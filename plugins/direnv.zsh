###########################################################################
# plugins/direnv.zsh
#
# Integración de direnv con ZSH.
#
# Permite cargar variables de entorno automáticamente al entrar en
# directorios que contengan un archivo .envrc
#
# Ejemplos:
#
#   cd proyecto
#   -> carga automáticamente variables del proyecto
#
###########################################################################

###########################################################################
# Comprobación de existencia
###########################################################################

if ! command -v direnv >/dev/null 2>&1; then
    return
fi

###########################################################################
# Hook de integración
###########################################################################

# direnv hook se encarga de actualizar entorno en cada cambio de directorio
eval "$(direnv hook zsh)"

###########################################################################
# Opciones recomendadas
###########################################################################

# Silencia salida si no hay cambios
export DIRENV_LOG_FORMAT=""

###########################################################################
# Seguridad
###########################################################################

# direnv requiere aprobación explícita de .envrc
#
# Esto evita ejecución accidental de scripts maliciosos.
#
# Comandos útiles:
#
#   direnv allow
#   direnv deny
#
###########################################################################

###########################################################################
# Fin
###########################################################################