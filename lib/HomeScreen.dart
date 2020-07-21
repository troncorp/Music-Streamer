import 'dart:async';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:music_player/util/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:just_audio/just_audio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_player/util/helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  static bool isPlaying = false;
  static bool fetched = false;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final player = AudioPlayer();
  PageController controller =
      PageController(viewportFraction: 0.95, initialPage: 0);
  int currentPage = 0;
  var thumbnailUrl = 'https://media.giphy.com/media/WiIuC6fAOoXD2/giphy.gif';
  bool setOnce = true;
  double value = 0;
  int x = 1;
  bool sendReq = false;
  Duration _duration = new Duration();
  Duration _position = new Duration();

  _setCurrentSongUrl() async {
    try {
      if (kSongs.length > 0) await player.setUrl(kSongs[currentPage].url);
      _duration = await player.durationFuture;
      _position = player.position;
      if (HomeScreen.isPlaying) {
        _playSong();
      }
//      print(_duration);
    } catch (e) {
      print(e);
    }
    //  print(kSongs[currentPage].url);
  }

  _playSong() async {
    await player.play();
  }

  _pauseSong() async {
    await player.pause();
  }

  _seekSong() async {
    await player.seek(_position);
  }

  _refreshDataUi() {
    Future.delayed(Duration(milliseconds: 100)).then((_) async {
      setState(() {
        if ((kSongs.length > 0) & setOnce) {
          HomeScreen.fetched = true;
          setOnce = false;
        }
        if (player.position.inSeconds.toDouble() ==
                _duration.inSeconds.toDouble() &&
            HomeScreen.isPlaying) {
          controller.animateToPage(++currentPage,
              curve: Curves.easeOutQuint,
              duration: Duration(milliseconds: 1000));
          _setCurrentSongUrl();
        }
      });
      if (currentPage == 9 * x) {
        await NetworkHelper().getSongsList(currentPage + 10, currentPage);
        x++;
      }
      _refreshDataUi();
    });
  }

  @override
  void initState() {
    super.initState();
    _setCurrentSongUrl();
    _refreshDataUi();
    _initDownloader();
    controller.addListener(() {
      int next = controller.page.round();

      if (currentPage != next) {
        setState(() {
          currentPage = next;
          _setCurrentSongUrl();
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView.builder(
            controller: controller,
            itemCount: kSongs.length,
            itemBuilder: (context, int curIndex) {
              bool active = curIndex == currentPage;
              return _buildSongTile(active, kSongs);
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white70,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    width: width / 1.3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          "${player.position.inMinutes}:${(player.position.inSeconds.remainder(60))}",
                          style: TextStyle(color: Colors.black87, fontSize: 18),
                        ),
                        Container(
                          width: width / 1.8,
                          child: CupertinoSlider(
                            activeColor: Colors.black87,
                            onChanged: (val) {
                              setState(() {
                                _position = Duration(seconds: val.toInt());
                                _seekSong();
                              });
                            },
                            value: player.position.inSeconds.toDouble() ?? 0,
                            min: 0,
                            max: _duration.inSeconds.toDouble() ?? 0.00,
                          ),
                        ),
                        Text(
                          "${_duration.inMinutes}:${(_duration.inSeconds.remainder(60))}",
                          style: TextStyle(color: Colors.black87, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.backward,
                          color: Colors.black87,
                        ),
                        onPressed: () {
                          if (currentPage > 0)
                            setState(() {
                              controller.animateToPage(
                                --currentPage,
                                curve: Curves.easeOutQuint,
                                duration: Duration(milliseconds: 1000),
                              );
                              _setCurrentSongUrl();
                            });
                        },
                      ),
                      IconButton(
                          icon: Icon(
                            HomeScreen.isPlaying
                                ? FontAwesomeIcons.pause
                                : FontAwesomeIcons.play,
                            color: Colors.black87,
                          ),
                          onPressed: () async {
                            if (HomeScreen.isPlaying) {
                              setState(() {
                                HomeScreen.isPlaying = false;
                                _pauseSong();
                              });
                            } else {
                              setState(() {
                                HomeScreen.isPlaying = true;
                                _playSong();
                              });
                            }
                          }),
                      IconButton(
                          icon: Icon(
                            FontAwesomeIcons.forward,
                            color: Colors.black87,
                          ),
                          onPressed: () {
                            if (currentPage < kSongs.length)
                              setState(() {
                                controller.animateToPage(++currentPage,
                                    curve: Curves.easeOutQuint,
                                    duration: Duration(milliseconds: 1000));
                                _setCurrentSongUrl();
                              });
                          }),
                    ],
                  ),
                  Container(
                    height: 50,
                    child: Marquee(
                      text: kSongs[currentPage].title,
                      style: TextStyle(fontSize: 24),
                      accelerationCurve: Curves.easeOutQuint,
                      velocity: 50.0,
                      pauseAfterRound: Duration(seconds: 3),
                      startPadding: 10.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 15,
            right: 25,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white70,
              ),
              child: IconButton(
                icon: Icon(FontAwesomeIcons.arrowDown),
                color: Colors.black87,
                onPressed: () {
                  _downloadCurSong();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongTile(bool active, dynamic songData) {
    // Animated Properties
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 10 : 100;

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(top: top, bottom: 10, right: 10, left: 10),
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              songData[currentPage].thumbnail.toString().replaceAll("\n", "") ??
                  thumbnailUrl,
            ),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black87,
                blurRadius: blur,
                offset: Offset(offset, offset))
          ]),
    );
  }

  _downloadCurSong() async {
    print("trying to download");

    if (await Permission.storage.request().isGranted) {
      await FlutterDownloader.enqueue(
        url: kSongs[currentPage].url,
        savedDir: "/storage/emulated/0/Download/",
        fileName: kSongs[currentPage].title + ".mp3",
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );
    } else {
      AlertDialog(
        content: Text(
          "Please allow strage access",
          textScaleFactor: 1.25,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text("Permission Denied *_* "),
        backgroundColor: Colors.white70,
      );
    }
  }

  void _initDownloader() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize(
        debug: true // optional: set false to disable printing logs to console
        );
  }
}
