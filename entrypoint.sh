#!/bin/bash
cd "$HOME" || exit 1
source pg_venv/bin/activate

gunicorn  -D \
          --bind 0.0.0.0:8081 \
          --workers=1 \
          --threads=4 \
          --chdir pg_venv/lib/python3.9/site-packages/pgbackup \
          pgbackup:app

gunicorn  --bind 0.0.0.0:8080 \
          --workers=1 \
          --threads=25 \
          --chdir pg_venv/lib/python3.9/site-packages/pgadmin4 \
          pgAdmin4:app

#TODO: find a better solution to block,
# sothat both gunicorn instances can run in background
