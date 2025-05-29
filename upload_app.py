from flask import Flask, request, redirect, render_template_string
import os

app = Flask(__name__)
GAME_FOLDER = '/home/ps2user/games'
BIOS_FOLDER = '/home/ps2user/.config/PCSX2/bios'

HTML = '''
<h2>Upload PS2 Game ISO or BIOS</h2>
<form method="POST" enctype="multipart/form-data">
  <input type="file" name="file"><br><br>
  <select name="type">
    <option value="game">Game ISO</option>
    <option value="bios">BIOS File</option>
  </select><br><br>
  <input type="submit" value="Upload">
</form>
<hr>
<h3>Uploaded Games:</h3>
<ul>
{% for iso in games %}
  <li>{{ iso }}</li>
{% endfor %}
</ul>
'''

@app.route('/', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        f = request.files['file']
        ftype = request.form['type']
        if f:
            dest = GAME_FOLDER if ftype == 'game' else BIOS_FOLDER
            f.save(os.path.join(dest, f.filename))
            return redirect('/')
    games = os.listdir(GAME_FOLDER)
    return render_template_string(HTML, games=games)

app.run(host='0.0.0.0', port=5000)
