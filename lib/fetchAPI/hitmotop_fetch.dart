import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:parsing_url_basic/components/song.dart';

class FetchHitmo {
  Future<List<Song?>> extractSongs(String url) async {
    var response = await http.Client().get(Uri.parse(url));
    if (response.statusCode == 200) {
      var document = parser.parse(response.body);
      try {
        List<String?> songUrls = document
            .querySelectorAll('a.track__download-btn')
            .map((element) => element.attributes['href'])
            .toList();
        print('songUrls Length: ${songUrls.length}');
        List<String?> songTitles = document
            .querySelectorAll('.track__title')
            .map((element) => element.text.trim())
            .toList();
        print('songTitles Length: ${songUrls.length}');
        List<String?> songSingers = document
            .querySelectorAll('.track__desc')
            .map((element) => element.text)
            .toList();
        print('songSingers Length: ${songUrls.length}');
        List<String?> songFullTime = document
            .querySelectorAll('.track__fulltime')
            .map((element) => element.text)
            .toList();
        print('songFullTime Length: ${songUrls.length}');
        List<Song?> songs = List.empty(growable: true);
        for (var i = 0; i < songUrls.length; i++) {
          songs.add(Song(
              songTitles[i], songSingers[i], songFullTime[i], songUrls[i]));
        }
        print("Songs length: ${songs.length}");
        return songs;
      } catch (e) {
        return [null];
      }
    } else {
      return [null];
    }
  }
}
