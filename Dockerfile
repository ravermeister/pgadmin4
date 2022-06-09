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

RUN mkdir /usr/local/share/pgadmin
RUN mkdir /var/lib/pgadmin
RUN mkdir /var/log/pgadmin

RUN addgroup --system pgadmin
RUN adduser pgadmin\
 --home /usr/local/share/pgadmin\
 --shell /bin/bash\
 --ingroup pgadmin\
 --no-create-home\
 --system
RUN chown -R pgadmin:pgadmin /usr/local/share/pgadmin
RUN chown -R pgadmin:pgadmin /var/lib/pgadmin
RUN chown -R pgadmin:pgadmin /var/log/pgadmin

WORKDIR /usr/local/share/pgadmin

USER pgadmin
RUN python3 -m venv pgadmin4
RUN source pgadmin4/bin/activate &&\
 python3 -m pip install --upgrade pip &&\
 pip install wheel &&\
 pip install gunicorn &&\
 pip install "$PGADMIN_DOWNLOAD_URL"

USER root
COPY config_local.py pgadmin4/lib/python3.9/site-packages/pgadmin4/
COPY entrypoint.sh entrypoint.sh
RUN chown pgadmin:pgadmin pgadmin4/lib/python3.9/site-packages/pgadmin4/config_local.py
RUN chown pgadmin:pgadmin entrypoint.sh
RUN chmod +x entrypoint.sh

USER pgadmin
EXPOSE 8080
ENTRYPOINT ["/usr/local/share/pgadmin/entrypoint.sh"]
