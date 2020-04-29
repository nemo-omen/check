import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
// ! Widget imports
import 'package:check/src/widgets/user_avatar.dart';
import 'package:check/src/widgets/header.dart';
// ! Page imports
import 'package:check/src/pages/friends.dart';
import 'package:check/src/pages/messages.dart';
import 'package:check/src/pages/search.dart';
import 'package:check/src/pages/settings.dart';

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
  PageController pageController; //declare pageController variable
  int pageIndex = 0;
// ! Functions and methods go beneath this line for readibility's sake
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

// ! Navigation icon tap function here
  onNavTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

// ! Build method for main widget beneath this line
  @override
  Widget build(BuildContext context) {
    // TODO: break AppBar off into separate file
    final dummyChecks = [
      {
        'friend': 'Joe Winklesmith',
        'status': 'Happy',
        'checkTime': 'Today, 3:24pm',
        'profileImage': null,
      },
      {
        'friend': 'Nancy Cartwheel',
        'status': 'Anxious',
        'checkTime': 'Today, 2:30pm',
        'profileImage':
            'https://api.adorable.io/avatars/285/nancy_cartwheel@adorable.io.png',
      },
      {
        'friend': 'Camilo Cienfuegos',
        'status': 'Sick',
        'checkTime': 'Today, 2:00pm',
        'profileImage':
            'https://api.adorable.io/avatars/285/camilo_cienfuegos@adorable.io.png',
      },
      {
        'friend': 'Andre Tresmil',
        'status': 'Depressed',
        'checkTime': 'Today, 1:00pm',
        'profileImage':
            'https://api.adorable.io/avatars/285/andre_tresmil@adorable.io.png',
      },
      {
        'friend': 'Bill Billers',
        'status': 'Meh',
        'checkTime': 'Yesterday, 1:20pm',
        'profileImage': null,
      },
      {
        'friend': 'Wanda Maximov',
        'status': 'Content',
        'checkTime': 'Yesterday, 12:00pm',
        'profileImage':
            'https://api.adorable.io/avatars/285/wanda_maximov@adorable.io.png',
      },
    ];

    return Scaffold(
      appBar: header(context,
          isAppTitle: true, titleText: 'Check', removeBackButton: false),
      body: PageView(
        children: <Widget>[
          Center(
            child: ListView.builder(
                itemCount: dummyChecks.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      print(dummyChecks[index]['friend']);
                    },
                    child: ListTile(
                      isThreeLine: true,
                      leading: UserAvatar(
                        imageURL: dummyChecks[index]['profileImage'],
                        userName: dummyChecks[index]['friend'],
                      ),
                      title: Text(dummyChecks[index]['friend']),
                      subtitle: Text(
                        'Feeling ${dummyChecks[index]['status']}, ${dummyChecks[index]['checkTime']}',
                      ),
                    ),
                  );
                }),
          ),
          FriendsPage(),
          Messages(),
          Search(),
          Settings(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        // shape: CircularNotchedRectangle(),
        // color: Colors.white,
        currentIndex: pageIndex,
        onTap: onNavTap,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).accentColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              FlutterIcons.team_ant,
              size: 20.0,
            ),
            title: Text('Friends'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FlutterIcons.mail_ant,
              size: 20.0,
            ),
            title: Text('Messages'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FlutterIcons.search1_ant,
              size: 20.0,
            ),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FlutterIcons.setting_ant,
              size: 20.0,
            ),
            title: Text('Profile'),
          ),
        ],
        elevation: 8.0,

        // child: Container(height: 40.0),
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
            FlutterIcons.check_ant,
            color: Theme.of(context).primaryColor,
            // size: 30.0,
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
