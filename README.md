# Fedora libvirt environment for Smoke tests
Libvirt container to run installer smoke tests

## Requirements
* `just` (https://github.com/casey/just)

## Download images
`just dl-rhcos`

## Build & Run
* `just run [branch]`        - Creates a background running container after the image is built.
* `just run-attach [branch]` - Creates a background running container.

`branch` is an optional parameter which specifies the git branch to clone for the installer.

## Stop
`just stop`

## Enter the container from a different terminal
`just exec`

## Status
  1. The cluster completes but takes *a long time* on my machine, so the smoke tests time out first.
  2. Wait a long time (30 minutes or so) and execute the smoke tests manually
