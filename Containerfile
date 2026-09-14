ARG IMAGE=scratch
FROM $IMAGE AS base

ARG SCRIPT_BASE
COPY ./scripts/$SCRIPT_BASE /tmp/base-installer.sh
RUN <<-BASE
    chmod +x /tmp/base-installer.sh
    /tmp/base-installer.sh
	rm -f /tmp/base-installer.sh
BASE

ARG SCRIPT_SETUP
COPY ./scripts/$SCRIPT_SETUP /tmp/setup-installer.sh
RUN <<-SETUP
    chmod +x /tmp/setup-installer.sh
    /tmp/setup-installer.sh
	rm -f /tmp/setup-installer.sh
SETUP

FROM base AS shell

ENV SHELL_INSTALL="/usr/share/shell"

ARG SCRIPT_SHELL
COPY ./scripts/$SCRIPT_SHELL /tmp/shell-installer.sh
RUN <<-OMB
    chmod +x /tmp/shell-installer.sh
    /tmp/shell-installer.sh
	rm -f /tmp/shell-installer.sh
OMB

FROM base AS devcontainer

ARG AUTHOR
ARG LICENSE
ARG SOURCE
ARG DISTNAME
ARG USERS
ARG SHELL_THEME="vscode"
ENV OSH_THEME=$SHELL_THEME

LABEL org.opencontainers.image.source=$SOURCE
LABEL org.opencontainers.image.licenses=$LICENSE
LABEL org.opencontainers.image.authors=$AUTHOR

COPY --from=shell /usr/share/shell /usr/share/shell
COPY --from=shell /etc/sudoers.d/preserve-om /etc/sudoers.d/preserve-om
COPY --from=shell /etc/profile.d/omb.sh /etc/profile.d/omb.sh
COPY --from=shell /root/.bashrc /root/.bashrc
COPY --from=shell /root/.bashrc /etc/skel/.bashrc

RUN <<-SETUPUSERS
    echo $USERS | jq -c '.[]' |  while read USER;
    do
        USERNAME=$(echo "$USER" | jq -r '.username')
        USER_ID=$(echo "$USER" | jq -r '.user_id')
        GROUP_ID=$(echo "$USER" | jq -r '.group_id')
        groupadd --gid $GROUP_ID --non-unique $USERNAME
        useradd --uid $USER_ID --gid $GROUP_ID --non-unique -m $USERNAME
        echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME
        chmod 0440 /etc/sudoers.d/$USERNAME
    done
SETUPUSERS

WORKDIR /tmp