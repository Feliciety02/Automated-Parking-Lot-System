from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routes import tickets, slots
from app.database.db import init_db

app = FastAPI()

# Allow Flutter Web + Emulator access
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize database on startup
@app.on_event("startup")
def startup_event():
    init_db()
    print("Database initialized")

# Register endpoints
app.include_router(tickets.router)
app.include_router(slots.router)

@app.get("/")
def home():
    return {"message": "Parking Lot System Backend Running"}
