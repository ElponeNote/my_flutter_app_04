import 'package:flutter/cupertino.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('둘러보기'),
      ),
      child: Center(
        child: Text('둘러보기 화면'),
      ),
    );
  }
} 