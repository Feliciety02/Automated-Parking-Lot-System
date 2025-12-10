from datetime import datetime

# Generate parking slots A1–C6
slots = {}

for floor in ["A", "B", "C"]:
    for number in range(1, 7):
        slot_id = f"{floor}{number}"
        slots[slot_id] = {
            "id": slot_id,
            "isOccupied": False
        }

# Ticket storage
tickets = {}
