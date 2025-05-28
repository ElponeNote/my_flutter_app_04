import 'package:flutter/cupertino.dart';

class MusicListPage extends StatelessWidget {
  const MusicListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('음악 리스트'),
      ),
      child: Center(
        child: Text('음악 리스트 화면'),
      ),
    );
  }
} 