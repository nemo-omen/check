import 'package:cached_network_image/cached_network_image.dart';
import 'package:check/src/models/user.dart';
import 'package:check/src/ui/views/profile.dart';
import 'package:check/src/ui/widgets/header.dart';
import 'package:check/src/ui/widgets/progress.dart';
import 'package:check/src/ui/widgets/status_badge.dart';
import 'package:check/src/ui/widgets/user_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'home.dart';

class Check extends StatefulWidget {
  final String checkId;
  final String ownerId;
  final String displayName;
  final String userName;
  final String mediaUrl;
  final String status;
  final String message;
  final String location;
  // final DateTime timestamp;
  dynamic likes;
  dynamic comments;
  int likeCount;

  Check(
      {this.checkId,
      this.ownerId,
      this.displayName,
      this.userName,
      this.mediaUrl,
      this.status,
      this.message,
      this.location,
      // this.timestamp,
      this.likes,
      this.comments,
      this.likeCount});

  factory Check.fromDocument(DocumentSnapshot doc) {
    return Check(
      checkId: doc['checkId'],
      ownerId: doc['ownerId'],
      status: doc['status'],
      message: doc['message'],
      // timestamp: doc['timestamp'],
      displayName: doc['displayName'],
      userName: doc['userName'],
      mediaUrl: doc['mediaUrl'],
      location: doc['location'],
      likes: doc['likes'],
      comments: doc['comments'],
    );
  }

  int getLikeCount(likes) {
    // if no likes, return 0
    if (likes == null) {
      return 0;
    }
    int count = 0;
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  @override
  _CheckState createState() => _CheckState(
        checkId: this.checkId,
        ownerId: this.ownerId,
        displayName: this.displayName,
        userName: this.userName,
        mediaUrl: this.mediaUrl,
        status: this.status,
        message: this.message,
        location: this.location,
        // timestamp: this.timestamp,
        likes: this.likes,
        comments: this.comments,
        likeCount: getLikeCount(this.likes),
      );
}

class _CheckState extends State<Check> {
  final String checkId;
  final String ownerId;
  final String displayName;
  final String userName;
  final String mediaUrl;
  final String status;
  final String message;
  final String location;
  // final DateTime timestamp;
  int likeCount;
  Map likes;
  Map comments;

  _CheckState(
      {this.checkId,
      this.ownerId,
      this.displayName,
      this.userName,
      this.mediaUrl,
      this.status,
      this.message,
      this.location,
      // this.timestamp,
      this.likes,
      this.comments,
      this.likeCount});

  getCheckHeader() {
    return FutureBuilder(
      future: usersRef.document(ownerId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(snapshot.data);
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(user.photoUrl),
            backgroundColor: Colors.grey,
            radius: 20.0,
          ),
          title: GestureDetector(
            child: Text(
              user.displayName,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          Profile(profileId: user.id)));
            },
          ),
          subtitle: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(0.0),
                child: Text('Feeling'),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 5.0,
                ),
                padding: EdgeInsets.all(0.0),
                child: StatusBadge(status: status),
              ),
              Container(
                padding: EdgeInsets.all(0.0),
                child: Text(location),
              ),
            ],
          ),
        );
      },
    );
  }

  getCheckBody() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        30.0,
        20.0,
        20.0,
        20.0,
      ),
      alignment: Alignment.bottomLeft,
      child: Text(
        message,
        style: TextStyle(
          fontSize: 16.0,
          height: 1.3,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  getCheckFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        IconButton(
          icon: Icon(
            FlutterIcons.heart_outline_mco,
            color: Colors.grey[700],
            size: 20.0,
          ),
          onPressed: () {
            print('Liked!');
          },
        ),
        IconButton(
          icon: Icon(
            FlutterIcons.message1_ant,
            color: Colors.grey[700],
            size: 20.0,
          ),
          onPressed: () {
            print('Comment!');
          },
        ),
        IconButton(
          icon: Icon(
            FlutterIcons.delete_ant,
            color: Colors.grey[700],
            size: 20.0,
          ),
          onPressed: () {
            print('Delete!');
          },
        ),
      ],
    );
  }

  // get the owner's picture from firestore according to ownerId value
  getUserImage(id) {
    return FutureBuilder(
        future: usersRef.document(ownerId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          User user = User.fromDocument(snapshot.data);
          return UserAvatar(
            imageURL: user.photoUrl,
            userName: user.displayName,
            radius: 30.0,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        children: <Widget>[
          getCheckHeader(),
          Divider(
            height: 0.0,
            thickness: 1.0,
            indent: 10.0,
            endIndent: 10.0,
          ),
          getCheckBody(),
          Divider(
            height: 0.0,
            thickness: 1.0,
            indent: 10.0,
            endIndent: 10.0,
          ),
          getCheckFooter(),
        ],
      ),
    );
  }
}