import 'package:flutter/material.dart';
import 'package:newmusic/screens/favourite.dart';
import 'package:newmusic/screens/homeScreen.dart';
import 'package:newmusic/screens/playlists.dart';
import 'package:newmusic/screens/search.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SideNavBar extends StatefulWidget {
  const SideNavBar({Key? key}) : super(key: key);

  @override
  State<SideNavBar> createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: themeColor,
      child: SafeArea(child: drawer(context)),
    );
  }
}

Future<void> showBottonSheet(BuildContext context) async {
  bool swtchstate = true;
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25).r)),
      context: context,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(color: Colors.white),
          width: double.infinity.w,
          height: 250.h,
//color: themeColor,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    color: Colors.white,
                  )
                ],
              ),

              // Notifiaction
              ListTile(
                leading: Icon(Icons.notifications_active),
                title: Text('Notification',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                        color: Colors.black)),
                trailing: Switch(
                    value: swtchstate,
                    onChanged: (tr) {
                      swtchstate = tr;
                    }),
              ),
              const ListTile(
                leading: Icon(Icons.report_rounded),
                title: Text('Privacy And Policy',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.black)),
              ),
              ListTile(
                onTap: () => showAboutDialog(context: context,
                  applicationName: 'Rhythm',
                  applicationIcon: Icon(Icons.music_note),
                  applicationVersion: '1.01.01',
                
                ),
                  leading: Icon(Icons.account_circle),
                  title: Text('About',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                          color: Colors.black)),
                ),
              
            ],
          ),
        );
      });
}

drawer(BuildContext context) {
  return Column(
    children: [
      DrawerItems(
          icon: Icons.search,
          text: 'Search',
          tap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SearchPage()
                ));
          }),
      DrawerItems(
          icon: Icons.favorite,
          text: 'Favorite',
          tap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Favourite()));
          }),
      DrawerItems(
          icon: Icons.playlist_add,
          text: 'Playlist',
          tap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Playlists()));
          }),
      DrawerItems(
          icon: Icons.settings,
          text: 'Settings',
          tap: () {
            showBottonSheet(context);
          }),
    ],
  );
}

var themeColor = Color.fromARGB(255, 45, 43, 43);
var textcolor = Colors.black;

class DrawerItems extends StatelessWidget {
  final text;
  final icon;
  final tap;
  const DrawerItems(
      {Key? key, required this.icon, required this.text, required this.tap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0.w),
      child: ListTile(
        onTap: tap,
        leading: Icon(
          icon,
          color: Colors.white,
        ),
        title: Text(
          text,
          style: TextStyle(
              color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
