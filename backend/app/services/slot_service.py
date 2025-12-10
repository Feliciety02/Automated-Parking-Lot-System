from app.database import slots

def find_nearest_available_slot():
    for floor in ["A", "B", "C"]:
        for number in range(1, 7):
            slot_id = f"{floor}{number}"
            if not slots[slot_id]["isOccupied"]:
                return slot_id
    return None

def occupy_slot(slot_id: str):
    slots[slot_id]["isOccupied"] = True

def free_slot(slot_id: str):
    slots[slot_id]["isOccupied"] = False
