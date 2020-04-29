import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
// ! Widget imports
import 'package:check/src/widgets/user_avatar.dart';
import 'package:check/src/widgets/header.dart';
// ! Page imports
import 'package:check/src/pages/friends.dart';
import 'package:check/src/pages/messages.dart';
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
        'statusMessage':
            'This will be a space for whatever the user wants to post along with their basic status.',
        'checkTime': 'Today, 3:24pm',
        'profileImage': null,
      },
      {
        'friend': 'Nancy Cartwheel',
        'status': 'Anxious',
        'statusMessage':
            'This will be a space for whatever the user wants to post along with their basic status.',
        'checkTime': 'Today, 2:30pm',
        'profileImage':
            'https://api.adorable.io/avatars/285/nancy_cartwheel@adorable.io.png',
      },
      {
        'friend': 'Camilo Cienfuegos',
        'status': 'Sick',
        'statusMessage':
            'This will be a space for whatever the user wants to post along with their basic status.',
        'checkTime': 'Today, 2:00pm',
        'profileImage':
            'https://api.adorable.io/avatars/285/camilo_cienfuegos@adorable.io.png',
      },
      {
        'friend': 'Andre Tresmil',
        'status': 'Depressed',
        'statusMessage':
            'This will be a space for whatever the user wants to post along with their basic status.',
        'checkTime': 'Today, 1:00pm',
        'profileImage':
            'https://api.adorable.io/avatars/285/andre_tresmil@adorable.io.png',
      },
      {
        'friend': 'Bill Billers',
        'status': 'Meh',
        'statusMessage':
            'This will be a space for whatever the user wants to post along with their basic status.',
        'checkTime': 'Yesterday, 1:20pm',
        'profileImage': null,
      },
      {
        'friend': 'Wanda Maximov',
        'status': 'Content',
        'statusMessage':
            'This will be a space for whatever the user wants to post along with their basic status.',
        'checkTime': 'Yesterday, 12:00pm',
        'profileImage':
            'https://api.adorable.io/avatars/285/wanda_maximov@adorable.io.png',
      },
      {
        'friend': 'Mike Sernandez',
        'status': 'Okay',
        'statusMessage':
            'This will be a space for whatever the user wants to post along with their basic status.',
        'checkTime': 'Yesterday, 11:00am',
        'profileImage':
            'https://api.adorable.io/avatars/285/mike_sernandez@adorable.io.png',
      },
      {
        'friend': 'Bobson Dugnutt',
        'status': 'Tired',
        'statusMessage':
            'This will be a space for whatever the user wants to post along with their basic status.',
        'checkTime': 'Yesterday, 10:00am',
        'profileImage':
            'https://api.adorable.io/avatars/285/bobson_dugnutt@adorable.io.png',
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
                    child: Card(
                      elevation: 3.0,
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                child: UserAvatar(
                                  imageURL: dummyChecks[index]['profileImage'],
                                  userName: dummyChecks[index]['friend'],
                                ),
                              ),
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      dummyChecks[index]['friend'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.0,
                                        letterSpacing: 1.2,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    Text(
                                      'Feeling ${dummyChecks[index]['status']}, ${dummyChecks[index]['checkTime']}',
                                      style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 12.0,
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(
                                          FlutterIcons.message_outline_mco),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon:
                                          Icon(FlutterIcons.heart_outline_mco),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon:
                                          Icon(FlutterIcons.alert_outline_mco),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: Theme.of(context).accentColor,
                            height: 1.0,
                            thickness: 0.5,
                            indent: 10.0,
                            endIndent: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(
                                      10.0, 10.0, 10.0, 10.0),
                                  child: Text(
                                    dummyChecks[index]['statusMessage'],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          FriendsPage(),
          Messages(),
          // Search(),
          Settings(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // shape: CircularNotchedRectangle(),
        // color: Colors.white,
        currentIndex: pageIndex,
        onTap: onNavTap,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).accentColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              FlutterIcons.home_ant,
              size: 20.0,
            ),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 30.0, 0),
              child: Icon(
                FlutterIcons.team_ant,
                size: 20.0,
              ),
            ),
            title: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 30.0, 0), child: Text('')),
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
              child: Icon(
                FlutterIcons.mail_ant,
                size: 20.0,
              ),
            ),
            title: Padding(
                padding: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
                child: Text('')),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FlutterIcons.setting_ant,
              size: 20.0,
            ),
            title: Text(''),
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
          elevation: 0.0,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
