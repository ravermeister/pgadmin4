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
