#!/bin/sh
set -e

function main() {
    echo "Retagging and Pushing to Docker registry..."

    #sanitize "${INPUT_NAME}" "name"
    #sanitize "${INPUT_USERNAME}" "username"
    #sanitize "${INPUT_PASSWORD}" "password"

    # docker login
    echo ${INPUT_PASSWORD} | docker login -u ${INPUT_USERNAME} --password-stdin ${INPUT_REGISTRY}

    #REGISTRY_NO_PROTOCOL=$(echo "${INPUT_REGISTRY}" | sed -e 's/^https:\/\///g')
    OLD_DOCKER_NAME="${INPUT_NAME}:${INPUT_OLD_TAG}"
    NEW_DOCKER_NAME="${INPUT_NAME}:${INPUT_NEW_TAG}"

    # tag and push
    docker tag ${OLD_DOCKER_NAME} ${NEW_DOCKER_NAME}
    docker push ${NEW_DOCKER_NAME}

    # logout
    docker logout
}
main