#!/bin/sh
set -e

function main() {
    echo ""

    sanitize "${INPUT_REGISTRY}" "registry"
    sanitize "${INPUT_NAME}" "name"
    sanitize "${INPUT_OLD_TAG}" "old_tag"
    sanitize "${INPUT_NEW_TAG}" "new_tag"

    # Registry without the https in front
    REGISTRY_NO_PROTOCOL=$(echo "${INPUT_REGISTRY}" | sed -e 's/^https:\/\///g')

    # docker login
    if uses "${INPUT_USERNAME}" && uses "${INPUT_PASSWORD}"; then
        echo "${INPUT_PASSWORD}" | docker login -u ${INPUT_USERNAME} --password-stdin ${REGISTRY_NO_PROTOCOL}
    fi

    OLD_DOCKER_NAME="${REGISTRY_NO_PROTOCOL}/${INPUT_NAME}:${INPUT_OLD_TAG}"
    NEW_DOCKER_NAME="${REGISTRY_NO_PROTOCOL}/${INPUT_NAME}:${INPUT_NEW_TAG}"

    # tag and push
    docker tag ${OLD_DOCKER_NAME} ${NEW_DOCKER_NAME}
    docker push ${NEW_DOCKER_NAME}

    # logout
    if uses "${INPUT_USERNAME}" && uses "${INPUT_PASSWORD}"; then
        docker logout;
    fi
}

sanitize() {
  if [ -z "${1}" ]; then
    >&2 echo "Unable to find the ${2}. Did you set with.${2}?"
    exit 1
  fi
}

uses() {
  [ ! -z "${1}" ]
}


main
