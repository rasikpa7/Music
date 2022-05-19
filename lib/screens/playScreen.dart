import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marquee/marquee.dart';
import 'package:newmusic/controller/controller.dart';
import 'package:newmusic/functioins/functions.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';



class PlayerScreen extends StatefulWidget {
  int? index = 0;
  List<SongModel>? songModel2;

  PlayerScreen({Key? key, this.index, this.songModel2}) : super(key: key);

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final OnAudioRoom _audioRoom = OnAudioRoom();

    Color blueColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    List<SongModel> songmodel = [];
    if (widget.songModel2 == null) {
      _audioQuery.querySongs().then((value) {
        songmodel = value;
      });
    } else {
      songmodel = widget.songModel2!;
    }
    return Scaffold(
         resizeToAvoidBottomInset : false,
        appBar: AppBar(
        backgroundColor: Colors.black,title: const Text('Now playing'),centerTitle: true,
        ),
        backgroundColor: Colors.black,
        body: SafeArea(child: assetsAudioPlayer.builderCurrent(
            builder: (context, Playing? playing) {
          return FutureBuilder<List<FavoritesEntity>>(
              future: _audioRoom.queryFavorites(
                limit: 50,
                reverse: false,
                sortType: null, //  Null will use the [key] has sort.
              ),
              builder: (context, allFavourite) {
                if (allFavourite.data == null) {
                  return const SizedBox();
                }
                // if (allFavourite.data!.isEmpty) {
                //   return const SizedBox();
                // }
                List<FavoritesEntity> favorites = allFavourite.data!;
                List<Audio> favSongs = [];

                for (var fSongs in favorites) {
                  favSongs.add(Audio.file(fSongs.lastData,
                      metas: Metas(
                          title: fSongs.title,
                          artist: fSongs.artist,
                          id: fSongs.id.toString())));
                }
                bool isFav = false;
                int? key;
                for (var fav in favorites) {
                  if (playing!.playlist.current.metas.title == fav.title) {
                    isFav = true;
                    key = fav.key;
                  }
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10).r,
                  child: Column(
                  
                    children: [
                      SizedBox(height: 30,),
                      SizedBox(
                        height: 50.h,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20).r,
                          child: Marquee(
                            text:
                              '${playing!.playlist.current.metas.title}',
                             // textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                        ),
                        
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      SizedBox(
                        height: 320.h,
                        width: 320.w,
                        child: QueryArtworkWidget(
                          artworkBorder: BorderRadius.circular(12),
                          artworkFit: BoxFit.cover,
                          nullArtworkWidget:  Icon(
                            Icons.music_note,color: Colors.blue,
                            size: 200.sp,
                          ),
                          id: int.parse(playing.playlist.current.metas.id!),
                          type: ArtworkType.AUDIO,
                        ),
                      ),
                       SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        '${playing.playlist.current.metas.artist}',
                        style:
                            TextStyle(fontSize: 16.sp, color: Colors.white),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      assetsAudioPlayer.builderRealtimePlayingInfos(
                          builder: (context, RealtimePlayingInfos? infos) {
                        if (infos == null) {
                          return const SizedBox();
                        }
                        //print('infos: $infos');
                        return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40).r,
                            child: ProgressBar(
                              timeLabelTextStyle:
                                  TextStyle(color: Colors.white),
                              timeLabelType: TimeLabelType.remainingTime,
                              baseBarColor: Colors.white,
                              progressBarColor: Colors.blue,
                              thumbColor: Colors.blue,
                              barHeight: 4,
                              thumbRadius: 8,
                              progress: infos.currentPosition,
                              total: infos.duration,
                              onSeek: (duration) {
                                assetsAudioPlayer.seek(duration);
                              },
                            ));
                      }),
                      SizedBox(
                        height: 40.h,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                dialogBox(
                                    context,
                                    int.parse(
                                        playing.playlist.current.metas.id!),
                                    playing.playlist.currentIndex,
                                    songmodel);
                              },
                              icon: Icon(Icons.playlist_add,size: 30.sp,color: Colors.white)),
                          IconButton(
                              onPressed: () {
                                assetsAudioPlayer.previous();
                              },
                              icon: Icon(Icons.skip_previous,size: 30.sp,color: Colors.white)),
                          assetsAudioPlayer.builderIsPlaying(
                              builder: (context, isPlaying) {
                            return IconButton(
                                onPressed: () {
                                  assetsAudioPlayer.playOrPause();
                                },
                                icon: isPlaying
                                    ? Icon(Icons.pause,color: blueColor,size: 30.sp)
                                    : Icon(Icons.play_arrow, color: blueColor,size: 30.sp),color: Colors.white);
                          }),
                          IconButton(
                              onPressed: () {
                                assetsAudioPlayer.next();
                              },
                              icon: Icon(Icons.skip_next,size: 30.sp,color: Colors.white)),
                          IconButton(
                            onPressed: () async {
                              // _audioRoom.addTo(
                              //   RoomType.FAVORITES,
                              //   songmodel[playing.index]
                              //       .getMap
                              //       .toFavoritesEntity(),
                              //   ignoreDuplicate: false, // Avoid the same song
                              // );
                              // bool isAdded = await _audioRoom.checkIn(
                              //   RoomType.FAVORITES,
                              //   songmodel[playing.index].id,
                              // );
                              // print('$isAdded');
                              if (!isFav) {
                                _audioRoom.addTo(
                                  RoomType.FAVORITES,
                                  songmodel[playing.index]
                                      .getMap
                                      .toFavoritesEntity(),
                                  ignoreDuplicate:
                                      false, // Avoid the same song
                                );
                                        Fluttertoast.showToast(
                                                  msg: "Added to favorites",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity:
                                                      ToastGravity.SNACKBAR,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor:
                                                      Colors.blueAccent,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                              } else {
                                _audioRoom.deleteFrom(
                                    RoomType.FAVORITES, key!);
                                    
                                              Fluttertoast.showToast(
                                                  msg: "removed from favorites",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity:
                                                      ToastGravity.SNACKBAR,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                    
                              }
                              setState(() {});
                              
                            },
                            icon:Icon(   isFav
                                                ? Icons.favorite
                                                : Icons.favorite_outline,
                                            size: 30.sp,
                                            color: Colors.red,),
                                            
                                          
                            ),
                            
                          
                        ],
                      )
                    ],
                  ),
                );
              });
        })));
  }
}
