import 'package:flutter/cupertino.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: Center(
        child: Text(
          '둘러보기 탭',
          style: TextStyle(color: CupertinoColors.white, fontSize: 20),
        ),
      ),
    );
  }
}
