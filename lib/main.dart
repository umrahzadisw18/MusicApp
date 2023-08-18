import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/music_player.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'song_model_provider.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(ChangeNotifierProvider(
    create: (context) => SongModelProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        useMaterial3: true,
      ),
      home: AllSongs(),
    );
  }
}

class AllSongs extends StatefulWidget {
  const AllSongs({super.key});

  @override
  State<AllSongs> createState() => _AllSongsState();
}

class _AllSongsState extends State<AllSongs> {
  final _audioQuery = new OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<SongModel> allsongs = [];

  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text(
          "Music Player",
          style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w500,
          ),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),
      body:FutureBuilder<List<SongModel>>(
          future: _audioQuery.querySongs(
            orderType: OrderType.ASC_OR_SMALLER,
            ignoreCase: true,
            sortType: null,
            uriType: UriType.EXTERNAL,
          ),
          builder: (context, item) {
            if (item.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (item.data!.isEmpty) {
              return Center(
                child: Text("No song Available"),
              );
            }
            return Stack(
              children: [
                Container(
                  height: 200,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/back.jpg"),
                      fit: BoxFit.cover,
                      )
                  ),
                  child: Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NowPlaying(
                                    songModelList: allsongs,
                                    audioPlayer: _audioPlayer,
                                  )));
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                      child: CircleAvatar(
                        radius: 30,
                        child: Icon(Icons.play_arrow,size: 35,),
                      ),
                    ),
                  ),
                ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:200.0),
                  child: ListView.builder(
                    
                    itemBuilder: (context, index) {
                      allsongs.addAll(item.data!);
                      return ListTile(
                        selectedTileColor: Colors.orange[100],
                        leading: QueryArtworkWidget(
                          id: item.data![index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: CircleAvatar(
                            child: Icon(Icons.music_note),
                            radius: 22,
                          ),
                        ),
                        title: Text(item.data![index].displayNameWOExt),
                        subtitle: Text("${item.data![index].artist}"),
                        trailing: Icon(Icons.more_horiz),
                        onTap: () {
                          // playSong(item.data![index].uri);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NowPlaying(
                                        songModelList: [item.data![index]],
                                        audioPlayer: _audioPlayer,
                                      )));
                        },
                      );
                    },
                    itemCount: item.data!.length,
                  ),
                ),
                // Align(
                //   alignment: Alignment.bottomRight,
                //   child: GestureDetector(
                //     onTap: () {
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) => NowPlaying(
                //                     songModelList: allsongs,
                //                     audioPlayer: _audioPlayer,
                //                   )));
                //     },
                //     child: Container(
                //       margin: EdgeInsets.fromLTRB(0, 0, 15, 15),
                //       child: CircleAvatar(
                //         radius: 30,
                //         child: Icon(Icons.play_arrow),
                //       ),
                //     ),
                //   ),
                // )
              ],
            );
          }),
    );
  }

  void requestPermission() {
    Permission.storage.request();
  }

  playSong(String? uri) {
    try {
      _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      _audioPlayer.play();
    } on Exception {
      log("Error Parsing song" as num);
    }
  }
}
