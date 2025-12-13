from fastapi import APIRouter
from pydantic import BaseModel
from datetime import datetime
import math

from app.database.db import (
    get_db,
    assign_slot,
    save_ticket,
    release_slot
)

router = APIRouter(prefix="/tickets")

# --------------------------
# REQUEST MODEL
# --------------------------
class TicketCreate(BaseModel):
    plateNumber: str


# --------------------------
# CREATE TICKET
# --------------------------
@router.post("")
def create_ticket(data: TicketCreate):
    plate = data.plateNumber.strip()
    db = get_db()

    slot = assign_slot(db)
    if slot is None:
        return {"error": "No available slots"}

    time_in = datetime.now().isoformat()
    ticket_id = save_ticket(db, plate, slot["slot_id"], time_in)

    return {
        "id": ticket_id,
        "plateNumber": plate,
        "slotId": slot["slot_id"],
        "timeIn": time_in,
        "timeOut": None,
        "durationHours": None,
        "totalAmount": None
    }


# --------------------------
# GET ACTIVE / ALL TICKETS
# --------------------------
@router.get("")
def get_tickets(active: bool = False):
    db = get_db()

    if active:
        rows = db.execute("""
            SELECT * FROM tickets
            WHERE time_out IS NULL
            ORDER BY time_in ASC
        """).fetchall()
    else:
        rows = db.execute("SELECT * FROM tickets").fetchall()

    tickets = []
    for t in rows:
        tickets.append({
            "id": t["id"],
            "plateNumber": t["plate_number"],
            "slotId": t["slot_id"],
            "timeIn": t["time_in"],
            "timeOut": t["time_out"],
            "durationHours": t["duration_hours"],
            "totalAmount": t["total_amount"]
        })

    return tickets


# --------------------------
# EXIT PREVIEW (NO DB WRITE)
# --------------------------
@router.get("/{ticket_id}/exit-preview")
def exit_preview(ticket_id: int):
    db = get_db()

    ticket = db.execute("SELECT * FROM tickets WHERE id = ?", (ticket_id,)).fetchone()
    if ticket is None:
        return {"error": "Ticket not found"}

    time_in = datetime.fromisoformat(ticket["time_in"])
    time_out = datetime.now()

    hours = (time_out - time_in).total_seconds() / 3600
    hours_rounded = math.ceil(hours)

    # Price calculation
    if hours_rounded <= 3:
        total_amount = 40
    else:
        total_amount = 40 + (hours_rounded - 3) * 20

    return {
        "id": ticket["id"],
        "plateNumber": ticket["plate_number"],
        "slotId": ticket["slot_id"],
        "timeIn": ticket["time_in"],
        "timeOut": time_out.isoformat(),   # preview ONLY
        "durationHours": hours_rounded,
        "totalAmount": total_amount
    }


# --------------------------
# LOST TICKET (Immediate Exit)
# --------------------------
@router.put("/{ticket_id}/lost")
def lost_ticket(ticket_id: int):
    db = get_db()

    ticket = db.execute("SELECT * FROM tickets WHERE id = ?", (ticket_id,)).fetchone()
    if ticket is None:
        return {"error": "Ticket not found"}

    LOST_FEE = 150
    time_out = datetime.now().isoformat()

    db.execute("""
        UPDATE tickets
        SET time_out = ?, duration_hours = 0, total_amount = ?
        WHERE id = ?
    """, (time_out, LOST_FEE, ticket_id))

    release_slot(db, ticket["slot_id"])
    db.commit()

    return {
        "id": ticket["id"],
        "plateNumber": ticket["plate_number"],
        "slotId": ticket["slot_id"],
        "timeIn": ticket["time_in"],
        "timeOut": time_out,
        "durationHours": 0,
        "totalAmount": LOST_FEE,
        "lostTicket": True
    }


# --------------------------
# CONFIRM PAYMENT (FINAL EXIT)
# --------------------------
@router.put("/{ticket_id}/confirm")
def confirm_payment(ticket_id: int):
    db = get_db()

    ticket = db.execute("SELECT * FROM tickets WHERE id = ?", (ticket_id,)).fetchone()
    if ticket is None:
        return {"error": "Ticket not found"}

    time_in = datetime.fromisoformat(ticket["time_in"])
    time_out = datetime.now()

    hours = (time_out - time_in).total_seconds() / 3600
    hours_rounded = math.ceil(hours)

    if hours_rounded <= 3:
        total_amount = 40
    else:
        total_amount = 40 + (hours_rounded - 3) * 20

    # Final save
    db.execute("""
        UPDATE tickets
        SET time_out = ?, duration_hours = ?, total_amount = ?
        WHERE id = ?
    """, (time_out.isoformat(), hours_rounded, total_amount, ticket_id))

    release_slot(db, ticket["slot_id"])
    db.commit()

    return {"success": True}

@router.get("/history")
def get_history():
    db = get_db()
    rows = db.execute("""
        SELECT * FROM tickets
        WHERE time_out IS NOT NULL
        ORDER BY time_out DESC
    """).fetchall()

    return [{
        "id": t["id"],
        "plateNumber": t["plate_number"],
        "slotId": t["slot_id"],
        "timeIn": t["time_in"],
        "timeOut": t["time_out"],
        "durationHours": t["duration_hours"],
        "totalAmount": t["total_amount"]
    } for t in rows]
