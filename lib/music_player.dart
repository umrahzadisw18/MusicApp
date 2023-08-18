// import 'dart:developer';

// import 'package:audio_service/audio_service.dart';
// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:on_audio_query/on_audio_query.dart';
// import 'package:provider/provider.dart';

// class MusicPlayer extends StatefulWidget {
//   const MusicPlayer(
//       {super.key, required this.songModelList, required this.audioPlayer});
//   final List<SongModel> songModelList;
//   final AudioPlayer audioPlayer;

  

//   @override
//   State<MusicPlayer> createState() => _MusicPlayerState();
// }

// class _MusicPlayerState extends State<MusicPlayer> {
//   bool _isPlaying = false;
//   Duration _duration = Duration();
//   Duration _position = Duration();
//   List<AudioSource> songList=[];
//   int currentIndex=0;

//   @override
//   void initState() {
//     super.initState();
//     playSong();
//   }
//   void listenToEvent() {
//     widget.audioPlayer.playerStateStream.listen((state) {
//       if (state.playing) {
//         setState(() {
//           _isPlaying = true;
//         });
//       } else {
//         setState(() {
//           _isPlaying = false;
//         });
//       }
//       if (state.processingState == ProcessingState.completed) {
//         setState(() {
//           _isPlaying = false;
//         });
//       }
//     });
//   }
//     void listenToSongIndex() {
//     widget.audioPlayer.currentIndexStream.listen(
//       (event) {
//         setState(
//           () {
//             if (event != null) {
//               currentIndex = event;
//             }
//             context
//                 .read<SongModelProvider>()
//                 .setId(widget.songModelList[currentIndex].id);
//           },
//         );
//       },
//     );
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//           child: Container(
//         width: double.infinity,
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             IconButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 icon: Icon(Icons.arrow_back_ios)),
//             SizedBox(
//               height: 30,
//             ),
//           Expanded(
//               child: Column(children: [
//                 Center(
//                   child: CircleAvatar(
//                   radius: 100,
//                     child: QueryArtworkWidget(
//                       artworkWidth: 200,
//                       artworkHeight: 200,
//                       artworkFit: BoxFit.cover,
//                       id: context.watch<SongModelProvider>().id,
//                       type: ArtworkType.AUDIO,
//                       nullArtworkWidget: CircleAvatar(
//                         child: Icon(Icons.music_note),
                        
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 Text(
//                   widget.songModelList[currentIndex].displayNameWOExt,
//                   overflow: TextOverflow.fade,
//                   maxLines: 1,
//                   style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   widget.songModelList[currentIndex].artist.toString(),
//                   overflow: TextOverflow.fade,
//                   maxLines: 1,
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 Row(
//                   children: [
//                     Text(_position.toString().split(".")[0]),
//                     Expanded(
//                         child: Slider(
//                             value: _position.inSeconds.toDouble(),
//                             max: _duration.inSeconds.toDouble(),
//                             min: Duration(microseconds: 0).inSeconds.toDouble(),
//                             onChanged: (value) {
//                               setState(() {
//                                 changeToSeconds(value.toInt());
//                                 value = value;
//                               });
//                             })),
//                     Text(_duration.toString().split(".")[0]),
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     IconButton(
//                         onPressed: () {
//                         if (widget.audioPlayer.hasPrevious) {
//                               widget.audioPlayer.seekToPrevious();
//                             }
//                         },
//                         icon: Icon(
//                           Icons.skip_previous,
//                           size: 40,
//                         )),
//                     IconButton(
//                         onPressed: () {
//                           setState(() {
//                             if (_isPlaying) {
//                               widget.audioPlayer.pause();
//                             } else {
//                               widget.audioPlayer.play();
//                             }
//                             _isPlaying = !_isPlaying;
//                           });
//                         },
//                         icon: Icon(
//                           _isPlaying ? Icons.pause : Icons.play_arrow,
//                           size: 40,
//                           color: Colors.deepOrangeAccent,
//                         )),
//                     IconButton(
//                         onPressed: () {
//                           if (widget.audioPlayer.hasNext) {
//                               widget.audioPlayer.seekToNext();
//                             }
//                         },
//                         icon: Icon(
//                           Icons.skip_next,
//                           size: 40,
//                         )),
//                   ],
//                 )
//               ]),
//             ),
//           ],
//         ),
//       )),
//     );
//   }

//   void playSong() {
//     try {
//       widget.songModelList.forEach((element) {
//         songList.add(
//           AudioSource.uri(
//         Uri.parse(element.uri!),
//         tag: MediaItem(
//           id: "${element.id}",
//           album: "${element.album}",
//           title: element.displayNameWOExt,
//           artUri: Uri.parse('https://example.com/albumart.jpg'),
//         ),
//       )
//         );
//       });

//       widget.audioPlayer.setAudioSource(
//         ConcatenatingAudioSource(children: songList),
//       );
//       widget.audioPlayer.play();
//       _isPlaying = true;
//     } on Exception {
//       log("song cannot parse");
//     }
//     widget.audioPlayer.durationStream.listen((d) {
//       setState(() {
//         _duration = d!;
//       });
//     });
//     widget.audioPlayer.positionStream.listen((p) {
//       setState(() {
//         _position = p;
//       });
//     });
//     listenToEvent();
//     listenToSongIndex();
//   }

//   void changeToSeconds(int seconds) {
//     Duration duration = Duration(seconds: seconds);
//     widget.audioPlayer.seek(duration);
//   }
// }


import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/song_model_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';


class NowPlaying extends StatefulWidget {
  final List<SongModel> songModelList;
  final AudioPlayer audioPlayer;

  const NowPlaying(
      {Key? key, required this.songModelList, required this.audioPlayer})
      : super(key: key);

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  Duration _duration = const Duration();
  Duration _position = const Duration();

  bool _isPlaying = false;
  List<AudioSource> songList = [];

  int currentIndex = 0;

  void popBack() {
    Navigator.pop(context);
  }

  void seekToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }

  @override
  void initState() {
    super.initState();
    parseSong();
  }

  void parseSong() {
    try {
      for (var element in widget.songModelList) {
        songList.add(
          AudioSource.uri(
            Uri.parse(element.uri!),
            tag: MediaItem(
              id: element.id.toString(),
              album: element.album ?? "No Album",
              title: element.displayNameWOExt,
              artUri: Uri.parse(element.id.toString()),
            ),
          ),
        );
      }

      widget.audioPlayer.setAudioSource(
        ConcatenatingAudioSource(children: songList),
      );
      widget.audioPlayer.play();
      _isPlaying = true;

      widget.audioPlayer.durationStream.listen((duration) {
        if (duration != null) {
          setState(() {
            _duration = duration;
          });
        }
      });
      widget.audioPlayer.positionStream.listen((position) {
        setState(() {
          _position = position;
        });
      });
      listenToEvent();
      listenToSongIndex();
    } on Exception catch (_) {
      popBack();
    }
  }

  void listenToEvent() {
    widget.audioPlayer.playerStateStream.listen((state) {
      if (state.playing) {
        setState(() {
          _isPlaying = true;
        });
      } else {
        setState(() {
          _isPlaying = false;
        });
      }
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  void listenToSongIndex() {
    widget.audioPlayer.currentIndexStream.listen(
      (event) {
        setState(
          () {
            if (event != null) {
              currentIndex = event;
            }
            context
                .read<SongModelProvider>()
                .setId(widget.songModelList[currentIndex].id);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("images/front.jpg"),
            colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop),
            fit: BoxFit.fill,
          ),
            
          ),
          height: height,
          width: double.infinity,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  popBack();
                },
                icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child: ArtWorkWidget(),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      widget.songModelList[currentIndex].displayNameWOExt,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          overflow: TextOverflow.ellipsis),
                      maxLines: 1,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Slider(
                      activeColor: Colors.orangeAccent,
                      min: 0.0,
                      value: _position.inSeconds.toDouble(),
                      max: _duration.inSeconds.toDouble() + 1.0,
                      onChanged: (value) {
                        setState(
                          () {
                            seekToSeconds(value.toInt());
                            value = value;
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:20.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _position.toString().split(".")[0],
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            _duration.toString().split(".")[0],
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (widget.audioPlayer.hasPrevious) {
                              widget.audioPlayer.seekToPrevious();
                            }
                          },
                          icon: const Icon(
                            Icons.skip_previous,
                            size: 30.0,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (_isPlaying) {
                                widget.audioPlayer.pause();
                              } else {
                                if (_position >= _duration) {
                                  seekToSeconds(0);
                                } else {
                                  widget.audioPlayer.play();
                                }
                              }
                              _isPlaying = !_isPlaying;
                            });
                          },
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_circle,
                            size: 60.0,
                          ),
                          color: Colors.orangeAccent,
                        ),
                        IconButton(
                          onPressed: () {
                            if (widget.audioPlayer.hasNext) {
                              widget.audioPlayer.seekToNext();
                            }
                          },
                          icon: const Icon(
                            Icons.skip_next,
                            size: 30.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArtWorkWidget extends StatelessWidget {
  const ArtWorkWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: context.watch<SongModelProvider>().id,
      type: ArtworkType.AUDIO,
      artworkHeight: 200,
      artworkWidth: 200,
      artworkFit: BoxFit.cover,
      nullArtworkWidget: const Icon(
        Icons.music_note,
        size: 200,
      ),
    );
  }
}

