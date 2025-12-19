import json
from flask import Flask, render_template, session
from access import login_required
from blueprints.auth.auth_main import bp_auth
from blueprints.query.query_main import bp_query
from blueprints.report.report_main import bp_report
from blueprints.patients.patients_main import bp_patients

app = Flask(__name__)
app.config["SECRET_KEY"] = "you will never guess"

with open("data/db_config.json") as file:
    app.config["db_config"] = json.load(file)
with open("data/access.json") as file:
    app.config["db_access"] = json.load(file)
with open("data/query_types.json", encoding="utf-8") as file:
    app.config["query_types"] = json.load(file)
with open("data/report_types.json", encoding="utf-8") as file:
    app.config["report_types"] = json.load(file)

app.register_blueprint(bp_query)
app.register_blueprint(bp_auth)
app.register_blueprint(bp_report)
app.register_blueprint(bp_patients)


@app.route("/", methods=["GET"])
@login_required
def main_menu():
    login = session.get("login")
    user_role = session.get("user_group")
    return render_template("main_menu.html", user=login, user_role=user_role)

@app.route("/exit", methods=["GET"])
def exit_page():
    session.clear()
    return render_template("exit.html")


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5005, debug=True)
