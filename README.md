# PGAdmin4 Dockerfile from the Python Wheel package
PGAdmin4 is availble in Dockerhub:
 - [ravermeister/pgadmin4](https://hub.docker.com/r/ravermeister/pgadmin4)

This is a custom Dockerfile build from the official Postgresql [Python wheel](https://www.pgadmin.org/download/pgadmin-4-python/) package.
It uses [gunicorn](https://gunicorn.org/) to start the Instance and listens on `0.0.0.0:8080`. To start the Container
(the environment variables are optional) execute:
```bash
docker pull ravermeister/pgadmin4
docker run -p 8080:8080 \
-e SMTP_HOST="localhost" \
-e SMTP_PORT=25 \
-e SMTP_MAIL_SENDER="no-reply@localhost" \
ravermeister/pgadmin4
```
Then go to URL http://localhost:8080, the default admin user is:

|   |   |
|---|---|
| __User__  | info@rimkus.it  |
| __Password__  | changeme  |

__Please change the Password for the admin User, as soon as the Container is running !! 
or even better create a new admin User and delete the the existing default one__

