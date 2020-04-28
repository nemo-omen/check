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
    // TODO: break AppBar off into separate file
    final dummyChecks = [
      {
        'friend': 'Joe Winklesmith',
        'status': 'Happy',
        'checkTime': 'Today, 3:24pm',
      },
      {
        'friend': 'Nancy Cartwheel',
        'status': 'Anxious',
        'checkTime': 'Today, 2:30pm',
      },
      {
        'friend': 'Camilo Cienfuegos',
        'status': 'Sick',
        'checkTime': 'Today, 2:00pm',
      },
      {
        'friend': 'Andre Tresmil',
        'status': 'Depressed',
        'checkTime': 'Today, 1:00pm',
      },
      {
        'friend': 'Bill Billers',
        'status': 'Meh',
        'checkTime': 'Yesterday, 1:20pm',
      },
      {
        'friend': 'Wanda Maximov',
        'status': 'Content',
        'checkTime': 'Yesterday, 12:00pm',
      },
    ];
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
              FlutterIcons.team_ant,
              color: Theme.of(context).primaryColor,
            ),
            tooltip: 'Friends',
            iconSize: 20.0,
            onPressed: () {
              print('Pressed Friends');
            },
          ),
          IconButton(
            icon: Icon(
              FlutterIcons.mail_ant,
              color: Theme.of(context).primaryColor,
            ),
            tooltip: 'Messages',
            iconSize: 20.0,
            onPressed: () {
              print('Pressed Messages.');
            },
          ),
          IconButton(
            icon: Icon(
              FlutterIcons.search1_ant,
              color: Theme.of(context).primaryColor,
            ),
            tooltip: 'Search',
            iconSize: 20.0,
            onPressed: () {
              print('Pressed messages.');
            },
          ),
          IconButton(
            icon: Icon(
              FlutterIcons.menufold_ant,
              color: Theme.of(context).primaryColor,
            ),
            tooltip: 'Settings',
            iconSize: 20.0,
            onPressed: () {
              print('Pressed Menu');
            },
          ),
        ],
      ),
      body: Center(
        child: ListView.builder(
            itemCount: dummyChecks.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  print(dummyChecks[index]['friend']);
                },
                child: ListTile(
                  isThreeLine: true,
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 15.0,
                  ),
                  title: Text(dummyChecks[index]['friend']),
                  subtitle: Text(
                    'Feeling ${dummyChecks[index]['status']}, ${dummyChecks[index]['checkTime']}',
                  ),
                ),
              );
            }),
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
