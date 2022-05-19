import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:newmusic/controller/controller.dart';
import 'package:newmusic/screens/playScreen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:on_audio_room/on_audio_room.dart';

class Favourite extends StatefulWidget {
  Favourite({Key? key}) : super(key: key);

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  Widget build(BuildContext context) {
    final OnAudioQuery _audioQuery = OnAudioQuery();
    final OnAudioRoom _audioRoom = OnAudioRoom();

    //return Container();
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: const Text('Favourite'),
        ),
        body: FutureBuilder<List<FavoritesEntity>>(
            future: _audioRoom.queryFavorites(
              // limit: 50,
              reverse: false,
              // sortType: null,
            ),
            builder: (context, item) {
              if (item.data == null || item.data!.isEmpty)
                return const Center(
                  child: Text(
                    'Nothing Found',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              List<FavoritesEntity> favorites = item.data!;
              List<Audio> favSongs = [];
              for (var songs in favorites) {
                favSongs.add(Audio.file(songs.lastData,
                    metas: Metas(
                        title: songs.title,
                        artist: songs.artist,
                        id: songs.id.toString())));
              }
              return AnimationLimiter(
                child: ListView.separated(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    itemBuilder: (ctx, index) =>
                        AnimationConfiguration.staggeredList(
                            position: index,
                            delay: Duration(milliseconds: 100),
                            child: SlideAnimation(
                              duration: Duration(milliseconds: 2500),
                              curve: Curves.fastLinearToSlowEaseIn,
                              horizontalOffset: 30,
                              verticalOffset: 300.0,
                              child: FlipAnimation(
                                duration: const Duration(milliseconds: 3000),
                                curve: Curves.fastLinearToSlowEaseIn,
                                flipAxis: FlipAxis.y,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 8.0.h, left: 10.w, right: 10.w),
                                  child: Container(
                                    height: 70,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        borderRadius:
                                            BorderRadius.circular(20).r),
                                    child: Center(
                                      child: ListTile(
                                          onTap: () {
                                            play(favSongs, index);
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        PlayerScreen()));
                                          },
                                          contentPadding: const EdgeInsets.symmetric(
                                                  horizontal: 20)
                                              .r,
                                          title: Text(
                                            favorites[index].title,
                                          ),
                                          leading: QueryArtworkWidget(
                                            id: favorites[index].id,
                                            type: ArtworkType.AUDIO,
                                            nullArtworkWidget: Padding(
                                              padding: const EdgeInsets.only(
                                                      top: 5.0)
                                                  .r,
                                              child:
                                                  const Icon(Icons.music_note,color: Colors.blueAccent,),
                                            ),
                                          ),
                                          trailing: PopupMenuButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                const Radius.circular(20.0).r,
                                              ),
                                            ),
                                            color: Colors.black,
                                            elevation: 30.r,
                                            icon: const Icon(Icons
                                                .more_vert_outlined), //don't specify icon if you want 3 dot menu
                                            // color: Colors.blue,
                                            itemBuilder: (context) => [
                                              const PopupMenuItem(
                                                value: 0,
                                                child: Text(
                                                  "Remove from Favorites",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                            onSelected: (item) => {
                                              if (item == 0)
                                                {
                                                  setState(() {
                                                    _audioRoom.deleteFrom(
                                                        RoomType.FAVORITES,
                                                        favorites[index].key);
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Deleted from favorites",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity
                                                            .SNACKBAR,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            Colors.red,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                  })
                                                }
                                            },
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                    separatorBuilder: (ctx, index) => SizedBox(
                          height: 1,
                        ),
                    itemCount: item.data!.length),
              );
            }));
  }
}
