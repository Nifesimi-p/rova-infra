from fastapi import FastAPI
from fastapi.responses import JSONResponse

app = FastAPI(title="Rova Microservice", version="1.0.0")


@app.get("/healthz")
async def liveness():
    return JSONResponse({"status": "alive"})


@app.get("/readyz")
async def readiness():
    return JSONResponse({"status": "ready"})


@app.get("/metrics")
async def metrics():
    return JSONResponse({"uptime": "ok"})


@app.get("/")
async def root():
    return JSONResponse({"service": "rova-microservice", "version": "1.0.0"})