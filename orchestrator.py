import time
import redis
import subprocess

REDIS_URL = "redis://redis:6379"
r = redis.Redis.from_url(REDIS_URL)

APP_SCALE_KEY = "orchestrator:app_scale"
DEFAULT_SCALE = 3
TTL = 20

print("🧠 Orchestrator online")


def get_active_nodes():
    keys = r.keys("nodes:*")
    active = []

    for k in keys:
        if r.ttl(k) > 0:
            active.append(k.decode())

    return active


def ensure_scale(target):
    print(f"⚙️ Scaling app to {target}")
    subprocess.run([
        "docker", "compose",
        "up", "-d",
        "--scale", f"app={target}"
    ])


while True:
    try:
        nodes = get_active_nodes()
        active_count = len(nodes)

        print(f"📡 Active nodes: {active_count}")

        desired_scale = max(DEFAULT_SCALE, active_count)

        current = r.get(APP_SCALE_KEY)
        current = int(current) if current else 0

        if current != desired_scale:
            r.set(APP_SCALE_KEY, desired_scale)
            ensure_scale(desired_scale)

    except Exception as e:
        print(f"⚠️ orchestrator error: {e}")

    time.sleep(10)
