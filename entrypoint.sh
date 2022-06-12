#!/bin/bash
cd "$HOME" || exit 1
source .venv/bin/activate
gunicorn  --bind 0.0.0.0:8080 \
          --workers=1 \
          --threads=25 \
          --chdir .venv/lib/python3.9/site-packages/pgadmin4 \
          pgAdmin4:app && \
gunicorn  --bind 0.0.0.0:8081 \
          --workers=1 \
          --threads=4 \
          --chdir .venv/lib/python3.9/site-packages/pgbackup \
          pgbackup:app
