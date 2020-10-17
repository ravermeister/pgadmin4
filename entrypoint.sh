#!/bin/bash
cd "$HOME" || exit 1
source pgadmin4/bin/activate
gunicorn  --bind 0.0.0.0:8080 \
          --workers=1 \
          --threads=25 \
          --chdir pgadmin4/lib/python3.9/site-packages/pgadmin4 \
          pgAdmin4:app
