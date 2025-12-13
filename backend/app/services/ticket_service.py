from datetime import datetime
import math
from app.database.db import SessionLocal, TicketModel

# Create ticket
def create_ticket(plate_number: str, slot_id: str):
    db = SessionLocal()
    ticket = TicketModel(
        plateNumber=plate_number,
        slotId=slot_id,
        timeIn=datetime.now()
    )
    db.add(ticket)
    db.commit()
    db.refresh(ticket)
    db.close()
    return ticket

# Exit ticket (normal payment)
def exit_ticket(ticket_id: int):
    db = SessionLocal()
    ticket = db.query(TicketModel).filter(TicketModel.id == ticket_id).first()

    if not ticket:
        db.close()
        return None

    ticket.timeOut = datetime.now()
    duration = (ticket.timeOut - ticket.timeIn).total_seconds() / 3600
    hours = math.ceil(duration)

    base_hours = 3
    base_rate = 40
    extra_rate = 20

    if hours <= base_hours:
        ticket.totalAmount = base_rate
    else:
        ticket.totalAmount = base_rate + (hours - base_hours) * extra_rate

    ticket.durationHours = hours
    db.commit()
    db.refresh(ticket)
    db.close()

    return ticket

# Lost ticket
def lost_ticket(ticket_id: int):
    db = SessionLocal()
    ticket = db.query(TicketModel).filter(TicketModel.id == ticket_id).first()

    if not ticket:
        db.close()
        return None

    ticket.timeOut = datetime.now()
    ticket.totalAmount = 150
    ticket.lostTicket = True
    ticket.durationHours = None

    db.commit()
    db.refresh(ticket)
    db.close()

    return ticket
