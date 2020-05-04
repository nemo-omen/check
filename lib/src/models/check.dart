// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Check {
  final String id;
  String status;
  String message;
  final String ownerId;
  final String displayName;
  final String userName;
  final String mediaUrl;
  final String location;
  final timestamp;
  dynamic likes;
  dynamic comments;
  // final String checkLocation;

  Check({
    this.id,
    this.ownerId,
    this.status,
    this.message,
    this.timestamp,
    this.displayName,
    this.userName,
    this.mediaUrl,
    this.location,
    this.likes,
    this.comments,
  });

  factory Check.fromDocument(DocumentSnapshot doc) {
    return Check(
      id: doc['id'],
      ownerId: doc['userId'],
      status: doc['status'],
      message: doc['message'],
      timestamp: doc['timestamp'],
      displayName: doc['displayName'],
      userName: doc['userName'],
      mediaUrl: doc['mediaUrl'],
      location: doc['location'],
      likes: doc['likes'],
      comments: doc['comments'],
    );
  }

  int getLikeCount() {
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
}
