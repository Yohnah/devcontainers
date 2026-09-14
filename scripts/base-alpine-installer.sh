#!/bin/sh
set -e
apk update
apk upgrade
apk add --no-cache bash sudo git curl wget ca-certificates openssh-client gnupg tar gzip unzip procps lsof tzdata shadow jq yq