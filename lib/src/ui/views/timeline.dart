import 'package:check/src/models/check.dart';
import 'package:check/src/models/dummychecks.dart';
import 'package:check/src/ui/views/check_view.dart';
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
  final checks = dummyChecks;

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  buildChecksList() {
    return FutureBuilder(
        future: checksFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          List returnedChecks = [];
          snapshot.data.documents.forEach((doc) {
            Check check = Check.fromDocument(doc);
            returnedChecks.add(check);
          });
          return ListView.builder(
              itemCount: returnedChecks.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  // ie. navigate to view that renders passed Check
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckView(
                          friend: returnedChecks[index]['userId'],
                          status: returnedChecks[index]['status'],
                          statusMessage: returnedChecks[index]['message'],
                          // checkTime: widget.checks[index]['checkTime'],
                          checkTime: 'Some time ago',
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 0.0,
                    color: Colors.white.withOpacity(0.9),
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                              child: UserAvatar(
                                imageURL: currentUser.photoUrl,
                                userName: returnedChecks[index].id,
                                radius: 30.0,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    returnedChecks[index].userId,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                      letterSpacing: 1.2,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        'Feeling ',
                                        style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 12.0,
                                          height: 1.5,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 5.0),
                                        child: StatusBadge(
                                            status:
                                                returnedChecks[index].status),
                                      ),
                                      Text(
                                        // ' ${returnedChecks[index].checkTime.toString()}',
                                        'Some time ago...',
                                        style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 12.0,
                                          height: 1.5,
                                        ),
                                      ),
                                      Text(
                                        'an undisclosed location',
                                        style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 12.0,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: 1.0,
                          indent: 10.0,
                          endIndent: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                padding:
                                    EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                child: Text(
                                  returnedChecks[index].message,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          indent: 10.0,
                          endIndent: 10.0,
                          height: 1.0,
                        ),
                        Container(
                          padding: EdgeInsets.all(0.0),
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                iconSize: 15.0,
                                padding: EdgeInsets.all(0.0),
                                icon: Icon(
                                  FlutterIcons.message_outline_mco,
                                  color: Colors.grey,
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                iconSize: 15.0,
                                padding: EdgeInsets.all(0.0),
                                icon: Icon(
                                  FlutterIcons.heart_outline_mco,
                                  color: Colors.grey,
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                padding: EdgeInsets.all(0.0),
                                iconSize: 15.0,
                                icon: Icon(
                                  FlutterIcons.alert_outline_mco,
                                  color: Colors.grey,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
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
      ),
    );
  }
}
