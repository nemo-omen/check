// import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String userName;
  final String email;
  final String photoUrl;
  final String displayName;
  final List friends;
  final List checks;
  final List messages;

  User({
    this.id,
    this.userName,
    this.email,
    this.photoUrl,
    this.displayName,
    this.friends,
    this.checks,
    this.messages,
  });
}
