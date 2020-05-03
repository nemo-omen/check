// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Check {
  final String id;
  final String userId;
  String status;
  String message;
  final checkTime;
  // final String checkLocation;

  Check({this.id, this.userId, this.status, this.message, this.checkTime});

  factory Check.fromDocument(DocumentSnapshot doc) {
    return Check(
      userId: doc['userId'],
      status: doc['status'],
      message: doc['message'],
      checkTime: doc['checkTime'],
    );
  }
}
