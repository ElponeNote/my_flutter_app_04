import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'viewmodels/music_list_viewmodel.dart';
import 'viewmodels/player_viewmodel.dart';
import 'views/home_page.dart';
import 'views/sample_page.dart';
import 'views/explore_page.dart';
import 'views/library_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MusicListViewModel()),
        ChangeNotifierProvider(create: (_) => PlayerViewModel()),
      ],
      child: const CupertinoApp(
        debugShowCheckedModeBanner: false,
        home: MainTabScaffold(),
      ),
    );
  }
}

class MainTabScaffold extends StatefulWidget {
  const MainTabScaffold({super.key});

  @override
  State<MainTabScaffold> createState() => _MainTabScaffoldState();
}

class _MainTabScaffoldState extends State<MainTabScaffold> {
  final List<Widget> _pages = const [
    HomePage(),
    SamplePage(),
    ExplorePage(),
    LibraryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.star),
            label: '샘플',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.compass),
            label: '둘러보기',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.collections),
            label: '보관함',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return _pages[index];
      },
    );
  }
}
