// import 'package:cloud_firestore/cloud_firestore.dart';

class Check {
  final String userId;
  String status;
  final DateTime checkTime;
  final String checkLocation;

  Check({this.userId, this.status, this.checkTime, this.checkLocation});
}
