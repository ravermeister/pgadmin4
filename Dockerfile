FROM python:3.9-slim
LABEL maintainer="Jonny Rimkus <jonny@rimkus.it>"

ARG PGADMIN_VERSION

ENV PGADMIN_DOWNLOAD_URL="https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v$PGADMIN_VERSION/pip/pgadmin4-$PGADMIN_VERSION-py3-none-any.whl"
ENV PGADMIN_SETUP_EMAIL="info@rimkus.it"
ENV PGADMIN_SETUP_PASSWORD="changeme"
ENV SMTP_HOST=""
ENV SMTP_PORT=""
ENV DEBIAN_FRONTEND="noninteractive"
ENV LANG="C.UTF-8"
ENV TERM="xterm"
SHELL ["/bin/bash", "-c"]

RUN apt-get -yq update &&\
 apt-get -y install apt-utils &&\
 apt-get -y install ssh gcc\
 postgresql-client python3-dev libkrb5-dev\
 sqlite3
# postgresql-server-dev-all

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
RUN python3 -m venv .venv &&\
 source .venv/bin/activate &&\
 python3 -m pip install --upgrade pip &&\
 pip install wheel gunicorn flask &&\
 pip install "$PGADMIN_DOWNLOAD_URL" &&\
 mkdir -p .venv/lib/python3.9/site-packages/pgbackup 
COPY pgbackup.py .venv/lib/python3.9/site-packages/pgbackup/

USER root
COPY config_local.py .venv/lib/python3.9/site-packages/pgadmin4/
COPY entrypoint.sh entrypoint.sh
RUN chown pgadmin:pgadmin .venv/lib/python3.9/site-packages/pgadmin4/config_local.py entrypoint.sh &&\
 chmod +x entrypoint.sh

USER pgadmin
EXPOSE 8080
EXPOSE 7080
ENTRYPOINT ["/usr/local/share/pgadmin/entrypoint.sh"]
