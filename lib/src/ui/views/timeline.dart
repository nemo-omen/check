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
  buildChecksList() {
    return Container(
      child: Text('Return checks here'),
    );
    // return FutureBuilder(
    //     future: checksRef.getDocuments(),
    //     builder: (context, snapshot) {
    //       if (!snapshot.hasData) {
    //         return circularProgress();
    //       } else {
    //         List allChecks = [];
    //         List<Widget> checkViews = [];
    //         snapshot.data.documents.forEach((doc) {
    //           Check check = Check.fromDocument(doc);
    //           allChecks.add(check);
    //           allChecks.forEach((check) {
    //             checkViews.add(
    //               Check(
    //                 checkId: check.checkId,
    //                 ownerId: check.ownerId,
    //                 displayName: check.displayName,
    //                 userName: check.userName,
    //                 mediaUrl: check.mediaUrl,
    //                 status: check.status,
    //                 message: check.message,
    //                 location: check.location,
    //                 timestamp: check.timestamp,
    //                 likes: check.likes,
    //                 comments: check.comments,
    //               ),
    //             );
    //           });
    //           return ListView(
    //             children: checkViews,
    //           );
    //         });
    //       }
    //     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: header(
        context,
        isAppTitle: true,
        titleText: 'Check',
        removeBackButton: true,
      ),
      body: Center(
        // build a ListView from all checks posted by friends
        child: buildChecksList(),
        // child: Text('Timeline'),
      ),
    );
  }
}
