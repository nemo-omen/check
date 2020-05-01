import 'package:flutter/material.dart';
import 'dart:math';

class UserAvatar extends StatelessWidget {
  String imageURL;
  String userName;
  double radius;
  UserAvatar({this.imageURL, this.userName, this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
        borderRadius: BorderRadius.circular(radius),
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
