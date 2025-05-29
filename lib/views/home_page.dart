import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/music_list_viewmodel.dart';
import '../widgets/playlist_card.dart';
import '../widgets/mini_player.dart';
import '../widgets/cupertino_bottom_nav.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final musicListVM = Provider.of<MusicListViewModel>(context);
    final playlists = musicListVM.playlists;
    final categories = ['운동', '에너지 충전', '팟캐스트', '행복한 기분'];

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
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
                          Icon(CupertinoIcons.right_chevron, color: CupertinoColors.systemGrey2, size: 22),
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
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1.1,
                        ),
                        itemCount: playlists.length > 9 ? 9 : playlists.length,
                        itemBuilder: (context, idx) => PlaylistCard(playlist: playlists[idx], dark: true),
                      ),
                    ),
                    // 인기 급상승 Shorts 섹션
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 18, right: 16, bottom: 6),
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
                        itemCount: playlists.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, idx) => PlaylistCard(playlist: playlists[idx], isShorts: true, dark: true),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 미니 플레이어
            const MiniPlayer(dark: true),
            // 하단 네비게이션
            CupertinoBottomNav(currentIndex: 0, onTap: (index) {}),
            // 홈 인디케이터 (SafeArea로 감싸서 시스템 인디케이터 위에 위치)
            SafeArea(
              top: false,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 6, bottom: 0),
                  width: 80,
                  height: 7,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
