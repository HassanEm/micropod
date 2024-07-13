import 'package:flutter/material.dart';
import 'package:micropod/models/fav_pool.dart';
import 'package:micropod/models/universal_audio_player.dart';
import 'package:micropod/screens/init_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UniversalAudioPlayer()),
        ChangeNotifierProvider(create: (context) => FavPool())
      ],
      builder: (context, child) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.dark,
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const InitScreen(),
      ),
    );
  }
}
