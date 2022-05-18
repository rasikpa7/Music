// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:flutter/material.dart';
// import 'package:on_audio_room/on_audio_room.dart';

// class RecentScreen extends StatefulWidget {
//    RecentScreen({ Key? key }) : super(key: key);

//   @override
//   State<RecentScreen> createState() => _RecentScreenState();
// }

// class _RecentScreenState extends State<RecentScreen> {
// OnAudioRoom _onAudioRoom=OnAudioRoom();

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       appBar: AppBar(title: Text('Recent Songs'),centerTitle: true,backgroundColor: Colors.black,),

//       body: FutureBuilder<List<LastPlayedEntity>>(
//         future: _onAudioRoom.queryLastPlayed(
//         ),
//         builder:(context,recentSong){
//           if(recentSong.data==null){
//             return Center(child: CircularProgressIndicator());
//           }
//           if(recentSong.data!.isEmpty){
//             return Center(child: Text('No Songs '));
//           }
//         List<LastPlayedEntity> recent = recentSong.data!;

//                 List<Audio> recentsongsaudio = [];
//    for (var song in recent) {
//                   recentsongsaudio.add(Audio.file(song.lastData,
//                       metas: Metas(
//                           title: song.title,
//                           artist: song.artist,
//                           id: song.id.toString())));
//                 }

//           return ListView.builder(
//             itemCount: recentSong.data!.length,
//             itemBuilder: (context, index) {
            
//             return ListTile(
//               title: Text(recentSong.data![index].title,)

//             );
            
//           });

//         }
//         ),
      
//     );
//   }
// }