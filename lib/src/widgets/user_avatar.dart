import 'package:flutter/material.dart';
import 'dart:math';

class UserAvatar extends StatelessWidget {
  String imageURL;
  String userName;
  UserAvatar({this.imageURL, this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 30.0,
      height: 30.0,
      decoration: BoxDecoration(
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: ClipOval(
        child: imageURL == null
            ? Text(userName.substring(0, 1))
            : Image.network(
                imageURL,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
