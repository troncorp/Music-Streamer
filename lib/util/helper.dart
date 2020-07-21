import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:music_player/model/song_tile.dart';

import 'data.dart';

class NetworkHelper {
  static int i = 0;
  Future<dynamic> _getSongsData(int limit, int offset) async {
    var res = await http.post(
      'http://3.6.166.16:3100/api/v1/app/get-all-song',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "limit": limit,
        "offset": offset,
        "song_type": kLangSel,
      }),
    );
//    print(res.body);
    return jsonDecode(res.body);
  }

  Future<dynamic> _getSongLink(id) async {
    var res = await http.post(
      'http://3.6.166.16:3100/api/v1/app/get-url',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"song_id": "$id"}),
    );
//    print(res.body);
    return jsonDecode(res.body);
  }

  getSongsList(int limit, int offset) async {
    print("limit: $limit, offset: $offset");
    String langData = "";
    if (kLangSel == "ENG") {
      langData = "engSong";
    } else {
      langData = "hndSong";
    }
    dynamic res = await NetworkHelper()._getSongsData(limit, offset);
    for (; i < res['data'][langData].length; i++) {
      String id = res['data'][langData][i]['id'];
      dynamic songUrl = await NetworkHelper()._getSongLink(id);
      var title = songUrl['data']['URL']['title'];
      var url = songUrl['data']['URL']['url'];
      var thumbnail = songUrl['data']['URL']['thumbnail'];
      var dur = songUrl['data']['URL']['duration'];
      kSongs.add(
        SongTile(
          title: title,
          url: url,
          thumbnail: thumbnail,
          duration: dur,
        ),
      );
    }
  }
}
