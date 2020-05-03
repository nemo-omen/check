import 'package:cached_network_image/cached_network_image.dart';
import 'package:check/src/models/user.dart';
import 'package:check/src/ui/views/edit_profile.dart';
import 'package:check/src/ui/views/home.dart';
import 'package:check/src/ui/widgets/header.dart';
import 'package:check/src/ui/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Profile extends StatefulWidget {
  final String profileId;
  Profile({this.profileId});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String currentUserId = currentUser?.id;
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

  void logOut() {
    googleSignIn.signOut();
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
                Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                    backgroundColor: Colors.grey,
                    radius: 60.0,
                  ),
                ),
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
                Container(
                  margin: EdgeInsets.only(top: 14.0),
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.0,
                  ),
                  child: Text(
                    user.bio != null ? user.bio : '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontWeight: FontWeight.w300,
                      fontSize: 16.0,
                      height: 1.3,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: 15.0,
                  ),
                  child: buildProfileButton(),
                ),
                Divider(
                  color: Theme.of(context).accentColor,
                  height: 30.0,
                  thickness: 0.75,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      child: buildCountColumn('Checks', 0),
                    ),
                    Container(
                      child: buildCountColumn('Friends', 0),
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
                Divider(
                  color: Theme.of(context).accentColor,
                  height: 30.0,
                  thickness: 0.75,
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: header(context, titleText: 'Profile'),
      body: ListView(
        children: <Widget>[
          buildProfileHeader(),
        ],
      ),
    );
  }
}
