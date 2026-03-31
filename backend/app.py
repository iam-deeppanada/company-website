from flask import Flask, request, jsonify
from flask_cors import CORS
import psycopg2
import uuid

app = Flask(__name__)
CORS(app)

DB_HOST = "db"
DB_NAME = "companydb"
DB_USER = "admin"
DB_PASS = "password"


def get_db_connection():
    conn = psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASS
    )
    return conn


@app.route("/contact", methods=["POST"])
def contact():

    data = request.json

    name = data.get("name")
    email = data.get("email")
    phone = data.get("phone")
    subject = data.get("subject")
    message = data.get("message")

    contact_id = str(uuid.uuid4())

    conn = get_db_connection()
    cur = conn.cursor()

    cur.execute("""
        CREATE TABLE IF NOT EXISTS contacts(
            id TEXT PRIMARY KEY,
            name TEXT,
            email TEXT,
            phone TEXT,
            subject TEXT,
            message TEXT
        )
    """)

    cur.execute("""
        INSERT INTO contacts (id,name,email,phone,subject,message)
        VALUES (%s,%s,%s,%s,%s,%s)
    """, (contact_id,name,email,phone,subject,message))

    conn.commit()

    cur.close()
    conn.close()

    return jsonify({
        "status": "success",
        "id": contact_id
    })


@app.route("/")
def home():
    return "Company Backend Running"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
