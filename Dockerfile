FROM python:3.9-slim
LABEL maintainer="Jonny Rimkus <jonny@rimkus.it>"

ARG PGADMIN_VERSION

ENV PGADMIN_DOWNLOAD_URL="https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v$PGADMIN_VERSION/pip/pgadmin4-$PGADMIN_VERSION-py3-none-any.whl"
ENV PGADMIN_SETUP_EMAIL="info@rimkus.it"
ENV PGADMIN_SETUP_PASSWORD="changeme"
ENV SMTP_HOST=""
ENV SMTP_PORT=""
ENV PGBACKUP_PASSWORD="changeme"
ENV DEBIAN_FRONTEND="noninteractive"
ENV LANG="C.UTF-8"
ENV TERM="xterm"
SHELL ["/bin/bash", "-c"]

RUN apt-get -yq update \
 && apt-get -y install apt-utils \
 && apt-get -y install ssh gcc \
 postgresql-client python3-dev libkrb5-dev sqlite3 curl \
 # postgresql-server-dev-all
 # clean apt cache
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 # Remove MOTD
 && rm -rf /etc/update-motd.d /etc/motd /etc/motd.dynamic \
 && ln -fs /dev/null /run/motd.dynamic




RUN mkdir /usr/local/share/pgadmin /var/lib/pgadmin /var/log/pgadmin &&\
 addgroup --system pgadmin &&\
 adduser pgadmin\
 --home /usr/local/share/pgadmin\
 --shell /bin/bash\
 --ingroup pgadmin\
 --no-create-home\
 --system

RUN chown -R pgadmin:pgadmin /usr/local/share/pgadmin /var/lib/pgadmin /var/log/pgadmin &&\
 chmod u+rwx /usr/local/share/pgadmin /var/lib/pgadmin /var/log/pgadmin

WORKDIR /usr/local/share/pgadmin

USER pgadmin
RUN python3 -m venv pg_venv &&\
 source pg_venv/bin/activate &&\
 python3 -m pip install --upgrade pip &&\
 pip install wheel gunicorn flask &&\
 pip install "$PGADMIN_DOWNLOAD_URL" &&\
 mkdir -p pg_venv/lib/python3.9/site-packages/pgbackup 
COPY pgbackup.py pg_venv/lib/python3.9/site-packages/pgbackup/

USER root
COPY config_local.py pg_venv/lib/python3.9/site-packages/pgadmin4/
COPY entrypoint.sh entrypoint.sh
RUN chown pgadmin:pgadmin pg_venv/lib/python3.9/site-packages/pgadmin4/config_local.py entrypoint.sh &&\
 chmod +x entrypoint.sh

USER pgadmin
EXPOSE 8080
EXPOSE 8081
ENTRYPOINT ["/usr/local/share/pgadmin/entrypoint.sh"]
HEALTHCHECK CMD curl -f http://localhost:8080 && curl -f http://localhost:8081 || exit 1
