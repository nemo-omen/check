import 'package:cached_network_image/cached_network_image.dart';
import 'package:check/src/ui/views/check_view.dart';
import 'package:check/src/ui/views/home.dart';
import 'package:check/src/ui/views/profile.dart';
import 'package:check/src/ui/widgets/header.dart';
import 'package:check/src/ui/widgets/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:timeago/timeago.dart' as timeago;
// import 'package:flutter_icons/flutter_icons.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  getActivityFeed() async {
    QuerySnapshot snapshot = await activityFeedRef
        .document(currentUser.id)
        .collection('feedItems')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .getDocuments();
    List<FeedItem> feedItems = [];
    snapshot.documents.forEach((doc) {
      feedItems.add(FeedItem.fromDocument(doc));
      // print('Activity Feed Item: ${doc.data}');
    });
    return feedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar:
          header(context, titleText: 'Notifications', removeBackButton: true),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: getActivityFeed(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return circularProgress();
            }
            return ListView(
              children: snapshot.data,
            );
          },
        ),
      ),
    );
  }
}

class FeedItem extends StatelessWidget {
  final String commentData;
  final String userName;
  final String userId;
  final String type;
  final String postId;
  final String userProfileImg;
  final Timestamp timestamp;
  String activityItemText;

  FeedItem({
    this.commentData,
    this.userName,
    this.userId,
    this.type,
    this.postId,
    this.userProfileImg,
    this.timestamp,
  });

  factory FeedItem.fromDocument(DocumentSnapshot doc) {
    return FeedItem(
      commentData: doc['commentData'],
      userName: doc['userName'],
      userId: doc['userId'],
      type: doc['type'],
      postId: doc['postId'],
      userProfileImg: doc['userProfileImg'],
      timestamp: doc['timestamp'],
    );
  }

  showPost(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CheckView(postId: postId, userId: userId)));
  }

  buildFeedItemWidget(context) {
    if (type == 'comment') {
      return GestureDetector(
        onTap: () {
          showPost(context);
        },
        child: ListTile(
          dense: false,
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          Profile(profileId: userId)));
            },
            child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(userProfileImg),
                backgroundColor: Colors.grey,
                radius: 20.0),
          ),
          title: Container(
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' said "$commentData"',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          subtitle: Container(
            child: Text(timeago.format(timestamp.toDate())),
          ),
        ),
      );
    } else if (type == 'like') {
      return GestureDetector(
        onTap: () {
          showPost(context);
        },
        child: ListTile(
          leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(userProfileImg),
              backgroundColor: Colors.grey,
              radius: 20.0),
          title: Container(
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' liked your check',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          subtitle: Container(
            child: Text(timeago.format(timestamp.toDate())),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          showPost(context);
        },
        child: ListTile(
          leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(userProfileImg),
              backgroundColor: Colors.grey,
              radius: 20.0),
          title: Container(
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' followed you',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          subtitle: Container(
            child: Text(timeago.format(timestamp.toDate())),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: buildFeedItemWidget(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }
}
