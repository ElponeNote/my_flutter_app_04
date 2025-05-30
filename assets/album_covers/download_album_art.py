import requests
import os

album_list = [
    # 인기 음악 플레이리스트 (앨범아트 URL 있음)
    ("APT", "로제", "https://image.bugsm.co.kr/album/images/500/40913/4091347.jpg"),
    (
        "The Lazy Song",
        "브루노마스",
        "https://upload.wikimedia.org/wikipedia/en/0/02/Bruno_Mars_-_Doo-Wops_%26_Hooligans.png",
    ),
    (
        "Super Shy",
        "NewJeans",
        "https://image.genie.co.kr/Y/IMAGE/IMG_ALBUM/083/857/682/83857682_1688713360510_1_600x600.JPG",
    ),
    (
        "EASY",
        "LE SSERAFIM",
        "https://image.genie.co.kr/Y/IMAGE/IMG_ALBUM/084/000/857/84000857_1708053660192_1_600x600.JPG",
    ),
    (
        "I AM",
        "IVE",
        "https://image.genie.co.kr/Y/IMAGE/IMG_ALBUM/084/000/329/84000329_1681194633280_1_600x600.JPG",
    ),
    (
        "Candy",
        "NCT DREAM",
        "https://image.genie.co.kr/Y/IMAGE/IMG_ALBUM/083/805/805/83805805_1671089630100_1_600x600.JPG",
    ),
    (
        "F*ck My Life",
        "SEVENTEEN",
        "https://image.genie.co.kr/Y/IMAGE/IMG_ALBUM/084/000/393/84000393_1682059633280_1_600x600.JPG",
    ),
    (
        "Love Lee",
        "AKMU",
        "https://image.genie.co.kr/Y/IMAGE/IMG_ALBUM/084/000/857/84000857_1691639633280_1_600x600.JPG",
    ),
    (
        "Dynamite",
        "BTS",
        "https://upload.wikimedia.org/wikipedia/en/9/9b/BTS_-_Dynamite_%28official_cover%29.png",
    ),
    (
        "How You Like That",
        "BLACKPINK",
        "https://upload.wikimedia.org/wikipedia/en/0/0e/Blackpink_-_How_You_Like_That.png",
    ),
    # 유튜브 리스트 (아래는 예시, 실제 URL은 위키 등에서 수집 필요)
    (
        "Shape of You",
        "Ed Sheeran",
        "https://upload.wikimedia.org/wikipedia/en/4/45/Divide_cover.png",
    ),
    (
        "Blinding Lights",
        "The Weeknd",
        "https://upload.wikimedia.org/wikipedia/en/0/09/The_Weeknd_-_After_Hours.png",
    ),
    (
        "Someone Like You",
        "Adele",
        "https://upload.wikimedia.org/wikipedia/en/1/1b/Adele_-_21.png",
    ),
    (
        "Uptown Funk",
        "Mark Ronson ft. Bruno Mars",
        "https://upload.wikimedia.org/wikipedia/en/4/4d/Mark_Ronson_-_Uptown_Special.png",
    ),
    (
        "Señorita",
        "Shawn Mendes, Camila Cabello",
        "https://upload.wikimedia.org/wikipedia/en/2/2e/Shawn_Mendes_and_Camila_Cabello_-_Se%C3%B1orita.png",
    ),
    (
        "bad guy",
        "Billie Eilish",
        "https://upload.wikimedia.org/wikipedia/en/7/7e/Billie_Eilish_-_When_We_All_Fall_Asleep%2C_Where_Do_We_Go%3F.png",
    ),
    (
        "Levitating",
        "Dua Lipa",
        "https://upload.wikimedia.org/wikipedia/en/0/0a/Dua_Lipa_-_Future_Nostalgia_%28Official_Album_Cover%29.png",
    ),
    (
        "STAY",
        "The Kid LAROI, Justin Bieber",
        "https://upload.wikimedia.org/wikipedia/en/2/2e/The_Kid_Laroi_and_Justin_Bieber_-_Stay.png",
    ),
    (
        "Peaches",
        "Justin Bieber",
        "https://upload.wikimedia.org/wikipedia/en/7/7e/Justin_Bieber_-_Justice.png",
    ),
    # ... (나머지 곡도 동일하게 추가)
]

os.makedirs("assets/album_covers", exist_ok=True)

for title, artist, url in album_list:
    # URL에서 확장자 추출
    ext = url.split(".")[-1].split("?")[0]
    if ext.lower() not in ["jpg", "jpeg", "png", "webp"]:
        ext = "jpg"  # 기본값
    filename = f"assets/album_covers/{title}_{artist}.{ext}".replace(" ", "_").replace(
        "/", "_"
    )
    try:
        r = requests.get(url, timeout=10)
        if r.status_code == 200:
            with open(filename, "wb") as f:
                f.write(r.content)
            print(f"Downloaded: {filename}")
        else:
            print(f"Failed: {filename} (status {r.status_code})")
    except Exception as e:
        print(f"Error: {filename} ({e})")
