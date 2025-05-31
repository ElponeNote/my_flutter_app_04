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


def get_youtube_id(url):
    # 유튜브 ID 추출
    m = re.search(r"(?:v=|youtu.be/)([\w-]{11})", url)
    return m.group(1) if m else None


def try_download(url, path, headers=None):
    try:
        r = requests.get(url, headers=headers, timeout=10)
        if r.status_code == 200:
            with open(path, "wb") as f:
                f.write(r.content)
            return True, r.status_code
        return False, r.status_code
    except Exception as e:
        return False, str(e)


with open(ALBUM_LIST_JSON, encoding="utf-8") as f:
    album_list = json.load(f)

os.makedirs(SAVE_DIR, exist_ok=True)
log_lines = []
changed = False

for entry in album_list:
    title = safe_filename(entry["title"])
    artist = safe_filename(entry["artist"])
    url = entry["albumArtUrl"]
    ext = get_ext_from_url(url)
    filename = f"{title}_{artist}.{ext}"
    save_path = os.path.join(SAVE_DIR, filename)
    if os.path.exists(save_path):
        log_lines.append(f"SKIP (exists): {save_path}")
        continue
    # 1차 시도: 원본 URL
    ok, code = try_download(url, save_path, headers={"User-Agent": "Mozilla/5.0"})
    if ok:
        log_lines.append(f"OK: {save_path} | URL: {url}")
        continue
    # 2차 시도: 유튜브 썸네일 fallback
    youtube_url = entry.get("youtubeUrl") or entry.get("youtube_url")
    yt_id = get_youtube_id(youtube_url) if youtube_url else None
    fallback_url = (
        f"https://img.youtube.com/vi/{yt_id}/maxresdefault.jpg" if yt_id else None
    )
    fallback_ok = False
    if fallback_url and fallback_url != url:
        fallback_path = os.path.join(SAVE_DIR, f"{title}_{artist}.jpg")
        ok2, code2 = try_download(fallback_url, fallback_path)
        if ok2:
            log_lines.append(f"FALLBACK_OK: {fallback_path} | URL: {fallback_url}")
            entry["albumArtUrl"] = fallback_url
            changed = True
            fallback_ok = True
        else:
            log_lines.append(
                f"FALLBACK_FAIL ({code2}): {fallback_path} | URL: {fallback_url}"
            )
    if not fallback_ok:
        log_lines.append(f"FAIL ({code}): {save_path} | URL: {url}")

# album_list.json 동기화
if changed:
    with open(ALBUM_LIST_JSON, "w", encoding="utf-8") as f:
        json.dump(album_list, f, ensure_ascii=False, indent=2)

with open(LOG_FILE, "w", encoding="utf-8") as f:
    f.write("\n".join(log_lines))

print(f"완료: {len(album_list)}개. 로그는 {LOG_FILE} 참조.")
