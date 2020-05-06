import 'package:check/src/ui/views/timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
// ! Widget imports
import 'package:check/src/ui/widgets/header.dart';
// ! Page imports
import 'package:check/src/ui/views/profile.dart';
import 'package:check/src/ui/views/create_account.dart';
// import 'package:check/src/ui/views/friends.dart';
import 'package:check/src/ui/views/notifications.dart';
// import 'package:check/src/ui/views/settings.dart';
import 'package:check/src/ui/views/search.dart';
import 'package:check/src/ui/views/post_check.dart';
// ! Model imports
import 'package:google_sign_in/google_sign_in.dart';
import 'package:check/src/models/user.dart';
// ! View imports

// globals
// google sign/firestore users
final GoogleSignIn googleSignIn = GoogleSignIn();
GoogleSignInAccount fireStoreUser;

// firestore database & storage references
final usersRef = Firestore.instance.collection('users');
final checksRef = Firestore.instance.collection('checks');
final commentsRef = Firestore.instance.collection('comments');
final activityFeedRef = Firestore.instance.collection('feed');
final followersRef = Firestore.instance.collection('followers');
final followingRef = Firestore.instance.collection('following');
final timelineRef = Firestore.instance.collection('timeline');
final StorageReference storageRef = FirebaseStorage.instance.ref();

// this is our current user ... use the user wisely :)
User currentUser;

// create a timestamp variable you can use whenever you need it
final DateTime timestamp = DateTime.now();

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // vars
  bool isAuth = false;
  PageController pageController; //declare pageController variable
  int pageIndex = 0;

  // Functions/methods
  @override
  void initState() {
    super.initState();
    pageController = PageController();

    // Detect whether login() function resulted in a signed in user
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      handleSignIn(account);
    }, onError: (err) {
      // print('Error signing in: $err');
    });
    // Reauthenticate user on app open
    googleSignIn
        .signInSilently(
      suppressErrors: false,
    )
        .then((account) {
      handleSignIn(account);
    }).catchError((err) {
      // print('Error signing in: $err');
    });
  }

// login the user
// * logout function is located in the header widget.
  login() {
    googleSignIn.signIn();
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      // print(account);
      // if login is successful, call createFirestoreUser()
      createFirestoreUser();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  // called if login is successful => create user in firestore collection if doesn't exist
  createFirestoreUser() async {
    // 1)check if user exists is users collection in database
    // according to id
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.document(user.id).get();

    if (!doc.exists) {
      // 2)if user !exists, route to CreateAccountView
      //and await the returned value ... store in a nice variable
      final userName = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));

      // 3)get userName from CreateAccount, use it to make new user document
      // in users collection
      usersRef.document(user.id).setData({
        'id': user.id,
        'userName': userName,
        'photoUrl': user.photoUrl,
        'displayName': user.displayName,
        'bio': '',
        'timestamp': timestamp,
      });
      // fetch the changed document and use it to create the user instance
      doc = await usersRef.document(user.id).get();
    }
    // go ahead and create a User instance from the firestore document snapshot
    setState(() {
      currentUser = User.fromDocument(doc);
    });
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

// Build UnAuthPage: return a Scaffold widget
// if user is not authenticated

  Scaffold unAuthPage() {
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
              child: FlatButton.icon(
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Build IsAuthPage: return a Scaffold widget
// if GoogleSignIn returns authentication
  Scaffold isAuthPage() {
    return Scaffold(
      backgroundColor: Colors.blue[300],
      // Use header widget - found in ui/widgets/header/dart
      body: PageView(
        children: <Widget>[
          // include each page here for PageView
          Timeline(currentUser: currentUser),
          Notifications(),
          Search(),
          Profile(profileId: currentUser?.id, isMainProfile: true),
          // Settings(),
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
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 30.0, 0.0),
              child: Icon(
                FlutterIcons.notification_ant,
                size: 20.0,
              ),
            ),
            title: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 30.0, 0.0),
                child: Text('')),
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0),
              child: Icon(
                FlutterIcons.search1_ant,
                size: 20.0,
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
              child: Text(''),
            ),
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.fromLTRB(
                0.0,
                0.0,
                0.0,
                0.0,
              ),
              child: Icon(
                FlutterIcons.user_ant,
                size: 20.0,
              ),
            ),
            title: Padding(
                padding: EdgeInsets.fromLTRB(
                  0.0,
                  0.0,
                  0.0,
                  0.0,
                ),
                child: Text('')),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        PostCheck(currentUser: currentUser)));
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
    return isAuth == true ? isAuthPage() : unAuthPage();
  }
}
