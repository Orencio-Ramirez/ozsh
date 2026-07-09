###########################################################################
# modules/docker.zsh
#
# Detección de proyectos Docker.
#
# IMPORTANTE:
# No se consulta el daemon Docker.
# Solo presencia de archivos.
###########################################################################

typeset -g __ZSH_DOCKER_PROJECT=0

###########################################################################
# docker::update()
###########################################################################

docker::update() {

    local files=(
        docker-compose.yml
        docker-compose.yaml
        compose.yml
        compose.yaml
        Dockerfile
        devcontainer.json
    )

    local f

    for f in "${files[@]}"; do
        if [[ -f "$f" ]]; then
            __ZSH_DOCKER_PROJECT=1
            return
        fi
    done

    __ZSH_DOCKER_PROJECT=0
}

###########################################################################
# docker::symbol()
###########################################################################

docker::symbol() {

    [[ $__ZSH_DOCKER_PROJECT -eq 1 ]] || return

    printf "%s" "$I_DOCKER"

}

###########################################################################
# Hook
###########################################################################

__zsh_docker_chpwd() {
    docker::update
}

add-zsh-hook chpwd __zsh_docker_chpwd

docker::update