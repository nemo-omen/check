import 'package:check/src/ui/views/check.dart';
import 'package:check/src/ui/widgets/header.dart';
import 'package:check/src/ui/views/home.dart';
import 'package:check/src/ui/widgets/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

class CheckView extends StatelessWidget {
  final String postId;
  final String userId;

  CheckView({this.postId, this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checksRef
          .document(userId)
          .collection('userPosts')
          .document(postId)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        Check check = Check.fromDocument(snapshot.data);
        return Center(
          child: Scaffold(
            appBar: header(
              context,
              titleText: timeago.format(check.timestamp.toDate()),
              removeBackButton: false,
            ),
            body: Container(
              child: check,
            ),
          ),
        );
      },
    );
  }
}
