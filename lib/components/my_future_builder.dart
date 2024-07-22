import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:parsing_url_basic/pages/song_page.dart';
import '../fetchAPI/hitmotop_fetch.dart';

class MyFutureBulder extends StatefulWidget {
  String url;
  MyFutureBulder({
    super.key,
    required this.url,
  });

  @override
  State<MyFutureBulder> createState() => _MyFutureBulderState();
}

class _MyFutureBulderState extends State<MyFutureBulder> {
  int? length;
  // double? _progress;
  bool isPlaying = false;
  var player = AudioPlayer();

  void play(url) async {
    await player.stop();
    await player.play(UrlSource(url));
  }

    @override
  void dispose() {
    // Release all sources and dispose the player.
    player.dispose();

    super.dispose();
  }


  var fetcher = FetchHitmo();

  var currentPlayingMusic;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetcher.extractSongs((widget.url)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            if (snapshot.data == null) {
              return const Text("Null");
            } else {
              // print("Length ${snapshot.data?.length}");

              length = snapshot.data?.length;

              return Column(
                children: [
                  Text(
                    "Found $length",
                    style: const TextStyle(fontSize: 24),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              // player.play(UrlSource(snapshot.data?[index]?.url as String));
                              if (currentPlayingMusic !=
                                  snapshot.data?[index]?.url as String) {
                                play(snapshot.data?[index]?.url as String);
                                currentPlayingMusic =
                                    snapshot.data?[index]?.url as String;
                                isPlaying = true;
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => SongPage(
                                            title: snapshot.data?[index]?.title
                                                as String,
                                            singer: snapshot
                                                .data?[index]?.singer as String,
                                            url: snapshot.data?[index]?.url
                                                as String,
                                            isPlaying: isPlaying,
                                            player: player,
                                          )));
                            },
                            child: ListTile(
                              title:
                                  Text(snapshot.data?[index]?.title as String),
                              subtitle:
                                  Text(snapshot.data?[index]?.singer as String),
                              trailing: Text(
                                  snapshot.data?[index]?.fullTime as String),
                            ),
                          );
                        }),
                  ),
                ],
              );
            }
          } else {
            return const Text("Error");
          }
        });
  }
}
