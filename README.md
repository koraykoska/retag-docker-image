# Re-Tag Docker Image

This action will connect to a specified registry, pull an image, re-tag it and 
push it back. This is a good action composite for things like update `:latest` 
tag or any major shorthands with an existing image.


## Basic Usage

```yaml
- name: Retag to latest
  uses: ybrin/retag-docker-image@0.1.0
  with:
    name: my-awesome-docker-image/my-package
    tag: ${{ github.sha }}
    new_tag: latest
```

## Using a Registry like GitHub's

```yaml
- name: Retag to latest
  uses: ybrin/retag-docker-image@0.1.0
  with:
    registry: docker.pkg.github.com
    username: ${{ github.repository_owner }}
    password: ${{ secrets.GITHUB_TOKEN }}
    name: my-awesome-docker-image/my-package
    tag: ${{ github.sha }}
    new_tag: latest
```

## Alternative "env" way

```yaml

env:
  DOCKER_REGISTRY: docker.pkg.github.com
  DOCKER_USERNAME: ${{ github.repository_owner }}
  DOCKER_PASSWORD: ${{ secrets.GITHUB_TOKEN }}
  DOCKER_IMAGE: my-awesome-docker-image/my-package
  DOCKER_TAG: ${{ github.sha }}

steps:
  - name: Retag to latest
    uses: ybrin/retag-docker-image@0.1.0
    with:
      new_tag: latest
```

# Parameters

| With Name         | Env Name             | Required                         |
|:------------------|:---------------------|:---------------------------------|
| `registry`        | `DOCKER_REGISTRY`    | `no`                             |
| `username`        | `DOCKER_USERNAME`    | `yes` when `registry` is used    |
| `password`        | `DOCKER_PASSWORD`    | `yes` when `registry` is used    |
| `name`            | `DOCKER_IMAGE`       | `yes`                            |
| `new_name`        | `DOCKER_NEW_IMAGE`   | `no` defaults to `name`          |
| `tag`             | `DOCKERTAG`          | `yes`                            |
| `new_tag`         | `DOCKER_NEW_TAG`     | `yes`                            |
