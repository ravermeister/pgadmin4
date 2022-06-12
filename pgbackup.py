import os
import subprocess

from flask import Flask, request, send_file
from io import BytesIO


app = Flask(__name__)

settings_db = '/var/lib/pgadmin/pgadmin4.db'


@app.route('/')
def usage():  # put application's code here
    return "<h2>Usage</h2>" \
           "<ul><li>/backup/file?passwd=access_password -- retrieve pgadmin4 settings db file</li>" \
           "<li>/backup/sql?passwd=access_password -- dump pgadmin4 settings db</li>" \
           "<li>/restore/file?password=access_password -- restore pgadmin4 settings via db file</li>" \
           "<li>/restore/sql?password=access_password -- restore pgadmin4 settings via sql dump</li></ul>"


@app.route('/backup/file', methods=['GET'])
def backup_file():
    if validate_password(request.args):
        return send_file(
            path_or_file=settings_db,
            as_attachment=True
        )
    else:
        return 'wrong password'


@app.route('/backup/sql', methods=['GET'])
def backup_sql():
    if validate_password(request.args):
        sql_dump = subprocess.check_output(['sqlite3', settings_db, '.dump'])
        file_buf = BytesIO()
        file_buf.write(sql_dump)
        file_buf.seek(0)
        return send_file(
            file_buf,
            as_attachment=True,
            attachment_filename='pgadmin4_settings.sql',
            mimetype='text/plain'
        )
    else:
        return 'wrong password'


@app.route('/restore/file', methods=['POST'])
def restore_file():
    if validate_password(request.args):
        if 'settings_db' in request.files:
            db_file = request.files['settings_db']
            db_file.save(settings_db)
            return 'restore via db successful'
        else:
            return "no settings db provided"
    else:
        return 'wrong password'


@app.route('/restore/sql', methods=['POST'])
def restore_sql():
    if validate_password(request.args):
        if 'settings_sql' in request.files:
            db_sql = request.files['settings_sql']
            sql_data = db_sql.read()
            os.remove(settings_db)
            sqlite3_cmd = subprocess.Popen(['sqlite3', settings_db], stdin=subprocess.PIPE, stdout=subprocess.PIPE)
            sqlite3_cmd.communicate(input=sql_data)
            return "restore via sql successful"
        else:
            return 'no settings sql provided'
    else:
        return 'wrong password'


def validate_password(params):
    if 'PGBACKUP_PASSWORD' not in os.environ:
        return False
    if 'password' not in params:
        return False

    return params['password'] == os.environ['PGBACKUP_PASSWORD']


if __name__ == '__main__':
    app.run()
