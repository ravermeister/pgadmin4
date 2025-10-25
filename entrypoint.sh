#!/bin/bash
cd "$HOME" || exit 1
source pg_venv/bin/activate

gunicorn  --bind 0.0.0.0:8080 \
          --workers=1 \
          --threads=25 \
          --chdir pg_venv/lib/python$PYTHON_VERSION/site-packages/pgadmin4 \
          pgAdmin4:app
