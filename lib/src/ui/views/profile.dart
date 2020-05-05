import 'package:cached_network_image/cached_network_image.dart';
import 'package:check/src/models/user.dart';
import 'package:check/src/ui/views/check.dart';
import 'package:check/src/ui/views/edit_profile.dart';
import 'package:check/src/ui/views/home.dart';
import 'package:check/src/ui/widgets/header.dart';
import 'package:check/src/ui/widgets/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Profile extends StatefulWidget {
  final String profileId;
  bool isMainProfile;
  Profile({this.profileId, this.isMainProfile});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String currentUserId = currentUser?.id;
  bool isLoading = false;
  int checksCount = 0;
  List<Check> checks = [];

  @override
  void initState() {
    super.initState();
    getProfileChecks();
  }

  getProfileChecks() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await checksRef
        .document(widget.profileId)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    setState(() {
      isLoading = false;
      checksCount = snapshot.documents.length;
      checks =
          snapshot.documents.map((doc) => Check.fromDocument(doc)).toList();
    });
  }

  buildCountColumn(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 4.0),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return EditProfile(currentUserId: currentUserId);
      }),
    );
  }

  // function for building different profile buttons depending on
  buildButton({String text, Function function, color}) {
    return FlatButton(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      onPressed: function,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  void logOut() async {
    await googleSignIn.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false);
    // Navigator.pop(context);
  }

  buildProfileButton() {
    // if we're viewing our own profile - show 'Edit Profile' button
    bool isProfileOwner = currentUserId == widget.profileId;
    if (isProfileOwner) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          buildButton(
            text: 'Edit Profile',
            function: editProfile,
            color: Theme.of(context).primaryColor.withOpacity(0.8),
          ),
          buildButton(
            text: 'Log Out',
            function: logOut,
            color: Colors.red[300],
          ),
        ],
      );
    }
  }

  buildProfileHeader() {
    return FutureBuilder(
        future: usersRef.document(widget.profileId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          User user = User.fromDocument(snapshot.data);
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        right: 20.0,
                      ),
                      child: CircleAvatar(
                        backgroundImage:
                            CachedNetworkImageProvider(user.photoUrl),
                        backgroundColor: Colors.grey,
                        radius: 40.0,
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          child: Text(
                            user.displayName,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1.2,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8.0),
                          child: Text(
                            '@${user.userName}',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(
                  color: Theme.of(context).accentColor,
                  thickness: 0.7,
                  indent: 10.0,
                  endIndent: 10.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  child: Text(
                    user.bio != null ? user.bio : '',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontWeight: FontWeight.w300,
                      fontSize: 16.0,
                      height: 1.3,
                    ),
                  ),
                ),
                Divider(
                  color: Theme.of(context).accentColor,
                  thickness: 0.7,
                  indent: 10.0,
                  endIndent: 10.0,
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: 5.0,
                  ),
                  child: buildProfileButton(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      child: buildCountColumn('Checks', checks.length),
                    ),
                    Container(
                      child: buildCountColumn('Friends', user.friends.length),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            padding: EdgeInsets.all(2.0),
                            icon: Icon(
                              FlutterIcons.comment_account_outline_mco,
                              color: Colors.black,
                              size: 24.0,
                            ),
                            onPressed: () {
                              print('Message');
                            },
                          ),
                          Text(
                            'Message',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey,
                              height: 0.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  buildProfileChecks() {
    if (isLoading) {
      return circularProgress();
    }
    return Column(
      children: checks,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: header(
        context,
        titleText: 'Profile',
        removeBackButton:
            widget.isMainProfile != null ? widget.isMainProfile : false,
      ),
      body: ListView(
        children: <Widget>[
          buildProfileHeader(),
          buildProfileChecks(),
        ],
      ),
    );
  }
}
