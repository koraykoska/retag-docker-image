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

require() {
  if [ -z "${2}" ]; then
    echo "${1} field is REQUIRED!"
    exit 1
  fi
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
      require "username" "$INPUT_USERNAME"
      require "password" "$INPUT_PASSWORD"

      echo "${INPUT_PASSWORD}" | docker login -u "${INPUT_USERNAME}" --password-stdin "${INPUT_REGISTRY}"
      echo " "
    fi

    INPUT_NAME=$(parseArg "$INPUT_NAME" "$DOCKER_IMAGE")
    require "name" "$INPUT_NAME"

    INPUT_TAG=$(parseArg "$INPUT_TAG" "$DOCKER_TAG")
    require "tag" "$INPUT_NAME"

    INPUT_NEW_NAME=$(parseArg "$INPUT_NEW_NAME" "$DOCKER_NEW_IMAGE")
    INPUT_NEW_NAME=$(parseArg "$INPUT_NEW_NAME" "$INPUT_NAME") # default to the old name
    require "new_name" "$INPUT_NAME"

    INPUT_NEW_TAG=$(parseArg "$INPUT_NEW_TAG" "$DOCKER_NEW_TAG")
    require "new_tag" "$INPUT_NAME"

    # pull -> tag -> push
    OLD_IMAGE="${INPUT_NAME}:${INPUT_TAG}"
    NEW_IMAGE="${INPUT_NEW_NAME}:${INPUT_NEW_TAG}"

    log docker pull "${OLD_IMAGE}"
    log docker tag "${OLD_IMAGE}" "${NEW_IMAGE}"
    log docker push "${NEW_IMAGE}"

    # logout
    if [ -n "${INPUT_REGISTRY}" ]; then
      echo " "
      echo "Logging out from Registry"
      docker logout "${INPUT_REGISTRY}"
    fi
}

main
