ARG PYTHON_VERSION=3.11
ARG PLATFORM=linux/amd64
ARG PGADMIN_VERSION=8.0

FROM --platform=$PLATFORM \
  python:$PYTHON_VERSION-slim \
  AS base_image

ENV DEBIAN_FRONTEND="noninteractive"
ENV LANG="C.UTF-8"
ENV TERM="xterm"
SHELL ["/bin/bash", "-c"]

RUN apt-get -yq update \
 && apt-get -yq install apt-utils \
 && apt-get -yq install --no-install-recommends \
  ssh gcc postgresql-client python3-dev libkrb5-dev \
 sqlite3 curl \
 # postgresql-server-dev-all
 # clean apt cache
 && apt-get -yq clean \
 && rm -rf /var/lib/apt/lists/* \
 # Remove MOTD
 && rm -rf /etc/update-motd.d /etc/motd /etc/motd.dynamic \
 && ln -fs /dev/null /run/motd.dynamic \
 # Remove generated SSH Keys
 && rm /etc/ssh/ssh_host_ecdsa_key /etc/ssh/ssh_host_ecdsa_key.pub \
    /etc/ssh/ssh_host_ed25519_key /etc/ssh/ssh_host_ed25519_key.pub \
    /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key.pub >/dev/null 2>&1 \
 # create pgadmin user
 && mkdir /usr/local/share/pgadmin \
  /var/lib/pgadmin /var/log/pgadmin \
 && addgroup --system pgadmin \
 && adduser pgadmin \
 --home /usr/local/share/pgadmin \
 --shell /bin/bash \
 --ingroup pgadmin \
 --no-create-home \
 --system \
 # set permissions for pgadmin user folders
  && chown -R pgadmin:pgadmin \
   /usr/local/share/pgadmin \
   /var/lib/pgadmin \
   /var/log/pgadmin \
  && chmod u+rwx /usr/local/share/pgadmin \
   /var/lib/pgadmin /var/log/pgadmin

WORKDIR /usr/local/share/pgadmin
USER pgadmin
ARG PGADMIN_VERSION
ARG PGADMIN_DOWNLOAD_URL="https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v$PGADMIN_VERSION/pip/pgadmin4-$PGADMIN_VERSION-py3-none-any.whl"
RUN python3 -m venv pg_venv \
 && source pg_venv/bin/activate \
 && python3 -m pip install --upgrade pip \
 && pip install wheel gunicorn flask psutil \
  "$PGADMIN_DOWNLOAD_URL" \
 && pip cache purge

USER root
COPY config_local.py pg_venv/lib/python$PYTHON_VERSION/site-packages/pgadmin4/
COPY entrypoint.sh entrypoint.sh
RUN chown pgadmin:pgadmin pg_venv/lib/python$PYTHON_VERSION/site-packages/pgadmin4/config_local.py entrypoint.sh &&\
 chmod +x entrypoint.sh \
 && rm -rf /tmp/*

FROM scratch
COPY --from=base_image / /
LABEL maintainer="Jonny Rimkus <jonny@rimkus.it>"
ARG PYTHON_VERSION
ENV PYTHON_VERSION="$PYTHON_VERSION"
ENV PGADMIN_SETUP_EMAIL="info@rimkus.it"
ENV PGADMIN_SETUP_PASSWORD="changeme"
ENV SMTP_HOST=""
ENV SMTP_PORT=""
USER pgadmin
EXPOSE 8080
ENTRYPOINT ["/usr/local/share/pgadmin/entrypoint.sh"]
HEALTHCHECK CMD curl -f http://localhost:8080 || exit 1

