import 'package:check/src/models/constants.dart';
import 'package:check/src/ui/views/profile.dart';
import 'package:check/src/ui/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';

header(context,
    {bool isAppTitle = false,
    String titleText,
    removeBackButton = false,
    GoogleSignIn googleSignIn,
    GoogleSignInAccount currentUser}) {
  // Handle PopupMenuButton choices

  void logout() {
    googleSignIn.signOut();
  }

  void userMenuChoice(choice) {
    switch (choice) {
      case 'Profile':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    Profile(currentUser: currentUser)));
        break;
      case 'Sign Out':
        logout();
        break;
    }
  }

  // return PreferredSize(
  // preferredSize: Size.fromHeight(40.0),
  return AppBar(
    // automaticallyImplyLeading: removeBackButton == true ? false : true,
    leading: removeBackButton == false
        ? IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              FlutterIcons.back_ant,
              color: Theme.of(context).primaryColor,
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                print(currentUser);
              },
              child: PopupMenuButton<String>(
                onSelected: userMenuChoice,
                itemBuilder: (BuildContext context) {
                  return Constants.choices.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
                icon: CircleAvatar(
                    backgroundImage: NetworkImage(currentUser.photoUrl),
                    radius: 30.0),
              ),
            ),
          ),
    backgroundColor: Colors.white,
    centerTitle: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(10),
      ),
    ),
    title: Text(
      isAppTitle ? 'Check' : titleText,
      style: TextStyle(
        fontFamily: 'IBM Plex Sans',
        fontSize: 30.0,
        fontWeight: FontWeight.w200,
        color: Theme.of(context).primaryColor,
      ),
    ),
  );
  // );
}
