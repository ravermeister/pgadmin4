# PGAdmin Dockerfile from the Python Wheel package
This is a custom Dockerfile build from the official Python wheel package.
it uses gunicorn to start the instance and listens on `0.0.0.0:8080`. To
start the Container execute:
```
docker pull ravermeister/pgadmin4
docker run -p 8080:8080 ravermeister/pgadmin4
```
Then go to URL http://localhost:8080
