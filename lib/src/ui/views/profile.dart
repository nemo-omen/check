import 'package:check/src/models/user.dart';
import 'package:check/src/ui/views/home.dart';
import 'package:check/src/ui/widgets/progress.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  User currentUser;
  Profile({this.currentUser});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  setProfilePicture() {
    print('Do something about this!');
  }

  buildUserProfile() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: setProfilePicture,
            child: CircleAvatar(
              backgroundImage:
                  NetworkImage(widget.currentUser.photoUrl.toString()),
              radius: 60.0,
            ),
          ),
          Divider(
            indent: 50.0,
            endIndent: 50.0,
          ),
          Container(
            child: Text(widget.currentUser.displayName.toString(),
                style: TextStyle(fontSize: 30.0, color: Colors.black)),
          ),
          Container(
              child: Text(
            '@${widget.currentUser.userName.toString()}',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 20.0,
            ),
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: currentUser == null ? circularProgress() : buildUserProfile(),
      ),
    );
  }
}
