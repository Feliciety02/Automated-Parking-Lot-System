from pydantic import BaseModel
from typing import Optional

class Ticket(BaseModel):
    id: int
    plateNumber: str
    slotId: str
    timeIn: str
    timeOut: Optional[str]
    durationHours: Optional[int]
    totalAmount: Optional[float]
