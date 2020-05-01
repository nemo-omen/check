import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
// ! Widget imports
import 'package:check/src/ui/widgets/user_avatar.dart';
import 'package:check/src/ui/widgets/header.dart';
import 'package:check/src/ui/widgets/is_auth.dart';
import 'package:check/src/ui/widgets/unauth.dart';
// ! Page imports
import 'package:check/src/ui/views/friends.dart';
import 'package:check/src/ui/views/messages.dart';
import 'package:check/src/ui/views/settings.dart';

// class HomePage extends StatelessWidget {
//   HomePage({Key key, this.title, this.isAuth}) : super(key: key);
//   final String title;
//   bool isAuth = false;

//   @override
//   Widget build(BuildContext context) {
//     return isAuth == true ? IsAuthPage() : UnAuthPage();
//   }
// }

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.isAuth}) : super(key: key);
  final String title;
  bool isAuth = false;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return widget.isAuth == true ? IsAuthPage() : UnAuthPage();
  }
}
