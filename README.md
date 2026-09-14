# DevContainers

Different container images ready to use in **devcontainer** environments, compatible with VS Code and DevPod.

## 💡 Motivation

The goal of this repository is to have my own set of devcontainer images with the tools a developer generally needs, in a distro-agnostic way, and to progressively add whatever tools I find useful over time — instead of relying on third-party or overly opinionated base images.

## 📦 Available distributions

| Image         | Base                  | Excluded platforms     |
|---------------|-----------------------|--------------------------|
| `debian`      | `debian:trixie-slim`  | -                        |
| `ubuntu`      | `ubuntu:latest`       | `linux/386`              |
| `alpine`      | `alpine:latest`       | -                        |
| `rockylinux`  | `rockylinux:9`        | `linux/386`              |
| `almalinux`   | `almalinux:9`         | `linux/386`              |

Every image includes: `bash`, `sudo`, `git`, `curl`, `wget`, `ca-certificates`, `openssh-client`, `gnupg`, `tar`, `gzip`, `unzip`, `procps`, `lsof`, `tzdata`, `jq`/`yq`, and **Oh My Bash** preconfigured with the `vscode` theme.

### Preconfigured users

Each image ships with the following users (UID/GID `1000`), with passwordless `sudo`:

| User     | Purpose                        |
|----------|----------------------------------|
| `coder`  | General purpose                 |
| `vscode` | VS Code compatibility            |
| `dev`    | DevPod compatibility              |

## 📥 Registry / Where to pull the images

Images are built and published to the **GitHub Container Registry (GHCR)**, under the [Yohnah](https://github.com/orgs/Yohnah/packages?repo_name=devcontainers) namespace.

```sh
docker pull ghcr.io/yohnah/dev-debian:latest
docker pull ghcr.io/yohnah/dev-ubuntu:latest
docker pull ghcr.io/yohnah/dev-alpine:latest
docker pull ghcr.io/yohnah/dev-rockylinux:latest
docker pull ghcr.io/yohnah/dev-almalinux:latest
```

Naming convention: `ghcr.io/yohnah/dev-<image>:<version>`.

You can browse all published packages directly on GitHub:

- https://github.com/Yohnah/devcontainers/pkgs/container/dev-debian
- https://github.com/Yohnah/devcontainers/pkgs/container/dev-ubuntu
- https://github.com/Yohnah/devcontainers/pkgs/container/dev-alpine
- https://github.com/Yohnah/devcontainers/pkgs/container/dev-rockylinux
- https://github.com/Yohnah/devcontainers/pkgs/container/dev-almalinux

> Package links follow GitHub's standard `pkgs/container/<name>` URL pattern based on the image names produced by `just build`; if a package hasn't been published yet under that exact path, check the [Packages tab](https://github.com/orgs/Yohnah/packages?repo_name=devcontainers) of the organization instead.

## 🛠️ Requirements

- [Docker](https://www.docker.com/) with `buildx` support
- [just](https://github.com/casey/just)
- [yq](https://github.com/mikefarah/yq)

## 🚀 Usage

### Initialize the multi-platform builder

```sh
just init
```

This creates a `buildx` builder (`crossbuilder`) using the configuration from `buildkitd.toml`.

### Log in to the registry

```sh
just login <username>
```

### Build an image

```sh
just build <image> [version] [upload]
```

Example:

```sh
just build debian dev
just build ubuntu 1.0.0 true   # build and push to the registry
```

### Build all images

```sh
just build-all [version] [upload]
```

### Run an image

```sh
just run <image> [version]
```

### Inspect an image

```sh
just inspect <image> [version]
```

### Tag an existing image

```sh
just tag <image> <version> [as]
```

### Clean up the builder

```sh
just clean
```

## 📁 Project structure

```
.
├── Containerfile              # Multi-stage definition (base -> shell -> devcontainer)
├── justfile                   # Build/push/tag recipes
├── buildkitd.toml             # BuildKit builder configuration
├── project.yml                # Project metadata and container definitions
├── maintainers.yaml           # Project maintainers
└── scripts/
    ├── base-alpine-installer.sh
    ├── base-debian-installer.sh
    ├── base-redhat-installer.sh
    ├── setup-installer.sh
    ├── setup-debian-installer.sh
    └── shell-installer.sh
```

Each image is built from three scripts defined in `project.yml`:

1. **base**: installs the base system packages.
2. **setup**: additional distro-specific configuration steps (e.g. locale generation on Debian).
3. **shell**: installs and configures Oh My Bash.

## ⚙️ Configuration (`project.yml`)

The `project.yml` file centralizes:

- The **users** to create on each image.
- The available **containers**, their base image, and their associated scripts.
- Project metadata (author, license, source).

Adding a new distribution is as simple as adding a new entry under `config.containers` with its base image and corresponding scripts.

## 👥 Maintainers

| Nick       | Role           |
|------------|----------------|
| @Yohnah    | Project lead   |

## 📄 License

Distributed under the **MPL-2.0** license. See the `LICENSE` file for details.

## 🔗 Links

- Repository: https://github.com/yohnah/devcontainers
- Packages (GHCR): https://github.com/Yohnah?tab=packages