###########################################################################
# modules/terraform.zsh
#
# Detección de proyectos Terraform.
#
# IMPORTANTE:
# No ejecuta terraform.
# Solo comprueba la presencia de archivos.
###########################################################################

typeset -g __ZSH_TERRAFORM_PROJECT=0

###########################################################################
# terraform::update()
###########################################################################

terraform::update() {

    local matches

    matches=( *.tf(N) *.tf.json(N) )

    if (( ${#matches} > 0 )) || [[ -f .terraform.lock.hcl ]]; then
        __ZSH_TERRAFORM_PROJECT=1
    else
        __ZSH_TERRAFORM_PROJECT=0
    fi
}

###########################################################################
# terraform::symbol()
###########################################################################

terraform::symbol() {

    [[ $__ZSH_TERRAFORM_PROJECT -eq 1 ]] || return

    printf "%s" "$I_TERRAFORM"
}

###########################################################################
# Hook
###########################################################################

__zsh_terraform_chpwd() {
    terraform::update
}

add-zsh-hook chpwd __zsh_terraform_chpwd

terraform::update