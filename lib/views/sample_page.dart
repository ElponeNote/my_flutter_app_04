import 'package:flutter/cupertino.dart';

class SamplePage extends StatelessWidget {
  const SamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: Center(
        child: Text(
          '샘플 탭',
          style: TextStyle(color: CupertinoColors.white, fontSize: 20),
        ),
      ),
    );
  }
}
