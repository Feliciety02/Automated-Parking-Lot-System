from pydantic import BaseModel

class Slot(BaseModel):
    id: str
    isOccupied: bool
