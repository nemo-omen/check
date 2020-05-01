import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
// ! Widget imports
import 'package:check/src/widgets/user_avatar.dart';
import 'package:check/src/widgets/header.dart';
import 'package:check/src/widgets/is_auth.dart';
import 'package:check/src/widgets/unauth.dart';
// ! Page imports
import 'package:check/src/pages/friends.dart';
import 'package:check/src/pages/messages.dart';
import 'package:check/src/pages/settings.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key, this.title, this.isAuth}) : super(key: key);
  final String title;
  bool isAuth = false;

  @override
  Widget build(BuildContext context) {
    return isAuth == true ? IsAuthPage() : UnAuthPage();
  }
}

// class HomePage extends StatefulWidget {
//   HomePage({Key key, this.title, this.isAuth}) : super(key: key);
//   final String title;
//   @override
//   void initState() {
//   bool isAuth = false;
//   }
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return isAuth == true ? IsAuthPage() : UnAuthPage();
//   }
// }
