// import 'package:check/src/models/check.dart';
// import 'package:check/src/models/dummychecks.dart';
import 'package:check/src/ui/views/check.dart';
import 'package:check/src/ui/widgets/header.dart';
import 'package:check/src/ui/widgets/progress.dart';
import 'package:check/src/ui/widgets/status_badge.dart';
import 'package:check/src/ui/widgets/user_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'home.dart';

Future<QuerySnapshot> checksFuture = checksRef.getDocuments();

class Timeline extends StatefulWidget {
  // final checks = dummyChecks;

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  // bool isLoading;
  // List<Check> checks = [];

  // @override
  // void initState() {
  //   super.initState();
  //   buildChecksList();
  // }

  // buildChecksList() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   QuerySnapshot snapshot =
  //       await checksRef.getDocuments().then((QuerySnapshot snapshot) {
  //     snapshot.documents.forEach((DocumentSnapshot doc) {
  //       // Check check = Check.fromDocument(doc.data);
  //       // checks.add(check);
  //       // print('Checks: $checks');
  //       print(doc.data);
  //     });
  //     setState(() {
  //       isLoading = false;
  //     });
  //   });
  // }

  // buildTimelineChecks() {
  //   if (isLoading) {
  //     return circularProgress();
  //   }
  //   return Column(
  //     children: checks != null ? checks : Container(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: header(
        context,
        isAppTitle: true,
        titleText: 'Check',
        removeBackButton: true,
      ),
      body: Center(
        child: Text('Timeline'),
      ),
      // body: ListView(
      //   children: <Widget>[
      //     buildTimelineChecks(),
      //   ],
      // ),
    );
  }
}
