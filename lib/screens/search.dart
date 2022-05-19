import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:newmusic/controller/controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newmusic/functioins/functions.dart';
import 'package:newmusic/screens/playScreen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:on_audio_room/on_audio_room.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final assetsAudioPlayer = AssetsAudioPlayer();
  final OnAudioRoom _audioRoom = OnAudioRoom();
  String searchTerm = '';
  final searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      //  backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
        title: const Text('Search'),
      ),
      body:
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.only(
          //       topLeft: Radius.circular(18), topRight: Radius.circular(18)),
          //   color: Colors.black87,
          // ),
          // height: double.infinity,
          // width: double.infinity,
          Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 5, right: 5).r,
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Search Songs',
                fillColor: Colors.white,
                filled: true,
                focusColor: Colors.black,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0).r,
                ),
              ),
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchTerm = value;
                });
              },
            ),
          ),
          Expanded(
              child: (searchTerm.isEmpty)
                  ? FutureBuilder<List<SongModel>>(
                      future: _audioQuery.querySongs(
                        sortType: null,
                        orderType: OrderType.ASC_OR_SMALLER,
                        uriType: UriType.EXTERNAL,
                        ignoreCase: true,
                      ),
                      builder: (context, allSongs) {
                        if (allSongs.data == null) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (allSongs.data!.isEmpty) {
                          return const Text(
                            "Nothing found!",
                            style: TextStyle(color: Colors.black),
                          );
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
                            sortType:
                                null, //  Null will use the [key] has sort.
                          ),
                          builder: (context, allFavourite) {
                            if (allFavourite.data == null) {
                              return const SizedBox();
                            }
                            // if (allFavourite.data!.isEmpty) {
                            //   return const SizedBox();
                            // }
                            List<FavoritesEntity> favorites =
                                allFavourite.data!;
                            List<Audio> favSongs = [];

                            for (var fSongs in favorites) {
                              favSongs.add(Audio.file(fSongs.lastData,
                                  metas: Metas(
                                      title: fSongs.title,
                                      artist: fSongs.artist,
                                      id: fSongs.id.toString())));
                            }
                            return AnimationLimiter(
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics()),
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
                                  // int key = 0;
                                  // for (var ff in favorites) {
                                  //   if (songs[index].metas.id == ff.) {
                                  //     isFav = true;
                                  //     key = ff.key;
                                  //   }
                                  // }

                                  return AnimationConfiguration.staggeredList(
                                      position: index,
                            delay: Duration(milliseconds: 100),
                            child: SlideAnimation(
                              duration: Duration(milliseconds: 2500),
                              curve: Curves.fastLinearToSlowEaseIn,
                              horizontalOffset: 30,
                              verticalOffset: 300.0,
                              child: FlipAnimation(
                                duration: Duration(milliseconds: 3000),
                                curve: Curves.fastLinearToSlowEaseIn,
                                flipAxis: FlipAxis.y,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 10, right: 10).r,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            borderRadius:
                                                BorderRadius.circular(20).r),
                                        child: ListTile(
                                          onTap: () {
                                            play(songs, index);
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        PlayerScreen(
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
                                          // trailing: Row(
                                          //   mainAxisSize: MainAxisSize.min,
                                          //   children: [
                                          //     IconButton(
                                          //       onPressed: () async {
                                          //         // print(isFav);
                                          //         if (!isFav) {
                                          //           _audioRoom.addTo(
                                          //             RoomType
                                          //                 .FAVORITES, // Specify the room type
                                          //             songmodel[index]
                                          //                 .getMap
                                          //                 .toFavoritesEntity(),
                                          //             ignoreDuplicate:
                                          //                 false, // Avoid the same song
                                          //           );
                                          //         } else {
                                          //           _audioRoom.deleteFrom(
                                          //               RoomType.FAVORITES, key!);
                                          //         }
                                          //         setState(() {});
                                          //         // bool isAdded = await _audioRoom.checkIn(
                                          //         //   RoomType.FAVORITES,
                                          //         //   songmodel[index].id,
                                          //         // );
                                          //         // print('...................$isAdded');
                                          //       },
                                          //       icon: Icon(
                                          //         isFav
                                          //             ? Icons.favorite
                                          //             : Icons.favorite_outline,
                                          //         size: 18,
                                          //       ),
                                          //     ),
                                          //     IconButton(
                                          //       onPressed: () {
                                          //         dialogBox(
                                          //             context,
                                          //             int.parse(
                                          //                 songs[index].metas.id!),
                                          //             index,
                                          //             songmodel);
                                          //       },
                                          //       icon: Icon(
                                          //         Icons.add,
                                          //       ),
                                          //     )
                                          //   ],
                                          // ),
                                          leading: QueryArtworkWidget(
                                            //nullArtworkWidget: Icon(Icons.music_note),
                                            id: allSongs.data![index].id,
                                            type: ArtworkType.AUDIO,
                                             nullArtworkWidget: Padding(
                                        padding: const EdgeInsets.only(top:8.0).r,
                                        child: const Icon(Icons.music_note,color: Colors.blueAccent,),
                                      ),
                                          ),
                                        ),
                                      ),
                                    ),),)
                                  );
                                },
                              ),
                            );
                          },
                        );
                      })
                  : FutureBuilder<List<SongModel>>(
                      future: _audioQuery.querySongs(
                        sortType: null,
                        orderType: OrderType.ASC_OR_SMALLER,
                        uriType: UriType.EXTERNAL,
                        ignoreCase: true,
                      ),
                      builder: (context, allSongs) {
                        // if (allSongs.data == null)
                        //   return Center(
                        //       child: const CircularProgressIndicator());

                        if (allSongs.data!.isEmpty)
                          return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: const Text(
                            "Nothing found!",
                            style: TextStyle(color: Colors.green),
                          ),
                              ));

                        List<SongModel> songmodel = allSongs.data!;

                        List<SongModel> songModelList = songmodel
                            .where((song) =>
                                song.title.toLowerCase().contains(searchTerm))
                            .toList();

                        List<Audio> songs = [];

                        for (var song in songModelList) {
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
                              sortType:
                                  null, //  Null will use the [key] has sort.
                            ),
                            builder: (context, allFavourite) {
                              if (allFavourite.data == null) {
                                return const SizedBox();
                              }
                              // if (allFavourite.data!.isEmpty) {
                              //   return const SizedBox();
                              // }
                              List<FavoritesEntity> favorites =
                                  allFavourite.data!;
                              List<Audio> favSongs = [];

                              for (var fSongs in favorites) {
                                favSongs.add(Audio.file(fSongs.lastData,
                                    metas: Metas(
                                        title: fSongs.title,
                                        artist: fSongs.artist,
                                        id: fSongs.id.toString())));
                              }
                              return ListView.separated(
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 5.h,
                                ),
                                itemCount: songs.length,
                                itemBuilder: (context, index) {
                                  bool isFav = false;
                                  int? key;
                                  for (var fav in favorites) {
                                    if (songs[index].metas.title == fav.title) {
                                      isFav = true;
                                      key = fav.key;
                                    }
                                  }
                                  // bool isFav = false;
                                  // int? key;
                                  // for (var fav in favorites) {
                                  //   if (songs[index].metas.title ==
                                  //       fav.title) {
                                  //     isFav = true;
                                  //     key = fav.key;
                                  //   }
                                  // }
                                  // int key = 0;
                                  // for (var ff in favorites) {
                                  //   if (songs[index].metas.id == ff.) {
                                  //     isFav = true;
                                  //     key = ff.key;
                                  //   }
                                  // }

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10).r,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          borderRadius:
                                              BorderRadius.circular(20).r),
                                      child: ListTile(
                                        onTap: () {
                                          play(songs, index);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      PlayerScreen(
                                                        index: index,
                                                        songModel2:
                                                            songModelList,
                                                      )));
                                        },
                                        title: Text(
                                          songs[index].metas.title!,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Text(
                                          songs[index].metas.artist ??
                                              "No Artist",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        // trailing: Row(
                                        //   mainAxisSize: MainAxisSize.min,
                                        //   children: [
                                        //     IconButton(
                                        //       onPressed: () async {
                                        //         // print(isFav);
                                        //         if (!isFav) {
                                        //           _audioRoom.addTo(
                                        //             RoomType
                                        //                 .FAVORITES, // Specify the room type
                                        //             songModelList[index]
                                        //                 .getMap
                                        //                 .toFavoritesEntity(),
                                        //             ignoreDuplicate:
                                        //                 false, // Avoid the same song
                                        //           );
                                        //         } else {
                                        //           _audioRoom.deleteFrom(
                                        //               RoomType.FAVORITES,
                                        //               key!);
                                        //         }
                                        //         setState(() {});
                                        //         // bool isAdded = await _audioRoom.checkIn(
                                        //         //   RoomType.FAVORITES,
                                        //         //   songmodel[index].id,
                                        //         // );
                                        //         // print('...................$isAdded');
                                        //       },
                                        //       icon: Icon(
                                        //         isFav
                                        //             ? Icons.favorite
                                        //             : Icons.favorite_outline,
                                        //         size: 18,
                                        //       ),
                                        //     ),
                                        //     IconButton(
                                        //       onPressed: () {
                                        //         dialogBox(
                                        //             context,
                                        //             int.parse(songs[index]
                                        //                 .metas
                                        //                 .id!),
                                        //             index,
                                        //             songModelList);
                                        //       },
                                        //       icon: Icon(
                                        //         Icons.add,
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                        leading: QueryArtworkWidget(
                                          //nullArtworkWidget: Icon(Icons.music_note),
                                          id: int.parse(songs[index].metas.id!),
                                          type: ArtworkType.AUDIO,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            });
                      })),
        ],
      ),
    );
  }
}


// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:newmusic/screens/homeScreen.dart';

// import 'package:on_audio_query/on_audio_query.dart';

// class MySearch extends SearchDelegate {
//   OnAudioQuery _audioQuery=OnAudioQuery();
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//           color: Colors.grey,
//           onPressed: () {
//             if (query.isEmpty) {
//               close(context, null);
//             } else {
//               query = '';
//             }
//           },
//           icon: const Icon(
//             Icons.clear,
//           ))
//     ];
//   }
// Color textWhite=Colors.white;
// Color black=Colors.black;
//   @override
//   ThemeData appBarTheme(BuildContext context) {
//     assert(context != null);
//     final ThemeData theme = Theme.of(context);
//     return theme.copyWith(
//       textTheme: TextTheme(displayMedium: TextStyle(color: textWhite)),
//       hintColor: textWhite,
//       appBarTheme: AppBarTheme(
//         color: black,
//       ),
//       inputDecorationTheme: searchFieldDecorationTheme ??
//           const InputDecorationTheme(
//             border: InputBorder.none,
//           ),
//     );
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//         onPressed: () {
//           close(context, null);
//         },
//         icon: Icon(
//           Icons.arrow_back,
//           color: textWhite,
//         ));
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return Center(
//       child: Text(
//         query,
//         style: TextStyle(color: textWhite),
//       ),
//     );
//   }

// // search element
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final searchSongItems = query.isEmpty
//         ? songmodel
//         : songmodel
//                 .where((element) => element.title
//                     .toLowerCase()
//                     .startsWith(query.toLowerCase().toString()))
//                 .toList() +
//             songmodel
//                 .where((element) => element.artist!
//                     .toLowerCase()
//                     .startsWith(query.toLowerCase().toString()))
//                 .toList();

//     return Scaffold(
      
//       backgroundColor: black,
//       body: searchSongItems.isEmpty
//           ? const Center(
//               child: Text(
//               "No Songs Found!",
//               style: TextStyle(color: Colors.green),
//             ))
//           : 

           
//             return Padding(
//               padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15).r,
//               child: ListView.separated(
//                   physics: const BouncingScrollPhysics(),
//                   shrinkWrap: true,
//                   itemBuilder: (context, index) {
//                     return Container(
//                       decoration: BoxDecoration(
//                           color: Colors.red,
//                           borderRadius: BorderRadius.circular(15).r),
//                       child: ListTile(
//                         onTap: (() async {
//                           // await OpenPlayer(
//                           //         fullSongs: [],
//                           //         index: index,
//                           //         songId: int.parse(
//                           //                 searchSongItems[index].metas.id!)
//                           //             .toString())
//                           //     .openAssetPlayer(index: index, songs: fullSongs);
//                           // Navigator.push(
//                           //     context,
//                           //     MaterialPageRoute(
//                           //         builder: ((context) => NowPlaying(
//                           //             allSongs: fullSongs,
//                           //             index: 0,
//                           //             songId: int.parse(
//                           //                     searchSongItems[index].metas.id!)
//                           //                 .toString()))));
//                         }),
//                         leading: QueryArtworkWidget(
//                             artworkHeight: 60.h,
//                             artworkWidth: 60.w,
//                             id: (searchSongItems[index].id),
//                             type: ArtworkType.AUDIO),
//                         title: Padding(
//                           padding:
//                               EdgeInsets.only(left: 5.0, bottom: 3, top: 3).r,
//                           child: Text(
//                             searchSongItems[index].title,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(color: textWhite, fontSize: 18.sp),
//                           ),
//                         ),
//                         subtitle: Padding(
//                           padding: EdgeInsets.only(left: 7.0).r,
//                           child: Text(
//                             searchSongItems[index].artist!,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(color: Colors.blue),
//                           ),
//                         ),
//                         trailing: IconButton(
//                             onPressed: () {},
//                             icon: Icon(
//                               Icons.play_arrow,
//                               size: 25.sp,
//                               color: textWhite,
//                             )),
//                       ),
//                     );
//                     // return ListTile(
//                   },
//                   separatorBuilder: (context, index) {
//                     return SizedBox(
//                       height: 10.h,
//                     );
//                   },
//                   itemCount: searchSongItems.length),
//             );})
//     );
//   }
// }
