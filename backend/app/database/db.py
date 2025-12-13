import sqlite3
from datetime import datetime
import os

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DB_PATH = os.path.join(BASE_DIR, "parking.db")


def get_db():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def init_db():
    db = get_db()

    db.execute("""
    CREATE TABLE IF NOT EXISTS slots (
        slot_id TEXT PRIMARY KEY,
        is_available INTEGER NOT NULL
    )
    """)

    db.execute("""
    CREATE TABLE IF NOT EXISTS tickets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        plate_number TEXT NOT NULL,
        slot_id TEXT NOT NULL,
        time_in TEXT NOT NULL,
        time_out TEXT,
        duration_hours INTEGER,
        total_amount REAL
    )
    """)

    # Create parking slots A1–A6, B1–B6, C1–C6 if missing
    floors = ["A", "B", "C"]
    for f in floors:
        for n in range(1, 7):
            slot = f"{f}{n}"
            db.execute(
                "INSERT OR IGNORE INTO slots (slot_id, is_available) VALUES (?, ?)",
                (slot, 1)
            )

    db.commit()
    db.close()


def assign_slot(db):
    slot = db.execute(
        "SELECT slot_id FROM slots WHERE is_available = 1 ORDER BY slot_id LIMIT 1"
    ).fetchone()

    if slot is None:
        return None

    db.execute(
        "UPDATE slots SET is_available = 0 WHERE slot_id = ?",
        (slot["slot_id"],)
    )
    db.commit()

    return {"slot_id": slot["slot_id"]}


def save_ticket(db, plate, slot_id, time_in):
    cursor = db.execute("""
        INSERT INTO tickets (plate_number, slot_id, time_in)
        VALUES (?, ?, ?)
    """, (plate, slot_id, time_in))

    db.commit()
    return cursor.lastrowid

def release_slot(db, slot_id):
    db.execute(
        "UPDATE slots SET is_available = 1 WHERE slot_id = ?",
        (slot_id,)
    )
    db.commit()

