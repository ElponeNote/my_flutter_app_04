import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'viewmodels/music_list_viewmodel.dart';
import 'viewmodels/player_viewmodel.dart';
import 'views/home_page.dart';

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
        home: HomePage(),
      ),
    );
  }
}
