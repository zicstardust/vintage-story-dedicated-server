# Vintage Story Dedicated Server 

[GitHub](https://github.com/zicstardust/vintage-story-dedicated-server)

## Container
### Tags

| Tag | Architecture | Description |
| :----: | :----: | :----: |
| [`latest`](https://github.com/zicstardust/vintage-story-dedicated-server/blob/main/dockerfile) | amd64 | Dedicated Server |

### Registries
| Registry | Full image name | Description |
| :----: | :----: | :----: |
| [`docker.io`](https://hub.docker.com/r/zicstardust/vintage-story-dedicated-server) | `docker.io/zicstardust/vintage-story-dedicated-server` | Docker Hub |
| [`ghcr.io`](https://github.com/zicstardust/vintage-story-dedicated-server/pkgs/container/vintage-story-dedicated-server) | `ghcr.io/zicstardust/vintage-story-dedicated-server` | GitHub |


## Usage
### Compose
``` yml
services:
  vsserver:
    container_name: vintage-story-server
    image: docker.io/zicstardust/vintage-story-dedicated-server:latest
    restart: unless-stopped
    environment:
      TZ: America/New_York
    ports:
      - 42420:42420/tcp #Default_Port
    volumes:
      - <path to data>:/data
```

### Environment variables

| variables | Function | Default |
| :----: | --- | --- |
| `TZ` | Set Timezone | |
| `PUID` | Set UID | 1000 |
| `PGID` | Set GID | 1000 |
| `VERSION` | Set server version | stable |


### Set VERSION
| Value | Function |
| :----: | --- |
| `stable` | Latest stable version |
| `unstable` | Latest unstable version |
| [`x.x.x`](https://api.vintagestory.at/stable.json) | Exemple any stable version |
| [`x.x.x-rc.x`](https://api.vintagestory.at/unstable.json) | Exemple any unstable version |