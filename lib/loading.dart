import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:music_player/HomeScreen.dart';
import 'package:music_player/util/data.dart';
import 'package:music_player/util/helper.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    int sec = 0;
    super.initState();
    Timer.periodic(Duration(seconds: sec += 5), (t) {
      NetworkHelper().getSongsList(10, 0);
      if (kSongs.length >= 10) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
        t.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: SpinKitChasingDots(
            color: Colors.grey,
            size: 100.0,
          ),
        ),
      ),
    );
  }
}
