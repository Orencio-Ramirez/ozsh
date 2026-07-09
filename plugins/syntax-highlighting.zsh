###########################################################################
# plugins/syntax-highlighting.zsh
#
# Integración de zsh-syntax-highlighting.
#
# Colorea comandos en tiempo real:
#
# - verde: comando válido
# - rojo: comando inválido
# - amarillo: rutas / argumentos especiales
#
# Se ejecuta SIEMPRE al final de la carga de plugins.
###########################################################################

###########################################################################
# Comprobación de existencia
###########################################################################

if [[ -f $ZSH_DIR/externos/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source $ZSH_DIR/externos/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
    return
fi

# ###########################################################################
# # Estilos visuales
# ###########################################################################

# # Comando correcto
# ZSH_HIGHLIGHT_STYLES[command]="fg=76"

# # Comando incorrecto (no existe)
# ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=196,bold"

# # Ruta existente
# ZSH_HIGHLIGHT_STYLES[path]="fg=39"

# # Strings
# ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=220"

# ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=220"

# ###########################################################################
# # Opcional: subrayado en errores (más visible en dark themes)
# ###########################################################################

# ZSH_HIGHLIGHT_STYLES[bad-pattern]="fg=196,underline"

###########################################################################
# Fin
###########################################################################