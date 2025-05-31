import os
import json
import requests
import re

ALBUM_LIST_JSON = "album_list.json"  # Run from project root
SAVE_DIR = "assets/album_covers"
LOG_FILE = "download_log.txt"


# 파일명 안전하게 변환
def safe_filename(s):
    s = re.sub(r"[^\w\-가-힣]", "_", s)
    return s


def get_ext_from_url(url):
    ext = url.split(".")[-1].split("?")[0].lower()
    if ext not in ["jpg", "jpeg", "png", "webp"]:
        ext = "jpg"
    return ext


with open(ALBUM_LIST_JSON, encoding="utf-8") as f:
    album_list = json.load(f)

os.makedirs(SAVE_DIR, exist_ok=True)
log_lines = []

for entry in album_list:
    title = safe_filename(entry["title"])
    artist = safe_filename(entry["artist"])
    url = entry["albumArtUrl"]
    ext = get_ext_from_url(url)
    filename = f"{SAVE_DIR}/{title}_{artist}.{ext}"
    if os.path.exists(filename):
        log_lines.append(f"SKIP (exists): {filename}")
        continue
    try:
        r = requests.get(url, timeout=10)
        if r.status_code == 200 and r.content and len(r.content) > 1000:
            with open(filename, "wb") as f:
                f.write(r.content)
            log_lines.append(f"DOWNLOADED: {filename}")
        else:
            log_lines.append(f"FAIL ({r.status_code}): {filename} | URL: {url}")
    except Exception as e:
        log_lines.append(f"ERROR: {filename} | {e} | URL: {url}")

with open(LOG_FILE, "w", encoding="utf-8") as f:
    f.write("\n".join(log_lines))

print(f"완료: {len(log_lines)}개. 로그는 {LOG_FILE} 참조.")
