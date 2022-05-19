import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:newmusic/functioins/functions.dart';
import 'package:newmusic/screens/playlistInfo.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

class Playlists extends StatefulWidget {
  Playlists({Key? key}) : super(key: key);

  @override
  State<Playlists> createState() => _PlaylistsState();
}

class _PlaylistsState extends State<Playlists> {
  var playlistname;
  final OnAudioRoom _audioRoom = OnAudioRoom();
  @override
  Widget build(BuildContext context) {
    final OnAudioQuery _audioQuery = OnAudioQuery();

    //return Container();
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text('Playlists'),
          actions: [
            IconButton(
                onPressed: () {
                  createPlaylistFrom(context, () {
                    setState(() {});
                  });
                },
                icon: Icon(Icons.playlist_add))
          ],
        ),
        body: FutureBuilder<List<PlaylistEntity>>(
            future: _audioRoom.queryPlaylists(),
            builder: (context, item) {
              if (item.data == null)
                return Center(
                  child: Text(
                    'Nothing Found',
                    style: TextStyle(color: Colors.white),
                  ),
                );

              return ListView.separated(
                  itemBuilder: (ctx, index) =>
                      //  Slidable(
                      //       endActionPane: ActionPane(
                      //         children: [
                      //           SlidableAction(
                      //             onPressed: (context) {
                      //               dialog(context, item.data![index].key);
                      //             },
                      //             backgroundColor: Colors.green.shade400,
                      //             foregroundColor: Colors.white,
                      //             icon: Icons.edit,
                      //             label: 'Edit',
                      //           ),
                      //           SlidableAction(
                      //             onPressed: (context) {
                      //               setState(() {
                      //                 _audioRoom.deletePlaylist(
                      //                     item.data![index].key);
                      //               });
                      //             },
                      //             backgroundColor: Color(0xFFFE4A49),
                      //             foregroundColor: Colors.white,
                      //             icon: Icons.delete,
                      //             label: 'Delete',
                      //           ),
                      //         ],
                      //         motion: ScrollMotion(),
                      //       ),
                      ListTile(
                        trailing: PopupMenuButton(
                          shape:  RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0).r,
                            ),
                          ),
                          color: Colors.blue,
                          elevation: 50.r,
                          icon: const Icon(
                            Icons.more_vert_outlined,
                            color: Colors.white,
                          ), //don't specify icon if you want 3 dot menu
                          // color: Colors.blue,
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 0,
                              child: Text(
                                "Remove playlist",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const PopupMenuItem(
                              value: 1,
                              child: Text(
                                "Rename",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                          onSelected: (item1) => {
                            if (item1 == 0)
                              {
                                setState(() {
                                  _audioRoom
                                      .deletePlaylist(item.data![index].key);
                                })
                              },
                            if (item1 == 1)
                              {
                                dialog(
                                  context,
                                  item.data![index].key,
// playlistNameController.text
 item.data![index].playlistName
                                )
                              }
                          },
                        ),
                        onTap: () {
                          //final x = item.data[index].key;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => PlaylistInfo(
                                        title: item.data![index].playlistName,
                                        songs: item.data![index].playlistSongs,
                                        playlistKey: item.data![index].key,
                                      )));
                          //final x = item.data![index].playlistSongs;
                          // print(x);
                          //list songs in playlist
                          // final x = item.data![index].;
                          // _audioRoom.addAllTo(RoomType.PLAYLIST, )
                          //print(item.data![index].dateAdded);
                          // final x = await _audioQuery.queryAudiosFrom(
                          //     AudiosFromType.PLAYLIST,
                          //     item.data![index].playlist);
                          // print(x);
                        },
                        contentPadding: EdgeInsets.only(left: 20).r,
                        title: Text(
                          item.data![index].playlistName,
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Icon(
                          Icons.music_note,
                          color: Colors.blueAccent,
                        ),
                      ),
                  separatorBuilder: (ctx, index) => Divider(),
                  itemCount: item.data!.length);
            }));
  }

  void dialog(
    BuildContext context,
    int key,
    String str
  ) {
    final playlistNameController = TextEditingController(text: str);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx1) => AlertDialog(
              content: TextFormField(
                  controller: playlistNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0).r,
                    ),
                    //filled: true,
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    hintText:str,
                  )),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx1);
                    },
                    child: Text('Cancel')),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _audioRoom.renamePlaylist(
                            key, playlistNameController.text);
                      });
                      Navigator.pop(ctx1);
                      //createNewPlaylist(playlistNameController.text);

                      // dialogBox(context);
                    },
                    child: Text('Ok'))
              ],
            ));
  }
}

