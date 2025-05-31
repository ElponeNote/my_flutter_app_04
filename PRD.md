# PRD: iOS 스타일 음악 플레이어 홈화면

## 1. 주요 목표
- iOS 스타일의 음악 플레이어 홈화면을 Flutter(Cupertino)로 구현
- 샘플 이미지와 최대한 유사한 UI/UX
- 유튜브 음악 재생, 미니플레이어, 하단 네비게이션, 홈 인디케이터 등 iOS 감성 반영

## 2. 주요 기능 및 구조
- 상단 프로필/타이틀/카테고리 pill
- 3x3 그리드(플레이리스트)
- 인기 급상승 Shorts(가로 스크롤)
- 미니플레이어(하단 고정)
- 하단 네비게이션 바(고정)
- 홈 인디케이터(항상 맨 아래)

## 3. UI/UX 개선 및 이슈 해결 내역
- 그리드 카드 overflow, 이미지/텍스트 비율, 패딩 등 반복 조정
- 미니플레이어/네비게이션/홈 인디케이터 Stack+Positioned로 오버레이 구조로 고정
- 홈 인디케이터가 시스템 인디케이터와 겹치지 않게 SafeArea/Positioned로 위치 조정
- 미니플레이어, 네비게이션 바, 홈 인디케이터가 항상 하단에 고정되도록 Stack 구조 개선
- withOpacity deprecated 경고 Color.alphaBlend로 전면 교체
- 곡 클릭 시 PlayerPage로 이동, 유튜브 음악 재생 연동
- 불필요한 곡 리스트/미니플레이어 중복 노출 제거
- 하단 여백, 인디케이터 스타일 등 iOS 감성에 맞게 미세조정

## 4. 현재 홈 화면 구조
- Stack 기반, 하단 고정 위젯(미니플레이어, 네비게이션, 인디케이터) 항상 하단 고정
- 메인 콘텐츠는 SafeArea+SingleChildScrollView로 스크롤 가능
- 모든 위젯이 자연스럽게 이어지도록 여백/색상/스타일 반복 개선

## 5. 참고 사항
- 다음 작업 시 PRD.md와 README.md의 구조/이슈/해결 내역 반드시 참고 

## 6. 최근 작업 내역(2024-06)

### 1) 샘플 음악 데이터 및 앨범아트 관리
- 인기 음악 리스트를 실제 인기곡(제목, 아티스트, 공식 유튜브/앨범아트 URL)로 전면 교체
- `lib/resources/sample_data.dart`의 popularMusics, sampleMusics, getRandomPopularMusics 함수에 반영
- 곡별로 공식 앨범아트(멜론, 위키미디어 등)로 일괄 교체, 접근 불가/실패 이미지 Melon 등 신뢰 소스로 대체
- require/music.md의 "인기 음악 플레이리스트 (앨범아트 포함)" 섹션도 동일하게 최신화

### 2) 메인 페이지 구조 및 UI/UX 개선
- 홈 그리드/Shorts를 플레이리스트 기반에서 곡 단위 카드(MusicGridCard) 기반으로 전환
- 카드 디자인: 정사각형, 앨범아트 전체 배경, 텍스트 오버레이, 그림자, spacing 등 샘플 이미지와 유사하게 개선
- RenderFlex overflow 등 레이아웃 이슈 해결(Expanded, 비율 조정 등)
- explore_page.dart, library_page.dart, sample_page.dart 등 빈 페이지에 Cupertino 스타일 플레이스홀더 추가

### 3) 기능 개선 및 코드 정리
- 인기 음악 카드 랜덤 노출(getRandomPopularMusics)
- 불필요한 import, 중복 코드 제거 및 정리
- 앨범아트가 항상 정상적으로 로드되도록 URL 및 에러 핸들러 개선

### 4) 문서/데이터 동기화
- require/music.md, sample_data.dart 등 주요 데이터/문서의 곡 정보, 앨범아트, URL을 항상 동기화
- PRD.md에 모든 주요 변경 내역 기록(본 섹션)

## 7. 2024-06-10: 앨범아트 자동화 및 유지보수 파이프라인 구축 (중요)

### 1) 앨범아트 자동화 파이프라인(1~4단계) 완성
- sample_data.dart만 수정하면 아래 파이프라인이 자동으로 동작하도록 구조화
  1. extract_album_list.py → sample_data.dart에서 곡 정보(title, artist, albumArtUrl) 자동 추출 → album_list.json 생성
  2. download_album_art_v2.py → album_list.json 기반으로 assets/album_covers/{title}_{artist}.{ext}로 앨범아트 자동 다운로드 (중복/실패 robust하게 처리, 로그 기록)
  3. Flutter 코드(getMusicImageProvider)에서 로컬 이미지가 있으면 AssetImage, 없으면 NetworkImage로 fallback
  4. pubspec.yaml에 assets/album_covers/ 경로 등록, 주요 위젯에서 모두 적용
- 실패/오류/중복 등은 download_log.txt로 즉시 확인 가능

### 2) 코드/구조 변경 내역
- lib/utils/image_helper.dart: 로컬 우선, 네트워크 fallback 유틸 함수 구현
- music_grid_card.dart, music_tile.dart, mini_player.dart, player_page.dart 등에서 getMusicImageProvider로 통일
- pubspec.yaml에 assets/album_covers/ 등록
- 파이썬 스크립트(2종)로 데이터-이미지-앱 연동 완전 자동화

### 3) 유지보수/추가작업 원칙
- sample_data.dart만 수정 → 두 파이썬 스크립트 순차 실행 → 앱은 항상 최신 로컬/네트워크 이미지로 동작
- 홈화면 레이아웃/구조는 절대 변경하지 않고, 데이터/스타일/동작/기능만 추가/수정
- PRD.md, README.md의 자동화 파이프라인/구조/원칙을 반드시 유지하며 추가 작업 진행

--- 