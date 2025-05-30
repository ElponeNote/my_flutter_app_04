import 'package:flutter/cupertino.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: Center(
        child: Text(
          '보관함 탭',
          style: TextStyle(color: CupertinoColors.white, fontSize: 20),
        ),
      ),
    );
  }
}
