import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:newmusic/controller/controller.dart';
import 'package:newmusic/screens/playScreen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class PlaylistInfo extends StatefulWidget {
  int playlistKey;
  List<SongEntity> songs;
  String title;
  PlaylistInfo(
      {Key? key,
      required this.title,
      required this.songs,
      required this.playlistKey})
      : super(key: key);

  @override
  State<PlaylistInfo> createState() => _PlaylistInfoState();
}

class _PlaylistInfoState extends State<PlaylistInfo> {
  final OnAudioRoom _audioRoom = OnAudioRoom();
  @override
  Widget build(BuildContext context) {
    List<Audio> playlistSong = [];
    for (var song in widget.songs) {
      playlistSong.add(Audio.file(song.lastData,
          metas: Metas(
              title: song.title, artist: song.artist, id: song.id.toString())));
    }
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          centerTitle: true,
      backgroundColor: Colors.black,
          title: Text(widget.title),
        ),
        body:
          playlistSong.isEmpty
                ? const Center(
                    child: Text('Nothing Found',style: TextStyle(color: Colors.white),),
                  )
                : ListView.separated(separatorBuilder: (context, index) => SizedBox(height: 1,),
                    itemBuilder: (ctx, index) =>
                    //  Slidable(
                    //   endActionPane: ActionPane(
                    //     children: [
                    //       SlidableAction(
                    //         onPressed: (context) {
                    //           setState(() {
                    //             _audioRoom.deleteFrom(
                    //                 RoomType.PLAYLIST, widget.songs[index].id,
                    //                 playlistKey: widget.playlistKey);
                    //           });
                    //         },
                    //         backgroundColor: Color(0xFFFE4A49),
                    //         foregroundColor: Colors.white,
                    //         icon: Icons.delete,
                    //         label: 'Delete',
                    //       ),
                    //     ],
                    //     motion: ScrollMotion(),
                    //   ),
                    //   child:
                       Padding(
                        padding: const EdgeInsets.only(top: 10,left: 10,right: 10).r,
                        child: Container( decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(20)),
                          child: ListTile(
                            onTap: () {
                              play(playlistSong, index);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => PlayerScreen()));
                            },
                            title: Text(widget.songs[index].title,style: TextStyle(color: Colors.black),overflow: TextOverflow.ellipsis,),
                            subtitle: Text(widget.songs[index].artist!,style: TextStyle(color: Colors.black,overflow: TextOverflow.ellipsis)),
                            leading: QueryArtworkWidget(
                              id: widget.songs[index].id,
                              type: ArtworkType.AUDIO,

                            ),
                            trailing: PopupMenuButton(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20.0),
                                    ),
                                  ),
                                  color: Colors.grey, elevation: 30.r,
                                  icon: const Icon(Icons
                                      .more_vert_outlined), //don't specify icon if you want 3 dot menu
                                  // color: Colors.blue,
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 0,
                                      child: Text(
                                        "Delete song",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                               
                                  ],
                                  onSelected: (item) => {
                                    if(item==0){
    setState(() {
                                _audioRoom.deleteFrom(
                                    RoomType.PLAYLIST, widget.songs[index].id,
                                    playlistKey: widget.playlistKey);
                              })

                                    }
                                  },
                                ),
                          ),
                        ),
                      ),
                      //itemCount: widget.songs.length,
                    
                    itemCount: widget.songs.length,
                  ));
  }
}
