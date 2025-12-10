from fastapi import APIRouter
from pydantic import BaseModel
from app.services.ticket_service import create_ticket, exit_ticket, lost_ticket
from app.database import tickets

router = APIRouter(prefix="/tickets")

# FIX: Use camelCase to match your Flutter model
class TicketCreate(BaseModel):
    plateNumber: str

@router.post("")
def create_ticket_endpoint(data: TicketCreate):
    ticket = create_ticket(data.plateNumber)
    return ticket


@router.get("")
def list_tickets(active: bool = False):
    if active:
        return [t for t in tickets.values() if t["timeOut"] is None]
    return list(tickets.values())


@router.get("/{ticket_id}")
def get_ticket(ticket_id: int):
    return tickets.get(ticket_id, {"error": "Ticket not found"})


@router.put("/{ticket_id}/exit")
def exit_ticket_endpoint(ticket_id: int):
    ticket = exit_ticket(ticket_id)
    if not ticket:
        return {"error": "Ticket not found"}
    return ticket

@router.put("/{ticket_id}/lost")
def lost_ticket_endpoint(ticket_id: int):
    ticket = lost_ticket(ticket_id)
    if not ticket:
        return {"error": "Ticket not found"}
    return ticket