import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:check/src/models/user.dart';
import 'package:check/src/ui/views/home.dart';
import 'package:check/src/ui/widgets/header.dart';
import 'package:check/src/ui/views/Check.dart';
import 'package:check/src/ui/widgets/progress.dart';

// final usersRef = Firestore.instance.collection('users');

class Timeline extends StatefulWidget {
  final User currentUser;

  Timeline({this.currentUser});

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List<Check> checks = [];

  @override
  void initState() {
    super.initState();
    getTimeline();
  }

  getTimeline() async {
    QuerySnapshot snapshot = await timelineRef
        .document(widget.currentUser.id)
        .collection('timelinePosts')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    snapshot.documents.forEach((doc) {
      print(doc);
      checks.add(Check.fromDocument(doc));
    });
    setState(() {
      this.checks = checks;
    });
  }

  buildTimeline() {
    if (checks == null) {
      return circularProgress();
    } else if (checks.isEmpty) {
      return Text("No checks");
    } else {
      return ListView(children: checks);
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: header(context, isAppTitle: true, removeBackButton: true),
        body: RefreshIndicator(
            onRefresh: () => getTimeline(), child: buildTimeline()));
  }
}
