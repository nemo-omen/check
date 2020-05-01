// library imports
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
// Widget imports
import 'package:check/src/widgets/user_avatar.dart';
import 'package:check/src/widgets/header.dart';
// Page imports
import 'package:check/src/pages/friends.dart';
import 'package:check/src/pages/messages.dart';
import 'package:check/src/pages/settings.dart';
// model imports
import 'package:check/src/models/dummychecks.dart';

class IsAuthPage extends StatefulWidget {
  @override
  _IsAuthPageState createState() => _IsAuthPageState();
}

class _IsAuthPageState extends State<IsAuthPage> {
  // vars
  PageController pageController; //declare pageController variable
  int pageIndex = 0;
  final dummyChecks = checks;

  // Functions/methods
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

// don't forget to dispose of any controllers to prevent leaks
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

// Control navigation with pageIndex
  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onNavTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

/* finally, the widget build method
 it gets a little verbose after this -- widgets (methods) in widgets */

/* TODO: Break some of these widgets off into
 seperate components so things are easier to change */

  @override
  Widget build(BuildContext context) {
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
                            mainAxisAlignment: MainAxisAlignment.start,
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
                            ],
                          ),
                          Divider(
                            height: 1.0,
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
                          Divider(
                            indent: 10.0,
                            endIndent: 10.0,
                            height: 1.0,
                          ),
                          Container(
                            padding: EdgeInsets.all(0.0),
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  iconSize: 15.0,
                                  padding: EdgeInsets.all(0.0),
                                  icon: Icon(
                                    FlutterIcons.message_outline_mco,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  iconSize: 15.0,
                                  padding: EdgeInsets.all(0.0),
                                  icon: Icon(
                                    FlutterIcons.heart_outline_mco,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  padding: EdgeInsets.all(0.0),
                                  iconSize: 15.0,
                                  icon: Icon(
                                    FlutterIcons.alert_outline_mco,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          // include each page here for PageView
          FriendsPage(),
          Messages(),
          // Search(),
          Settings(),
        ],
        // set controller
        controller: pageController,
        // call page change method to set pageIndex
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: pageIndex,
        onTap: onNavTap,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).accentColor,
        elevation: 8.0,
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
