ARG BASE_IMAGE=debian:trixie-slim

FROM ${BASE_IMAGE} AS base


RUN <<BASE
    apt-get update
    apt-get -y install extrepo
    extrepo enable griffo
    apt-get update
    apt-get -y install just
BASE

FROM base AS devcontainer