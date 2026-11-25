"""Notification microservice - entry point.

Run:  uvicorn app.main:app --reload --port 8084
  or: python -m app.main
"""
import os
from contextlib import asynccontextmanager

from fastapi import FastAPI

from app.routers import notification

import py_eureka_client.eureka_client as eureka_client

PORT = int(os.getenv("PORT", "8084"))


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup: register with Eureka
    try:
        await eureka_client.init_async(
            eureka_server="http://localhost:8761/eureka",
            app_name="NOTIFICATION",
            instance_port=PORT,
            instance_host="localhost",
            health_check_url=f"http://localhost:{PORT}/health",
            status_page_url=f"http://localhost:{PORT}/info",
            home_page_url=f"http://localhost:{PORT}/",
        )
        print(f"Registered with Eureka as NOTIFICATION on port {PORT}")
    except Exception as e:
        print(f"Eureka registration skipped or failed: {e}")
    yield
    # Shutdown: deregister from Eureka
    try:
        await eureka_client.stop_async()
        print("Deregistered from Eureka")
    except Exception:
        pass


app = FastAPI(
    title="Notification Microservice API",
    version="1.0.0",
    description=(
        "Notification microservice (Python / FastAPI, no database). "
        "Only the hello endpoint is implemented; the notification logic is to be developed by students."
    ),
    contact={"name": "Badia Abouhdid"},
    servers=[{"url": f"http://localhost:{PORT}", "description": "Local"}],
    # Same URLs as the other microservices of the project
    docs_url="/swagger-ui",       # Swagger UI
    openapi_url="/v3/api-docs",   # OpenAPI JSON
    redoc_url="/redoc",           # alternative documentation
    lifespan=lifespan,
)

app.include_router(notification.router)
app.include_router(notification.router, prefix="/api")


@app.get("/health", summary="Health check endpoint")
def health():
    return {"status": "UP"}


@app.get("/info", summary="Service info endpoint")
def info():
    return {
        "name": "notification",
        "version": "1.0.0",
        "description": "Notification microservice (Python / FastAPI)",
    }

# TODO (students): if you add other routers, include them here.


if __name__ == "__main__":
    import uvicorn

    uvicorn.run("app.main:app", host="0.0.0.0", port=PORT, reload=True)
