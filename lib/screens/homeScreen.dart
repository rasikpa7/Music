import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newmusic/controller/controller.dart';
import 'package:newmusic/functioins/functions.dart';
import 'package:newmusic/screens/drawerNav.dart';
import 'package:newmusic/screens/mostPlayed.dart';
import 'package:newmusic/screens/playScreen.dart';
import 'package:newmusic/screens/recentScreen.dart';
import 'package:newmusic/screens/search.dart';
import 'package:newmusic/screens/settings.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

List<SongModel> songmodel = [];

class _HomeScreenState extends State<HomeScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final assetsAudioPlayer = AssetsAudioPlayer();
  final OnAudioRoom _audioRoom = OnAudioRoom();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideNavBar(),
      backgroundColor: Colors.black87,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                print(MediaQuery.of(context).size);
                // Navigator.push(
                //     context, MaterialPageRoute(builder: (ctx) => Settings()));
                await Share.share(
                    'check out app on playstore https://Rhythm.com',
                    subject: 'Look what I made!');
              },
              icon: Icon(Icons.share)),
          // IconButton(onPressed: (){
          //         Navigator.push(
          //       context, MaterialPageRoute(builder: (ctx) => RecentScreen()));
          // }, icon: Icon(Icons.abc)),
          //     IconButton(onPressed: (){
          //         Navigator.push(
          //       context, MaterialPageRoute(builder: (ctx) => MostScreen()));
          // }, icon: Icon(Icons.baby_changing_station))
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
        title: const Text('RHYTHM'),
      ),
      body: FutureBuilder<List<SongModel>>(
          future: _audioQuery.querySongs(
            sortType: null,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true,
          ),
          builder: (context, allSongs) {
            if (allSongs.data == null)
              return Center(child: const CircularProgressIndicator());

            if (allSongs.data!.isEmpty) {
              return Center(
                  child: const Text(
                "Searching for songs...",
                style: TextStyle(color: Colors.white),
              ));
            }

            List<SongModel> songmodel = allSongs.data!;

            List<Audio> songs = [];

            for (var song in songmodel) {
              songs.add(Audio.file(song.uri.toString(),
                  metas: Metas(
                      title: song.title,
                      artist: song.artist,
                      id: song.id.toString())));
            }

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

                return AnimationLimiter(
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    separatorBuilder: ((context, index) => SizedBox(
                          height: 1.h,
                        )),
                    itemCount: allSongs.data!.length,
                    itemBuilder: (context, index) {
                      bool isFav = false;
                      int? key;
                      for (var fav in favorites) {
                        if (songs[index].metas.title == fav.title) {
                          isFav = true;
                          key = fav.key;
                        }
                      }

                      return AnimationConfiguration.staggeredList(
                          position: index,
                          delay: Duration(milliseconds: 10),
                          child: SlideAnimation(
                            duration: Duration(milliseconds: 1500),
                            curve: Curves.fastLinearToSlowEaseIn,
                            verticalOffset: -250,
                            child: ScaleAnimation(
                              duration: Duration(milliseconds: 1500),
                              curve: Curves.fastLinearToSlowEaseIn,
                              // position: index,
                              // delay: Duration(milliseconds: 100),
                              // child: SlideAnimation(
                              //   duration: Duration(milliseconds: 2500),
                              //   curve: Curves.fastLinearToSlowEaseIn,
                              //   horizontalOffset: 30,
                              //   verticalOffset: 300.0,
                              //   child: FlipAnimation(
                              //     duration: Duration(milliseconds: 3000),
                              //     curve: Curves.fastLinearToSlowEaseIn,
                              //     flipAxis: FlipAxis.y,
                              child: Padding(
                                padding: EdgeInsets.only(
                                        top: 10.h, left: 10.w, right: 10.w)
                                    .r,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      borderRadius:
                                          BorderRadius.circular(20).r),
                                  child: ListTile(
                                    onTap: () {
                                      play(songs, index);
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (ctx) => PlayerScreen(
                                                    index: index,
                                                  )));
                                    },
                                    title: Text(
                                      allSongs.data![index].title,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      allSongs.data![index].artist ??
                                          "No Artist",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            // print(isFav);
                                            if (!isFav) {
                                              _audioRoom.addTo(
                                                RoomType
                                                    .FAVORITES, // Specify the room type
                                                songmodel[index]
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
                                            // bool isAdded = await _audioRoom.checkIn(
                                            //   RoomType.FAVORITES,
                                            //   songmodel[index].id,
                                            // );
                                            // print('...................$isAdded');
                                          },
                                          icon: Icon(
                                            isFav
                                                ? Icons.favorite
                                                : Icons.favorite_outline,
                                            size: 18.sp,
                                            color: Colors.red,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            dialogBox(
                                                context,
                                                int.parse(
                                                    songs[index].metas.id!),
                                                index,
                                                songmodel);
                                          },
                                          icon: Icon(
                                            Icons.add,
                                            color: Colors.blueAccent,
                                          ),
                                        )
                                      ],
                                    ),
                                    leading: QueryArtworkWidget(
                                      //nullArtworkWidget: Icon(Icons.music_note),
                                      id: allSongs.data![index].id,
                                      type: ArtworkType.AUDIO,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ));
                    },
                  ),
                );
              },
            );
          }),
    );
  }
}
