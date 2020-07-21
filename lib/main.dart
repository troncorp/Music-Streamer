import 'package:flutter/material.dart';
import 'package:music_player/select_lang.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Streamer',
      debugShowCheckedModeBanner: false,
      home: SelectLang(),
    );
  }
}
