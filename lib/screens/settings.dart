import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

 bool notification = true;
class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
 
  @override
  Widget build(BuildContext context) {
    bool notifications = true;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(vertical: 20, horizontal: 30).r,
        child: Column(
          children: [
            ListTile(
              onTap: () {},
              leading: Icon(Icons.account_circle_outlined),
              title: Text('About'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.notifications_active),
              title: Text('Notifications'),
              trailing: Switch.adaptive(
                  value: notification,
                  onChanged: (value) {
                    setState(() {
                      notification = value;
                    });
                     print(notification);
                  }),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.report_rounded),
              title: Text('Privacy Policy'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.flag),
              title: Text('Tearms and conditions'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.verified),
              title: Text('Version'),
              trailing: Text('1.01.01'),
            ),
          ],
        ),
      ),
    );
  }
}
