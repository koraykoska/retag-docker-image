# retag-docker-image

Retags a given Docker Image and pushs the new tag to the given registry.

## Usage

Retagging a Github sha tag to latest.

```yaml
- name: Retag to latest
  uses: koraykoska/retag-docker-image@0.2.3
  with:
    registry: some.registry.com
    name: my-awesome-docker-image/my-package
    old_tag: ${{ github.sha }}
    new_tag: latest
    username: github
    password: ${{ secrets.GITHUB_TOKEN }}
```

The new tag will be pushed to the registry.
