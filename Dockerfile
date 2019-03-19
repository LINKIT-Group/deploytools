FROM alpine as base

RUN apk update \
    && apk add --no-cache \
        bash \
        python3 \
        terraform \
        openssh \
        ca-certificates \
        groff \
        git \
        git-subtree \
        jq \
    && pip3 install --upgrade pip \
    && python3 -m pip install \
        awscli \
        boto3 \
        jinja2 \
        makegit \
        remotestate \
    && rm -rf /opt/build/* \
    && rm -rf /var/cache/apk/* \
    && rm -rf /root/.cache/*

FROM scratch as user
COPY --from=base . .

ARG HOST_UID=${HOST_UID:-4000}
ARG HOST_USER=${HOST_USER:-nodummy}

RUN [ "${HOST_USER}" == "root" ] || \
    (adduser -h /home/${HOST_USER} -D -u ${HOST_UID} ${HOST_USER} \
    && chown -R "${HOST_UID}:${HOST_UID}" /home/${HOST_USER})

USER ${HOST_USER}
WORKDIR /home/${HOST_USER}

COPY files/aliases.sh .aliases
COPY files/profile .profile
