import 'package:flutter/material.dart';

// todo:
// * Pages
// * |—> Home
// * |———> Check Stream
// *        |___ListView()
// *            |___ Sorting (default: newest first | option: oldest | option: almost time | option: late)
// *               |___ if(DateTime.now - lastCheckedDateTime == 24hrs) {showNagButton();}
// * |—> Friends
// *      |___ListView
// *           |___ Card()
// *              |  |___ onClick((friends[index]){showFriend(friend[index])})
// *              |___ Card()
// *              |      |___ CircularAvatar()
// *              |      |___ Container()
// *              |      |___ ListView([friend.name, friend.homeLocation, friend.lastCheckDateTime, friend.currentCheckLevel])
// *              |___ ListView([friend.checks])
// * |—> Messages
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
        title: Text(widget.title),
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
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            print('Yum!');
          },
          tooltip: 'Check In!',
          label: Text(
            'Check In!',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(
            Icons.check,
            color: Colors.white,
            size: 30.0,
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
