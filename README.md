# Devcontainer with the Android SDK
Pre-installed Android SDK for [Devcontainer](https://code.visualstudio.com/docs/remote/containers).
Images are available at [GHCR](https://github.com/ManchesterMachineMakers/android-devcontainer/pkgs/container/android-devcontainer).
This is used in our [robot controller code](https://github.com/ManchesterMachineMakers/RobotController).

## Quickstart
Make a devcontainer setting file at `.devcontainer/devcontainer.json` in your project.
```json
{
    "image": "ghcr.io/manchestermachinemakers/android-devcontainer:main",
    "runArgs": [ "--init" ],
    "extensions": [
        "vscjava.vscode-java-pack",
        "fwcd.kotlin"
    ],
}
```
Then, reopen in container.

## `buildx` Compilation
Compilation uses [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/).

### Requirements
Some system libraries are needed.
```bash
$ sudo apt-get update
$ sudo apt-get install -y binfmt-support qemu qemu-user-static
```

You need `buildx` to cross-compile images.
