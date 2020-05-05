import 'package:flutter/material.dart';

header(
  context, {
  bool isAppTitle = false,
  String titleText,
  removeBackButton = false,
}) {
  // Handle PopupMenuButton choices

  // return PreferredSize(
  // preferredSize: Size.fromHeight(40.0),
  return AppBar(
    automaticallyImplyLeading: removeBackButton == true ? false : true,
    backgroundColor: Colors.white,
    centerTitle: true,
    leading: removeBackButton == true
        ? null
        : IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
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
