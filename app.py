from flask import Flask, render_template, send_from_directory, request, redirect, url_for, flash
import os
from werkzeug.utils import secure_filename

app = Flask(__name__)
app.secret_key = 'supersecretkey'
BASE_DIR = "./rapoarte"
ALLOWED_EXTENSIONS = {'txt'}

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/')
def index():
    apps = os.listdir(BASE_DIR)
    return render_template('index.html', apps=apps)

@app.route('/rapoarte/<app_name>')
def show_reports(app_name):
    app_dir = os.path.join(BASE_DIR, app_name)
    if not os.path.exists(app_dir):
        return "Rapoarte nu au fost gasite pentru aplicația specificată.", 404
    files = os.listdir(app_dir)
    return render_template('reports.html', app_name=app_name, files=files)

@app.route('/rapoarte/<app_name>/<report_name>')
def download_report(app_name, report_name):
    app_dir = os.path.join(BASE_DIR, app_name)
    return send_from_directory(app_dir, report_name)

@app.route('/delete/<app_name>/<report_name>', methods=['POST'])
def delete_report(app_name, report_name):
    app_dir = os.path.join(BASE_DIR, app_name)
    file_path = os.path.join(app_dir, report_name)
    try:
        os.remove(file_path)
        flash(f'Raportul {report_name} a fost șters cu succes.')
    except Exception as e:
        flash(f'Eroare la ștergerea raportului: {e}')
    return redirect(url_for('show_reports', app_name=app_name))

@app.route('/upload/<app_name>', methods=['POST'])
def upload_file(app_name):
    if 'file' not in request.files:
        flash('Niciun fișier selectat pentru încărcare.')
        return redirect(request.url)
    file = request.files['file']
    if file.filename == '':
        flash('Niciun fișier selectat pentru încărcare.')
        return redirect(request.url)
    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        app_dir = os.path.join(BASE_DIR, app_name)
        if not os.path.exists(app_dir):
            os.makedirs(app_dir)
        file.save(os.path.join(app_dir, filename))
        flash(f'Fișierul {filename} a fost încărcat cu succes.')
        return redirect(url_for('show_reports', app_name=app_name))
    else:
        flash('Tipul fișierului nu este permis.')
        return redirect(request.url)

if __name__ == '__main__':
    app.run(debug=True)

