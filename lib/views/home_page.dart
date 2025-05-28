import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../models/music.dart';
import '../viewmodels/music_list_viewmodel.dart';
import '../viewmodels/player_viewmodel.dart';
import '../widgets/music_tile.dart';
import 'mini_player.dart';
import 'player_page.dart';

const List<String> categories = [
  '운동', '에너지 충전', '팟캐스트', '행복한 기분', '집중', '휴식', '드라이브', '공부'
];

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final musicListViewModel = Provider.of<MusicListViewModel>(context);
    if (musicListViewModel.musics.isEmpty) {
      // 최초 진입 시 샘플 데이터 세팅
      musicListViewModel.setMusics(sampleMusics);
    }
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Music'),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 48,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                        color: CupertinoColors.systemGrey5,
                        borderRadius: BorderRadius.circular(24),
                        minSize: 36,
                        onPressed: () {},
                        child: Text(
                          categories[index],
                          style: const TextStyle(fontSize: 16, color: CupertinoColors.black),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                // 카드형 가로 스크롤 플레이리스트
                SizedBox(
                  height: 180,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: musicListViewModel.musics.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final music = musicListViewModel.musics[index];
                      return GestureDetector(
                        onTap: () {
                          Provider.of<PlayerViewModel>(context, listen: false).play(music);
                          Navigator.of(context).push(
                            CupertinoPageRoute(builder: (_) => const PlayerPage()),
                          );
                        },
                        child: Container(
                          width: 140,
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemGrey6,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: CupertinoColors.systemGrey.withOpacity(0.15),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  music.albumArtUrl,
                                  width: 140,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  music.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: CupertinoColors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  music.artist,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: CupertinoColors.systemGrey,
                                  ),
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
                const SizedBox(height: 16),
                // 기존 리스트(세로)도 필요하다면 여기에 추가 가능
                // Expanded(
                //   child: ListView.builder(...)
                // ),
              ],
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