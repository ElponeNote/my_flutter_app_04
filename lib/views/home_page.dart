import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/music_list_viewmodel.dart';
import '../viewmodels/player_viewmodel.dart';
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
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Music', style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.bell),
            SizedBox(width: 16),
            Icon(CupertinoIcons.search),
            SizedBox(width: 16),
            CircleAvatar(radius: 12, backgroundColor: CupertinoColors.systemGrey4),
          ],
        ),
      ),
      child: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // 카테고리 버튼 가로 스크롤
                SizedBox(
                  height: 48,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, idx) => CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      color: CupertinoColors.systemGrey5,
                      borderRadius: BorderRadius.circular(20),
                      child: Text(categories[idx], style: const TextStyle(fontSize: 15)),
                      onPressed: () {},
                    ),
                  ),
                ),
                // 플레이리스트 카드 가로 스크롤
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('빠른 선곡', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(CupertinoIcons.right_chevron, size: 20),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: playlists.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, idx) => PlaylistCard(playlist: playlists[idx]),
                  ),
                ),
                // 인기 급상승/Shorts 섹션
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('인기 급상승 Shorts 동영상', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Text('모두 재생', style: TextStyle(fontSize: 14)),
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
                    itemBuilder: (context, idx) => PlaylistCard(playlist: playlists[idx], isShorts: true),
                  ),
                ),
                const Spacer(),
                // 미니 플레이어
                const MiniPlayer(),
                // 하단 네비게이션
                const CupertinoBottomNav(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
