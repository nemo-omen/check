import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

header(context,
    {bool isAppTitle = false, String titleText, removeBackButton = false}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(40.0),
    child: AppBar(
      automaticallyImplyLeading: removeBackButton == true ? false : true,
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
          : null,
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
    ),
  );
}
