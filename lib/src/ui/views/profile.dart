import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final currentUser;
  Profile({this.currentUser});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  setProfilePicture() {
    print('Do something about this!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: setProfilePicture,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.currentUser.photoUrl),
                  radius: 60.0,
                ),
              ),
              Divider(
                indent: 50.0,
                endIndent: 50.0,
              ),
              Container(
                child: Text(widget.currentUser.displayName,
                    style: TextStyle(fontSize: 30.0, color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
