from datetime import datetime
import math
from app.database import tickets
from app.services.slot_service import occupy_slot, free_slot, find_nearest_available_slot

def create_ticket(plate_number: str):
    ticket_id = len(tickets) + 1

    slot_id = find_nearest_available_slot()
    if slot_id is None:
        return None  # No available slots

    occupy_slot(slot_id)

    time_in = datetime.now().isoformat()

    ticket = {
        "id": ticket_id,
        "plateNumber": plate_number,
        "slotId": slot_id,
        "timeIn": time_in,
        "timeOut": None,
        "durationHours": None,
        "totalAmount": None
    }

    tickets[ticket_id] = ticket
    return ticket


def exit_ticket(ticket_id: int):
    ticket = tickets.get(ticket_id)
    if not ticket:
        return None

    if ticket["timeOut"] is not None:
        return ticket  # already processed

    time_out = datetime.now()
    ticket["timeOut"] = time_out.isoformat()

    time_in_obj = datetime.fromisoformat(ticket["timeIn"])
    duration = (time_out - time_in_obj).total_seconds() / 3600
    hours = math.ceil(duration)

    ticket["durationHours"] = hours
    ticket["totalAmount"] = hours * 20

    free_slot(ticket["slotId"])
    return ticket

def lost_ticket(ticket_id: int):
    if ticket_id not in tickets:
        return None

    ticket = tickets[ticket_id]

    # Lost ticket fee (standard mall rate)
    lost_fee = 150

    ticket["timeOut"] = datetime.now().isoformat()
    ticket["durationHours"] = None  # duration not applicable for lost ticket
    ticket["totalAmount"] = lost_fee
    ticket["lostTicket"] = True

    return ticket
