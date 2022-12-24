# PGAdmin4 Dockerfile from the Python Wheel package
PGAdmin4 is availble in Dockerhub:
 - [ravermeister/pgadmin4](https://hub.docker.com/r/ravermeister/pgadmin4)

This is a custom Dockerfile build from the official Postgresql [Python wheel](https://www.pgadmin.org/download/pgadmin-4-python/) package.
It uses [gunicorn](https://gunicorn.org/) to start the Instance and listens on `0.0.0.0:8080`. To start the Container
(the environment variables are optional) execute:
```bash
docker pull ravermeister/pgadmin4
docker run -p 8080:8080 -p 8081:8081 \
-e SMTP_HOST="localhost" \
-e SMTP_PORT=25 \
-e SMTP_MAIL_SENDER="no-reply@localhost" \
-e PGBACKUP_PASSWORD="backup_restore_password" \
ravermeister/pgadmin4
```
Then go to URL http://localhost:8080, the default admin user is:

|   |   |
|---|---|
| __User__  | info@rimkus.it  |
| __Password__  | changeme  |

__Please change the Password for the admin User, as soon as the Container is running !! 
or even better create a new admin User and delete the the existing default one__

## Backup and restore
There is a second Service listening on `0.0.0.0:8081` to backup/restore the pgadmin4 settings db (sqlite database). The inital password for backup and restore
is _changeme_. You can overwrite this with the `PGBACKUP_PASSWORD` env var.

following endpoints are available:
|  Endpoint  | Method  |  Description  |
|------------|---------|---------------|
| http://localhost:8081 | GET | Display usage |
| http://localhost:8081/backup/sql | GET | create a backup via `sqlite3 pgadmin4.db .dump` e.g. dump the database as sql file. |
| http://localhost:8081/backup/file | GET | send the plain db file as download file. |
| http://localhost:8081/restore/sql | POST | restore via `sqlite3 pgadmin4.db < restore_file` e.g. restore the database via sql file. Curl Example: `curl --location --request POST 'localhost:8000/restore/sql?password=backup_restore_password' --form 'settings_sql=@"/path/to/dump.sql"'` |
| http://localhost:8081/restore/file | POST | restore via overwriting the db file with the uploaded one. Curl Example: `curl --location --request POST 'localhost:8000/restore/file?password=backup_restore_password' --form 'settings_db=@"/path/to/pgadmin4_settings.db"'` |
