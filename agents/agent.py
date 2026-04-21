import os
import time
import socket
import redis

NODE_ID = os.getenv("NODE_ID", socket.gethostname())
REDIS_URL = os.getenv("REDIS_URL", "redis://redis:6379")
HEARTBEAT_INTERVAL = int(os.getenv("HEARTBEAT_INTERVAL", "5"))

r = redis.Redis.from_url(REDIS_URL)

KEY = f"nodes:{NODE_ID}"

print(f"🧠 Agent online: {NODE_ID}")

while True:
    try:
        r.hset(KEY, mapping={
            "status": "alive",
            "timestamp": int(time.time())
        })
        r.expire(KEY, 15)
        print(f"💓 heartbeat: {NODE_ID}")
    except Exception as e:
        print(f"⚠️ heartbeat failure: {e}")

    time.sleep(HEARTBEAT_INTERVAL)
