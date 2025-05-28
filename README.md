# iOS 스타일 음악 플레이어 (Flutter, Cupertino)

## 프로젝트 개요
- **목표**: YouTube Music 스타일을 iOS(Cupertino) 디자인으로 재해석한 음악 플레이어 앱 구현
- **주요 기능**:
  - 메인 화면: 카테고리, 카드형 플레이리스트, 미니 플레이어
  - 재생 화면: 앨범 커버, 곡 정보, 컨트롤러, 슬라이더, YouTube 음악 재생
  - 하단 네비게이션: 홈, 샘플, 둘러보기, 보관함
  - MVVM 패턴, Provider 상태관리

## 폴더/파일 구조 (주요)
```
lib/
  main.dart
  models/
    music.dart
    playlist.dart
  viewmodels/
    music_list_viewmodel.dart
    player_viewmodel.dart
  views/
    home_page.dart
    mini_player.dart
    player_page.dart
    sample_page.dart
    explore_page.dart
    library_page.dart
  widgets/
    music_tile.dart
    cupertino_bottom_nav.dart
  resources/
    (테마, 컬러, 샘플 데이터 등)
frontend.md
README.md
```

## 사용 패키지
- cupertino_icons
- provider
- youtube_player_flutter

## 구현 완료 내역
- [x] 프로젝트 세팅 및 패키지 추가
- [x] MVVM 구조 및 기본 파일 생성 (models, viewmodels, views, widgets, resources)
- [x] 네비게이션/라우팅 (CupertinoTabScaffold, 4개 탭)
- [x] 메인 화면: 가로 스크롤 카테고리 버튼, 카드형 플레이리스트(가로 스크롤), 미니 플레이어(앨범 썸네일, 곡 정보, 재생/일시정지)
- [x] 재생 화면: 앨범 커버(라운드), 곡 정보(계층적 폰트), 좋아요/저장/공유, 슬라이더(YouTubePlayer 연동), 재생 컨트롤러(이전/재생/다음)
- [x] YouTube 음악 재생(실제 곡 재생, 슬라이더/시간 연동, seek 동작)
- [x] 전체 iOS 스타일 UI/UX 적용 (여백, 컬러톤, 정렬, 그림자 등)
- [x] PRD(제품 요구사항 문서), frontend.md(프론트엔드 설계 문서) 작성 및 관리
- [x] README.md에 작업 내역, 구조, 진행상황 기록

## 추가 작업 예정
- UX 디테일 개선(에러 처리, 애니메이션 등)
- 플레이리스트/카테고리별 필터링
- 곡/플레이리스트 데이터 확장
- 기타 기능(반복, 셔플, 가사 등)
- 테스트 및 코드 리팩토링

---

> 이 README는 현재까지의 작업 내역을 기록하며, 이후 추가 작업 시 참조용으로 사용합니다.

