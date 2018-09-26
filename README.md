# Fedora libvirt environment for Smoke tests
Libvirt container to run installer smoke tests

## Requirements
* `just` (https://github.com/casey/just)

## Download images
`just dl-rhcos`

## Build & Run
`just run`

## Enter the container from a different terminal
`just exec`

## Status
  1. The cluster completes but takes *a long time* on my machine, so the smoke tests time out first.
  2. Wait a long time (30 minutes or so) and execute the smoke tests manually
