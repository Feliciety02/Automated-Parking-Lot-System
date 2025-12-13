from fastapi import APIRouter
from app.database.db import get_db

router = APIRouter(prefix="/slots")

@router.get("")
def get_slots():
    db = get_db()
    slots = db.execute("SELECT slot_id, is_available FROM slots").fetchall()

    return [
        {
            "slot_id": row["slot_id"],
            "is_available": row["is_available"]
        }
        for row in slots
    ]
