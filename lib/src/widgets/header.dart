import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

header(context,
    {bool isAppTitle = false, String titleText, removeBackButton = false}) {
  return AppBar(
    automaticallyImplyLeading: removeBackButton = true ? false : true,
    backgroundColor: Colors.white,
    centerTitle: true,
    title: Text(
      isAppTitle ? 'Check' : titleText,
      style: TextStyle(
        fontFamily: 'IBM Plex Sans',
        fontSize: 30.0,
        fontWeight: FontWeight.w200,
        color: Theme.of(context).primaryColor,
      ),
    ),
    // actions: <Widget>[
    //   IconButton(
    //     icon: Icon(
    //       FlutterIcons.team_ant,
    //       color: Theme.of(context).primaryColor,
    //     ),
    //     tooltip: 'Friends',
    //     iconSize: 20.0,
    //     onPressed: () {
    //       print('Pressed Friends');
    //     },
    //   ),
    //   IconButton(
    //     icon: Icon(
    //       FlutterIcons.mail_ant,
    //       color: Theme.of(context).primaryColor,
    //     ),
    //     tooltip: 'Messages',
    //     iconSize: 20.0,
    //     onPressed: () {
    //       print('Pressed Messages.');
    //     },
    //   ),
    //   IconButton(
    //     icon: Icon(
    //       FlutterIcons.search1_ant,
    //       color: Theme.of(context).primaryColor,
    //     ),
    //     tooltip: 'Search',
    //     iconSize: 20.0,
    //     onPressed: () {
    //       print('Pressed messages.');
    //     },
    //   ),
    //   IconButton(
    //     icon: Icon(
    //       FlutterIcons.setting_ant,
    //       color: Theme.of(context).primaryColor,
    //     ),
    //     tooltip: 'Settings',
    //     iconSize: 20.0,
    //     onPressed: () {
    //       print('Pressed Menu');
    //     },
    //   ),
    // ],
  );
}
