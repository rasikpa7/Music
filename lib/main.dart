import 'package:assets_audio_player/src/builders/player_builders_ext.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newmusic/controller/controller.dart';
import 'package:newmusic/screens/favourite.dart';
import 'package:newmusic/screens/playScreen.dart';
import 'package:newmusic/screens/playlists.dart';
import 'package:newmusic/screens/search.dart';
import 'package:newmusic/screens/splashScreen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/homeScreen.dart';

void main() async {
  //await OnAudioRoom().initRoom(RoomType.FAVORITES);
  await OnAudioRoom().initRoom();
  runApp(const MyApp());
}

void permission() {
  Permission.storage.request();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    permission();

    return ScreenUtilInit(
      designSize: const Size(392.7, 781.1),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: SecondPage(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 1;
  final screens = [
    Favourite(),
    const HomeScreen(),
   const SearchPage(),
    Playlists(),
  ];
  Color blueColor = Colors.blue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: screens[currentIndex],
        bottomNavigationBar: CurvedNavigationBar(
          buttonBackgroundColor: Colors.blue,
          height: 50,
          index: currentIndex,
          color: Colors.grey.shade200,
          //animationDuration: Duration(milliseconds: 200),
          backgroundColor: Colors.grey.shade300,
          items: const <Widget>[
            Icon(Icons.favorite, size: 30),
            Icon(Icons.home, size: 30),
            Icon(
              Icons.search,
              size: 30,
            ),
            Icon(Icons.list, size: 30),
          ],
          onTap: (index) {
            setState(() {
              currentIndex = index;
              //print(currentIndex);
            });
          },
        ),
        bottomSheet:
            assetsAudioPlayer.builderCurrent(builder: (context, playing) {
          // if (infos == null) {
          //   return SizedBox();
          // }

          final metas = playing.playlist.current.metas;
          return (playing == null)
              ? const SizedBox()
              : ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => PlayerScreen()));
                  },
                  leading: QueryArtworkWidget(
                    artworkBorder: BorderRadius.circular(12),
                    artworkFit: BoxFit.cover,
                    id: int.parse(playing.playlist.current.metas.id!),
                    type: ArtworkType.AUDIO,
                  ),
                  title: SizedBox(
                    width: 10,
                    child: Text(
                      metas.title!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  subtitle: Text(
                    metas.artist!,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            assetsAudioPlayer.previous();
                          },
                          icon: playing.index == 0
                              ? const Icon(
                                  Icons.skip_previous_sharp,
                                  color: Colors.white,
                                )
                              : const Icon(
                                  Icons.skip_previous,
                                  color: Colors.black,
                                )),
                      IconButton(onPressed: () {
                        assetsAudioPlayer.playOrPause();
                      }, icon: assetsAudioPlayer.builderIsPlaying(
                          builder: (ctx, isPlaying) {
                        return isPlaying
                            ? Icon(
                                Icons.pause,
                                color: blueColor,
                              )
                            : Icon(
                                Icons.play_arrow,
                                color: blueColor,
                              );
                      })),
                      IconButton(
                          onPressed: () {
                            assetsAudioPlayer.next();
                          },
                          icon: const Icon(
                            Icons.skip_next,
                            color: Colors.black,
                          )),
                    ],
                  ),
                );
        }));
  }
}
