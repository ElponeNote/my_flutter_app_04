import 'package:flutter/cupertino.dart';

class CupertinoBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CupertinoBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTabBar(
      currentIndex: currentIndex,
      onTap: onTap,
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
    );
  }
} 