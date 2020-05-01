import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
// ! Widget imports
import 'package:check/src/ui/widgets/user_avatar.dart';
import 'package:check/src/ui/widgets/header.dart';
import 'package:check/src/ui/widgets/status_badge.dart';
// ! Page imports
import 'package:check/src/ui/views/friends.dart';
import 'package:check/src/ui/views/messages.dart';
import 'package:check/src/ui/views/settings.dart';
// ! Model imports
import 'package:check/src/models/dummychecks.dart';
import 'package:google_sign_in/google_sign_in.dart';
// ! View imports
import 'check_view.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // vars
  bool isAuth = false;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  PageController pageController; //declare pageController variable
  int pageIndex = 0;
  // TODO: build checks
  final checks = dummyChecks;

  // Functions/methods
  @override
  void initState() {
    super.initState();
    pageController = PageController();

    // Detect whether login() function resulted in a signed in user
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      handleSignIn(account);
    }, onError: (err) {
      print('Error signing in: $err');
    });
    // Reauthenticate user on app open
    googleSignIn
        .signInSilently(
      suppressErrors: false,
    )
        .then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print('Error signing in: $err');
    });
  }

  login() {
    googleSignIn.signIn();
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      print(account);
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
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

// Navigate to one of the listed pages on BottomNavBarItem tap
// BottomNavBar can be found in IsAuthPage() Scaffold
  onNavTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
// UnAuthPage() is in its own file
// kept IsAuthPage() here because I currently
// have so much behavior wrapped into this widget
// I want to keep it in the main HomePage for now

// TODO: Implement something closer to MVVM architecture to handle state and behavior

// Build UnAuthPage: return a Scaffold widget
// if user is not authenticated

  Scaffold UnAuthPage() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Check',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans',
                fontSize: 72.0,
                fontWeight: FontWeight.w200,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: RaisedButton.icon(
                onPressed: login,
                label: Text(
                  'Google Log In',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                icon: Icon(
                  FlutterIcons.google_ant,
                  color: Colors.white,
                ),
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

// Build IsAuthPage: return a Scaffold widget
// if GoogleSignIn returns authentication
  Scaffold IsAuthPage() {
    return Scaffold(
      // Use header widget - found in ui/widgets/header/dart
      appBar: header(context,
          isAppTitle: true, titleText: 'Check', removeBackButton: true),
      body: PageView(
        children: <Widget>[
          Center(
            // build a ListView from all checks posted by friends
            child: ListView.builder(
                itemCount: checks.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    // TODO: onTap: () => Navigator.push(context){CheckView(checks[index])}
                    // ie. navigate to view that renders passed Check
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckView(
                            friend: checks[index]['friend'],
                            status: checks[index]['status'],
                            statusMessage: checks[index]['statusMessage'],
                            checkTime: checks[index]['checkTime'],
                            profileImage: checks[index]['profileImage'],
                          ),
                        ),
                      );
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
                                  imageURL: checks[index]['profileImage'],
                                  userName: checks[index]['friend'],
                                  radius: 30.0,
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
                                      checks[index]['friend'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.0,
                                        letterSpacing: 1.2,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'Feeling ',
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontSize: 12.0,
                                            height: 1.5,
                                          ),
                                        ),
                                        StatusBadge(
                                            status: checks[index]['status']),
                                        Text(
                                          ' ${checks[index]['checkTime']}',
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontSize: 12.0,
                                            height: 1.5,
                                          ),
                                        ),
                                      ],
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
                                    checks[index]['statusMessage'],
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

  // finally, the actual widget
  @override
  Widget build(BuildContext context) {
    return isAuth == true ? IsAuthPage() : UnAuthPage();
  }
}
