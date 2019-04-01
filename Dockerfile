FROM alpine as base

ARG TERRAFORM_VERSION=0.11.13

#https://checkpoint-api.hashicorp.com/v1/check/terraform

RUN apk update \
    && apk add --no-cache \
        bash \
        python3 \
        #terraform \
        openssh \
        ca-certificates \
        groff \
        git \
        git-subtree \
        jq \
        unzip \
    && pip3 install --upgrade pip \
    && python3 -m pip install \
        awscli \
        boto3 \
        jinja2 \
        makegit \
        remotestate \
    && wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -O /tmp/terraform-download.zip \
    && unzip /tmp/terraform-download.zip -d /usr/bin \
    && rm -rf /opt/build/* \
    && rm -rf /var/cache/apk/* \
    && rm -rf /root/.cache/* \
    && rm -rf /tmp/*


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
