import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../models/music.dart';
import '../viewmodels/music_list_viewmodel.dart';
import '../viewmodels/player_viewmodel.dart';
import 'mini_player.dart';
import 'player_page.dart';

const List<String> moods = [
  '운동', '에너지 충전', '팟캐스트', '행복한 기분',
  '집중', '휴식', '드라이브', '공부',
];

const List<Map<String, String>> quickPlaylists = [
  {
    'title': 'APT.',
    'artist': 'ROSÉ',
    'image': 'https://i.imgur.com/1.jpg',
    'color': '0xFFFFE0E0',
  },
  {
    'title': 'Pretender',
    'artist': 'Official髭男dism',
    'image': 'https://i.imgur.com/2.jpg',
    'color': '0xFFE0F7FA',
  },
  {
    'title': '뭘 알아 (Remix)',
    'artist': '창모',
    'image': 'https://i.imgur.com/3.jpg',
    'color': '0xFFFFF3E0',
  },
  {
    'title': 'This is Me',
    'artist': 'The Greatest Showman',
    'image': 'https://i.imgur.com/4.jpg',
    'color': '0xFFE1BEE7',
  },
  {
    'title': 'Bubble Gum',
    'artist': 'NewJeans',
    'image': 'https://i.imgur.com/5.jpg',
    'color': '0xFFE0F2F1',
  },
  {
    'title': 'K-히트리스트',
    'artist': 'Various',
    'image': 'https://i.imgur.com/6.jpg',
    'color': '0xFFFFF9C4',
  },
  {
    'title': 'GODS',
    'artist': 'NewJeans',
    'image': 'https://i.imgur.com/7.jpg',
    'color': '0xFFD1C4E9',
  },
  {
    'title': '광화문',
    'artist': 'Various',
    'image': 'https://i.imgur.com/8.jpg',
    'color': '0xFFFFECB3',
  },
];

const List<Map<String, String>> shortsVideos = [
  {
    'title': 'No One Else Like You',
    'artist': 'Adam Levine',
    'image': 'https://i.imgur.com/short1.jpg',
  },
  {
    'title': 'Dance Vibes',
    'artist': 'DJ Snake',
    'image': 'https://i.imgur.com/short2.jpg',
  },
  {
    'title': 'Chill Beats',
    'artist': 'Lo-Fi',
    'image': 'https://i.imgur.com/short3.jpg',
  },
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final musicListViewModel = Provider.of<MusicListViewModel>(context);
    if (musicListViewModel.musics.isEmpty) {
      musicListViewModel.setMusics(sampleMusics);
    }
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Music'),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. 상단 mood 버튼 2줄
                  Padding(
                    padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: moods.map((mood) => CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        color: CupertinoColors.systemGrey5,
                        borderRadius: BorderRadius.circular(14),
                        onPressed: () {},
                        child: Text(mood, style: const TextStyle(fontSize: 15, color: CupertinoColors.black)),
                      )).toList(),
                    ),
                  ),
                  const SizedBox(height: 18),
                  // 2. 빠른 선곡 + 프로필
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemOrange,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(CupertinoIcons.person_solid, color: CupertinoColors.white, size: 22),
                        ),
                        const SizedBox(width: 10),
                        const Text('FREAINER', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(width: 8),
                        const Text('빠른 선곡', style: TextStyle(fontSize: 15, color: CupertinoColors.systemGrey)),
                        const Spacer(),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          minSize: 0,
                          onPressed: () {},
                          child: const Icon(CupertinoIcons.chevron_right, size: 22, color: CupertinoColors.systemGrey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // 3. 앨범/플레이리스트 그리드
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 1.15,
                      ),
                      itemCount: quickPlaylists.length,
                      itemBuilder: (context, index) {
                        final item = quickPlaylists[index];
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(int.parse(item['color']!)),
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: CupertinoColors.systemGrey.withOpacity(0.10),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.network(
                                    item['image']!,
                                    width: double.infinity,
                                    height: 90,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    item['title']!,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: CupertinoColors.black),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    item['artist']!,
                                    style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  // 4. 인기 급상승 Shorts 동영상 섹션
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('인기 급상승 Shorts 동영상', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                        CupertinoButton(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          color: CupertinoColors.activeBlue,
                          borderRadius: BorderRadius.circular(14),
                          minSize: 28,
                          onPressed: () {},
                          child: const Text('모두 재생', style: TextStyle(fontSize: 14, color: CupertinoColors.white)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 90,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: shortsVideos.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 14),
                      itemBuilder: (context, index) {
                        final item = shortsVideos[index];
                        return Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                item['image']!,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: 70,
                              child: Text(
                                item['title']!,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: MiniPlayer(),
          ),
        ],
      ),
    );
  }
} 