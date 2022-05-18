// // import 'package:assets_audio_player/assets_audio_player.dart';
// // import 'package:flutter/material.dart';
// // import 'package:on_audio_room/on_audio_room.dart';

// // class MostScreen extends StatefulWidget {
// //    MostScreen({ Key? key }) : super(key: key);

// //   @override
// //   State<MostScreen> createState() => _MostScreenState();
// // }

// // class _MostScreenState extends State<MostScreen> {
// // OnAudioRoom _onAudioRoom=OnAudioRoom();

// //   @override
// //   Widget build(BuildContext context) {

// //     return Scaffold(
// //       appBar: AppBar(title: Text('mostplayed Songs'),centerTitle: true,backgroundColor: Colors.black,),

// //       body: FutureBuilder<List<MostPlayedEntity>>(
// //         future: _onAudioRoom.queryMostPlayed(
// //         ),
// //         builder:(context,mostSong){
// //           if(mostSong.data==null){
// //             return Center(child: CircularProgressIndicator());
// //           }
// //           if(mostSong.data!.isEmpty){
// //             return Center(child: Text('No Songs '));
// //           }
// //         List<MostPlayedEntity> most = mostSong.data!;

// //                 List<Audio> mostsongsaudio = [];
// //    for (var song in most) {
// //                   mostsongsaudio.add(Audio.file(song.lastData,
// //                       metas: Metas(
// //                           title: song.title,
// //                           artist: song.artist,
// //                           id: song.id.toString())));
// //                 }

// //           return ListView.builder(
// //             itemCount: mostSong.data!.length,
// //             itemBuilder: (context, index) {
            
// //             return ListTile(
// //               title: Text(mostSong.data![index].title,)

// //             );
            
// //           });

// //         }
// //         ),
      
// //     );
// //   }
// // }
// // import this Package in pubspec.yaml file
// // dependencies:
// // 
// //   flutter_staggered_animations: 



// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// class MyCustomWidget extends StatefulWidget {
//   @override
//   _MyCustomWidgetState createState() => _MyCustomWidgetState();
// }

// class _MyCustomWidgetState extends State<MyCustomWidget> {
//   @override
//   Widget build(BuildContext c) {
//     return Scaffold(
//       body: Center(
//         child: ElevatedButton(
//           child: const Text('VIEW ANIMATING LISTVIEW'),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => SlideAnimation1()),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class SlideAnimation1 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     double _w = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//           title: Text("Go Back"),
//           centerTitle: true,
//           brightness: Brightness.dark),
//       body: AnimationLimiter(
//         child: ListView.builder(
//           padding: EdgeInsets.all(_w / 30),
//           physics:
//               BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
//           itemCount: 20,
//           itemBuilder: (BuildContext c, int i) {
//             return AnimationConfiguration.staggeredList(
//               position: i,
//               delay: Duration(milliseconds: 100),
//               child: SlideAnimation(
//                 duration: Duration(milliseconds: 2500),
//                 curve: Curves.fastLinearToSlowEaseIn,
//                 horizontalOffset: 30,
//                 verticalOffset: 300.0,
//                 child: FlipAnimation(
//                   duration: Duration(milliseconds: 3000),
//                   curve: Curves.fastLinearToSlowEaseIn,
//                   flipAxis: FlipAxis.y,
//                   child: Container(
//                     margin: EdgeInsets.only(bottom: _w / 20),
//                     height: _w / 4,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(20),
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 40,
//                           spreadRadius: 10,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }