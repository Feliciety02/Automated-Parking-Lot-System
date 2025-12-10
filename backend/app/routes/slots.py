from fastapi import APIRouter
from app.database import slots

router = APIRouter(prefix="/slots")

@router.get("")
def list_slots():
    return list(slots.values())
