import os
import sqlite3
import pickle
from flask import Flask, request, render_template_string

app = Flask(__name__)
DB_FILE = "vuln.db"

# ❌ Insecure DB setup
conn = sqlite3.connect(DB_FILE)
cursor = conn.cursor()
cursor.execute("CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, username TEXT, password TEXT)")
cursor.execute("INSERT INTO users (username, password) VALUES ('admin', 'admin123')")  # Hardcoded password
conn.commit()
conn.close()

@app.route("/")
def index():
    return "Welcome to the vulnerable app!"

# ❌ Command Injection
@app.route("/ping")
def ping():
    ip = request.args.get("ip", "")
    output = os.popen(f"ping -c 2 {ip}").read()
    return f"<pre>{output}</pre>"

# ❌ SQL Injection
@app.route("/login", methods=["POST"])
def login():
    username = request.form.get("username", "")
    password = request.form.get("password", "")
    conn = sqlite3.connect(DB_FILE)
    cursor = conn.cursor()
    query = f"SELECT * FROM users WHERE username = '{username}' AND password = '{password}'"
    result = cursor.execute(query).fetchone()
    conn.close()
    if result:
        return "Login successful!"
    return "Invalid credentials."

# ❌ Environment Info Leak
@app.route("/debug")
def debug():
    return f"<pre>{os.environ}</pre>"

# ❌ Reflected XSS
@app.route("/search")
def search():
    q = request.args.get("q", "")
    return render_template_string(f"<h1>Search result for: {q}</h1>")

# ❌ Insecure Deserialization
@app.route("/load", methods=["POST"])
def load():
    data = request.files["file"].read()
    obj = pickle.loads(data)
    return f"Loaded object: {obj}"

# ❌ Insecure File Upload
@app.route("/upload", methods=["POST"])
def upload():
    file = request.files["file"]
    file.save(os.path.join("/tmp/uploads", file.filename))  # No validation, open path
    return "File uploaded!"

# ❌ Eval on user input
@app.route("/calc")
def calc():
    expr = request.args.get("expr", "")
    try:
        result = eval(expr)  # Remote code execution possible!
        return f"Result: {result}"
    except Exception as e:
        return f"Error: {e}"

if __name__ == "__main__":
    app.run(debug=True)
