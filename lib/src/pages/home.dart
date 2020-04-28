import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:flutter_icons/flutter_icons.dart';

// TODO: switch to feather icons or Ant icons -- Simple Outline Icons
// ! https://github.com/flutter-studio/flutter-icons

// todo:
// * Pages
// * |—> Home
// * |———> Check Stream
// * |       |___ListView()
// * |           |___ Sorting (default: newest first | option: oldest | option: almost time | option: late)
// * |              |___ if(DateTime.now - lastCheckedDateTime == 24hrs) {showNagButton();}
// * |—> Friends
// * |     |___ListView
// * |          |___ Card()
// * |             |  |___ onClick((friends[index]){showFriend(friend[index])})
// * |             |___ Card()
// * |             |      |___ CircularAvatar()
// * |             |      |___ Container()
// * |             |      |___ ListView([friend.name, friend.homeLocation, friend.lastCheckDateTime, friend.currentCheckLevel])
// * |             |___ ListView([friend.checks])
// * |
// * |—> Messages
// * |
// * |
// * |—> Notifications
// * |
// * |
// * |—> Search
// * |
// * |—> Profile
class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// ! Variables here

// ! Functions and methods go beneath this line for readibility's sake

// ! Build method for main widget beneath this line
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.title,
          style: TextStyle(
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w300,
            color: Theme.of(context).primaryColor,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              FlutterIcons.people_sli,
              color: Theme.of(context).primaryColor,
            ),
            tooltip: 'Friends',
            onPressed: () {
              print('Pressed Friends');
            },
          ),
          IconButton(
            icon: Icon(
              FlutterIcons.bulb_sli,
              color: Theme.of(context).primaryColor,
            ),
            tooltip: 'Notifications',
            onPressed: () {
              print('Pressed Notifications.');
            },
          ),
          IconButton(
            icon: Icon(
              FlutterIcons.envelope_sli,
              color: Theme.of(context).primaryColor,
            ),
            tooltip: 'Messages',
            onPressed: () {
              print('Pressed messages.');
            },
          ),
          IconButton(
            icon: Icon(
              FlutterIcons.magnifier_sli,
              color: Theme.of(context).primaryColor,
            ),
            tooltip: 'Search',
            onPressed: () {
              print('Pressed search');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Very empty here...',
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        // shape: CircularNotchedRectangle(),
        color: Colors.white,
        elevation: 8.0,
        child: Container(height: 40.0),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('Yum!');
          },
          backgroundColor: Colors.white,
          tooltip: 'Check In!',
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            side: BorderSide(color: Colors.blue[100], width: 1.0),
          ),
          mini: true,
          child: Icon(
            Icons.check,
            color: Theme.of(context).primaryColor,
            // size: 30.0,
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
