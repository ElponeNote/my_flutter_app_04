# Frontend 설계 문서 (음악 플레이어 앱)

---

## 1. Project Overview (프로젝트 요약)
- **프로젝트 이름**: 음악 플레이어 앱 (iOS 스타일, Cupertino 위젯)
- **목표**: PRD와 동일

---

## 2. Core Functionalities (핵심 기능)
- 홈 화면: 플레이리스트, 미니 플레이어
- 음악 재생 화면: 커버, 정보, 컨트롤러
- 하단 네비게이션: 4개 메뉴, Cupertino Icons
- YouTube URL 음악 재생

---

## 3. UI/UX 규칙
- 모든 UI는 Cupertino 위젯 기반으로 구현
- MVVM 패턴을 따른다 (View, ViewModel, Model 분리)
- 네이밍 컨벤션: 파스칼케이스(클래스), 카멜케이스(메서드/변수)
- 컴포넌트 재사용성 고려
- 반응형 레이아웃, iOS 스타일 일관성 유지
- 하드코딩 대신 상수/리소스 분리

---

## 4. 예상 파일 구조 (MVVM)

```
lib/
  main.dart
  app.dart
  models/
    music.dart
    playlist.dart
  viewmodels/
    music_list_viewmodel.dart
    player_viewmodel.dart
  views/
    music_list_page.dart
    player_page.dart
    mini_player.dart
    home_page.dart
    sample_page.dart
    explore_page.dart
    library_page.dart
  widgets/
    music_tile.dart
    cupertino_bottom_nav.dart
    ...
  resources/
    app_colors.dart
    app_icons.dart
    app_strings.dart
```

---

## 5. 작업 계획 (Step by Step)

1. **프로젝트 세팅 및 패키지 추가** (완료)
   - Cupertino, youtube_player_flutter 등
   - pubspec.yaml에 패키지 추가 및 flutter pub get 실행
   - MVVM 구조에 맞는 폴더(models, viewmodels, views, widgets, resources) 생성
2. **MVVM 구조 세팅 및 기본 파일 생성** (완료)
   - models, viewmodels, views, widgets, resources 폴더에 기본 파일 생성 및 뼈대 코드 작성
3. **기본 네비게이션/라우팅 구현** (완료)
   - CupertinoTabScaffold, 각 탭 화면 연결 및 네비게이션 동작 확인
4. **홈/음악 리스트 UI 구현** (완료)
   - [완료] 샘플 데이터 및 리스트 표시
   - [완료] 미니 플레이어 UI 하단 배치
   - [완료] 리스트 아이템 탭 시 재생 화면 이동 및 재생 처리
5. **음악 재생 화면 UI 구현**
   - 커버, 정보, 컨트롤러, 슬라이더
6. **YouTube 음악 재생 기능 구현**
   - youtube_player_flutter 연동, ViewModel 연결
7. **상태 관리 및 ViewModel 연결**
   - Provider 등 활용, View-ViewModel 바인딩
8. **UI/UX 개선 및 리팩토링**
   - 디자인 일관성, 코드 정리

---

## 6. 기타 참고 사항
- PRD 문서와 동기화하며 진행
- 디자인 참고: iOS 기본 음악 앱, YouTube Music
- 테스트 및 디버깅: 각 단계별로 확인 