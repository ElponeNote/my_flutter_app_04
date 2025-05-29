# Flutter iOS 스타일 음악 플레이어

## 소개
- iOS 감성의 음악 플레이어 홈화면을 Flutter(Cupertino)로 구현
- 유튜브 음악 재생, 미니플레이어, 하단 네비게이션, 홈 인디케이터 등 iOS 스타일 반영

## 설치 및 실행
```bash
flutter pub get
flutter run
```

## 주요 구조
- `lib/views/home_page.dart`: 홈화면 전체 구조(Stack+Positioned)
- `lib/widgets/mini_player.dart`: 하단 미니플레이어(고정)
- `lib/widgets/cupertino_bottom_nav.dart`: 하단 네비게이션 바(고정)
- `lib/widgets/music_tile.dart`, `playlist_card.dart`: 곡/플레이리스트 카드
- `lib/views/player_page.dart`: 유튜브 음악 재생화면

## UI/UX 특징 및 개선 내역
- 상단 프로필/카테고리, 3x3 그리드, Shorts, 미니플레이어, 네비게이션, 홈 인디케이터 등 iOS 스타일 구현
- 하단 고정 위젯(미니플레이어, 네비게이션, 인디케이터) Stack+Positioned로 항상 하단 고정
- withOpacity deprecated 경고 Color.alphaBlend로 전면 교체
- 곡 클릭 시 PlayerPage로 이동, 유튜브 음악 재생
- 불필요한 곡 리스트/미니플레이어 중복 노출 제거
- 하단 여백, 인디케이터 스타일 등 iOS 감성에 맞게 반복 개선

## 기술적 이슈 및 해결
- Stack/SafeArea/Positioned 구조로 하단 고정 위젯이 항상 하단에 위치하도록 개선
- 시스템 인디케이터와 겹치지 않게 SafeArea/Positioned 조합
- withOpacity → Color.alphaBlend로 마이그레이션

## 참고/향후 작업
- PRD.md의 구조/이슈/해결 내역을 반드시 참고하여 추가 개발 진행

## ⚠️ 홈화면 레이아웃 고정 원칙

> 홈화면의 레이아웃은 더이상 변화하지 않도록 반드시 명심해

네, 알겠습니다!
앞으로 홈화면의 레이아웃(섹션 구조, 배치, 고정 위젯 등)은 변경하지 않고 유지하겠습니다.
홈화면의 구조(상단, 3x3 그리드, Shorts, 미니플레이어, 네비게이션, 홈 인디케이터 등)는 그대로 두고,
추가 요청이 있을 경우, 홈화면 레이아웃을 건드리지 않는 선에서(예: 스타일, 기능, 데이터, 동작 등)만 작업하겠습니다.
혹시 홈화면에서 동작(예: 클릭 시 이동, 색상, 텍스트 등)만 수정이 필요하다면 언제든 말씀해 주세요!
레이아웃 구조는 절대 변경하지 않겠습니다.
