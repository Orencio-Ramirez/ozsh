###########################################################################
# modules/docker.zsh
#
# Detección de proyectos Docker.
#
# IMPORTANTE:
# No se consulta el daemon Docker.
# Solo presencia de archivos.
###########################################################################

integer -g __ZSH_DOCKER_PROJECT=0

###########################################################################
# docker::update()
###########################################################################

docker::update() {

    if [[ -f Dockerfile            ||
          -f docker-compose.yml    ||
          -f docker-compose.yaml   ||
          -f compose.yml           ||
          -f compose.yaml          ||
          -f devcontainer.json ]]; then
        __ZSH_DOCKER_PROJECT=1
    else
        __ZSH_DOCKER_PROJECT=0
    fi
}

###########################################################################
# Hook
###########################################################################

add-zsh-hook chpwd docker::update

docker::update