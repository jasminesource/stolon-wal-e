#!flask/bin/python
from flask import Flask
from subprocess import call

app = Flask(__name__)

@app.route('/start-base-backup')
def index():
    call(["gosu stolon envdir $WALE_ENV_DIR wal-e backup-push $STKEEPER_DATA_DIR/postgres"])
    return "OK"

if __name__ == '__main__':
    app.run(debug=False)
