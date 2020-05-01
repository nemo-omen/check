import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:check/src/pages/home.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

class UnAuthPage extends StatefulWidget {
  @override
  _UnAuthPageState createState() => _UnAuthPageState();
}

class _UnAuthPageState extends State<UnAuthPage> {
  bool authState = false;

  initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      if (account != null) {
        print(account);
        setState(() {
          authState = true;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    isAuth: authState,
                  )),
        );
      } else {
        setState(() {
          authState = false;
        });
      }
    });
  }

  login() {
    googleSignIn.signIn();
  }

  @override
  Widget build(BuildContext context) {
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

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => HomePage(
                //             isAuth: authState,
                //           )),
                // );
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
}
