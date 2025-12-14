from flask import Flask, request, jsonify, render_template
import subprocess

app = Flask(__name__)

@app.route("/", methods=["GET"])
def home():
    return render_template("index.html")

@app.route("/run", methods=["POST"])
def run_robot():
    commands = request.json.get("commands", "")

    result = subprocess.run(
        ["robot.exe"],
        input=commands,
        text=True,
        capture_output=True
    )

    output_lines = result.stdout.splitlines()
    # parse robot moves (simple)
    moves = []
    for line in output_lines:
        if "Moved to:" in line or "Turned" in line:
            moves.append(line.strip())
    
    return jsonify({"moves": moves})

if __name__ == "__main__":
    app.run(debug=True)
