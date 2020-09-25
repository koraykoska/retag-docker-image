#!/bin/sh
set -e

log() {
  echo "> ${*}"
  eval "$@"
}

# parse the variables that are passed in the input params
parseArg() {
  eval "echo ${1:-$2}"
}

main() {
    echo "Re-tagging and Pushing to Docker registry..."

    # pull variables from "with" but default back to "env"
    # this would allow jobs may be set up with less lines in steps
    INPUT_REGISTRY=$(parseArg "$INPUT_REGISTRY" "$DOCKER_REGISTRY")
    INPUT_USERNAME=$(parseArg "$INPUT_USERNAME" "$DOCKER_USERNAME")
    INPUT_PASSWORD=$(parseArg "$INPUT_PASSWORD" "$DOCKER_PASSWORD")

    # login to registry if supplied
    if [ -n "${INPUT_REGISTRY}" ]; then
      echo "Logging into: ${INPUT_REGISTRY}"
      echo "${INPUT_PASSWORD}" | docker login -u "${INPUT_USERNAME}" --password-stdin "${INPUT_REGISTRY}"
    fi

    INPUT_IMAGE=$(parseArg "$INPUT_IMAGE" "$DOCKER_IMAGE")
    INPUT_OLD_TAG=$(parseArg "$INPUT_OLD_TAG" "$DOCKER_OLD_TAG")
    INPUT_NEW_TAG=$(parseArg "$INPUT_NEW_TAG" "$DOCKER_NEW_TAG")

    # pull -> tag -> push
    OLD_IMAGE="${INPUT_IMAGE}:${INPUT_OLD_TAG}"
    NEW_IMAGE="${INPUT_IMAGE}:${INPUT_NEW_TAG}"

    log docker pull "${OLD_IMAGE}"
    log docker tag "${OLD_IMAGE}" "${NEW_IMAGE}"
    log docker push "${NEW_IMAGE}"

    # logout
    if [ -n "${INPUT_REGISTRY}" ]; then
      echo "Logging out from Registry"
      docker logout
    fi
}

main