import re
import json

# sample_data.dart 경로
DART_FILE = "lib/resources/sample_data.dart"
OUTPUT_JSON = "album_list.json"

pattern = re.compile(
    r"Music\s*\(\s*title:\s*'([^']+)',\s*artist:\s*'([^']+)',\s*albumArtUrl:\s*'([^']+)'",
    re.MULTILINE,
)

with open(DART_FILE, encoding="utf-8") as f:
    dart_code = f.read()

album_list = []
for match in pattern.finditer(dart_code):
    title, artist, albumArtUrl = match.groups()
    album_list.append({"title": title, "artist": artist, "albumArtUrl": albumArtUrl})

with open(OUTPUT_JSON, "w", encoding="utf-8") as f:
    json.dump(album_list, f, ensure_ascii=False, indent=2)

print(f"Extracted {len(album_list)} entries to {OUTPUT_JSON}")
 