from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routes import tickets, slots

app = FastAPI()

# Allow Flutter Web + Emulator access
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Register endpoints
app.include_router(tickets.router)
app.include_router(slots.router)

@app.get("/")
def home():
    return {"message": "Parking Lot System Backend Running"}
