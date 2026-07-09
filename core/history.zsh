###########################################################################
# core/history.zsh
#
# Historial de comandos.
###########################################################################

###########################################################################
# Persistencia
###########################################################################

setopt SHARE_HISTORY        # comparte historial entre sesiones
setopt INC_APPEND_HISTORY   # escribe inmediatamente
setopt HIST_FCNTL_LOCK      # locking seguro
setopt SHARE_HISTORY        # Compartir historial entre terminales.
###########################################################################
# Limpieza
###########################################################################

setopt HIST_IGNORE_DUPS     # evita duplicados consecutivos
setopt HIST_IGNORE_ALL_DUPS # elimina duplicados globales
setopt HIST_IGNORE_SPACE    # ignora comandos con espacio inicial
setopt HIST_REDUCE_BLANKS   # limpia espacios extra

###########################################################################
# Seguridad
###########################################################################

setopt HIST_VERIFY          # revisa antes de ejecutar desde historial
setopt EXTENDED_HISTORY     # guarda timestamp

###########################################################################
# Fin
###########################################################################