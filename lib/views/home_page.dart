import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/music_list_viewmodel.dart';
import '../widgets/playlist_card.dart';
import '../widgets/mini_player.dart';
import '../widgets/cupertino_bottom_nav.dart';
import '../views/quick_pick_edit_page.dart';
import '../widgets/music_tile.dart';
import '../widgets/music_grid_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final musicListVM = Provider.of<MusicListViewModel>(context);
    final musics = musicListVM.musics;
    final categories = ['운동', '에너지 충전', '팟캐스트', '행복한 기분'];

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: Stack(
        children: [
          // 메인 콘텐츠 (스크롤)
          Positioned.fill(
            child: SafeArea(
              bottom: false, // 하단 고정 위젯과 겹치지 않게
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 상단 프로필/타이틀
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.orange,
                                child: Icon(CupertinoIcons.person_solid, color: Colors.white, size: 18),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('SkoolChef', style: TextStyle(fontSize: 13, color: CupertinoColors.systemGrey2)),
                                  Text('빠른 선곡', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: CupertinoColors.white)),
                                ],
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                CupertinoPageRoute(builder: (context) => const QuickPickEditPage()),
                              );
                            },
                            child: Icon(CupertinoIcons.right_chevron, color: CupertinoColors.systemGrey2, size: 22),
                          ),
                        ],
                      ),
                    ),
                    // 카테고리 pill 버튼
                    SizedBox(
                      height: 44,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, idx) => CupertinoButton(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                          color: CupertinoColors.darkBackgroundGray,
                          borderRadius: BorderRadius.circular(20),
                          child: Text(categories[idx], style: const TextStyle(fontSize: 15, color: CupertinoColors.white)),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    // 3x3 그리드
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 4),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1.1,
                        ),
                        itemCount: musics.length > 9 ? 9 : musics.length,
                        itemBuilder: (context, idx) => MusicGridCard(music: musics[idx], dark: true),
                      ),
                    ),
                    // 인기 급상승 Shorts 섹션
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('인기 급상승 Shorts 동영상', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: CupertinoColors.white)),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: Text('모두 재생', style: TextStyle(fontSize: 14, color: CupertinoColors.activeBlue)),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: musics.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, idx) => SizedBox(
                          width: 90,
                          child: MusicGridCard(music: musics[idx], dark: true),
                        ),
                      ),
                    ),
                    // 미니플레이어와 네비게이션 바 사이 간격 확보
                    SizedBox(height: 56),
                  ],
                ),
              ),
            ),
          ),
          // 미니플레이어를 Stack의 하단에 고정
          Positioned(
            left: 0,
            right: 0,
            bottom: 88,
            child: SafeArea(
              top: false, left: false, right: false, bottom: true,
              child: MiniPlayer(dark: true),
            ),
          ),
          // 네비게이션 바를 Stack의 하단에 고정
          Positioned(
            left: 0,
            right: 0,
            bottom: 32,
            child: SafeArea(
              top: false, left: false, right: false, bottom: true,
              child: CupertinoBottomNav(currentIndex: 0, onTap: (index) {}),
            ),
          ),
          // 홈 인디케이터 (항상 화면 맨 아래에 오버레이)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: 64,
                height: 6,
                decoration: BoxDecoration(
                  color: Color.alphaBlend(Colors.white.withAlpha((0.38 * 255).toInt()), Colors.transparent),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Color.alphaBlend(Colors.black.withAlpha((0.18 * 255).toInt()), Colors.transparent),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
