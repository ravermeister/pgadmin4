import os

LOG_FILE = '/var/log/pgadmin/pgadmin4.log'
SQLITE_PATH = '/var/lib/pgadmin/pgadmin4.db'
SESSION_DB_PATH = '/var/lib/pgadmin/sessions'
STORAGE_DIR = '/var/lib/pgadmin/storage'
SERVER_MODE = True
DEFAULT_SERVER_PORT = 8080
DEFAULT_SERVER = '0.0.0.0'

MAIL_SERVER = os.getenv('SMTP_HOST', "127.0.0.1")
MAIL_PORT = os.getenv('SMTP_PORT', 25)
MAIL_USE_SSL = os.getenv('SMTP_SSL', False)
MAIL_USE_TLS = os.getenv('SMTP_TLS', False)
MAIL_USERNAME = os.getenv('SMTP_USER', '')
MAIL_PASSWORD = os.getenv('SMTP_PASSWORD', '')
MAIL_DEBUG = os.getenv('SMTP_DEBUG', False)

SECURITY_EMAIL_SENDER = os.getenv('SMTP_MAIL_SENDER', 'no-reply@localhost')

ALLOW_SAVE_TUNNEL_PASSWORD = True
ENABLE_BINARY_PATH_BROWSING = True

DEFAULT_BINARY_PATHS = {
    "pg": "",
    "pg-9.6": "",
    "pg-10": "",
    "pg-11": "",
    "pg-12": "",
    "pg-13": "/usr/lib/postgresql/13/bin/",
    "pg-14": "",
    "pg-15": "",
    "pg-16": "",
    "pg-17": "/usr/lib/postgresql/17/bin/",
    "ppas": "",
    "ppas-9.6": "",
    "ppas-10": "",
    "ppas-11": "",
    "ppas-12": "",
    "ppas-13": "",
    "ppas-14": "",
    "ppas-15": ""
}
