import 'package:flutter/cupertino.dart';

class SamplePage extends StatelessWidget {
  const SamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('샘플'),
      ),
      child: Center(
        child: Text('샘플 화면'),
      ),
    );
  }
} 