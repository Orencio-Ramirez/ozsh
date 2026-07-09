###########################################################################
# core/options.zsh
#
# Opciones fundamentales de Zsh.
# No contiene lógica de usuario ni plugins.
# Solo comportamiento base de la shell.
###########################################################################

###########################################################################
# Navegación
###########################################################################

# Permite ejecutar un directorio como comando (cd implícito)
setopt AUTO_CD

# Guarda historial de directorios (cd -, pushd, popd)
setopt AUTO_PUSHD

# Evita duplicados en la pila de directorios
setopt PUSHD_IGNORE_DUPS

###########################################################################
# Interacción
###########################################################################

# Permite comentarios en terminal interactiva
setopt INTERACTIVE_COMMENTS

# Desactiva beep del terminal
setopt NO_BEEP

###########################################################################
# Expansión y globbing
###########################################################################

# Activa patrones avanzados (*, ^, ~)
setopt EXTENDED_GLOB

# Expansión de llaves {1..10}
setopt BRACE_CCL

###########################################################################
# Prompt
###########################################################################

# Permite evaluar variables en prompt
setopt PROMPT_SUBST

###########################################################################
# Seguridad
###########################################################################

# Evita sobrescritura accidental con >
setopt NO_CLOBBER

###########################################################################
# Jobs
###########################################################################

# Notifica inmediatamente cambios en jobs en background
setopt NOTIFY

###########################################################################
# Fin
###########################################################################