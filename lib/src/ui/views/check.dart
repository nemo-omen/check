import 'package:cached_network_image/cached_network_image.dart';
import 'package:check/src/models/user.dart';
import 'package:check/src/ui/views/check_view.dart';
import 'package:check/src/ui/views/comments.dart';
import 'package:check/src/ui/views/profile.dart';
import 'package:check/src/ui/widgets/progress.dart';
import 'package:check/src/ui/widgets/status_badge.dart';
import 'package:check/src/ui/widgets/user_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'home.dart';

class Check extends StatefulWidget {
  final String checkId;
  final String ownerId;
  final String displayName;
  final String userName;
  final String mediaUrl;
  final String status;
  final String message;
  final String location;
  final Timestamp timestamp;
  dynamic likes = {};
  int likeCount;

  Check({
    this.checkId,
    this.ownerId,
    this.displayName,
    this.userName,
    this.mediaUrl,
    this.status,
    this.message,
    this.location,
    this.timestamp,
    this.likes,
    this.likeCount,
  });

  factory Check.fromDocument(DocumentSnapshot doc) {
    return Check(
      checkId: doc['checkId'],
      ownerId: doc['ownerId'],
      status: doc['status'],
      message: doc['message'],
      timestamp: doc['timestamp'],
      displayName: doc['displayName'],
      userName: doc['userName'],
      mediaUrl: doc['mediaUrl'],
      location: doc['location'],
      likes: doc['likes'],
    );
  }

  int getLikeCount(likes) {
    // if no likes, return 0
    if (likes == null) {
      return 0;
    }
    int count = 0;
    // if the key is set to true, add a like
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  @override
  _CheckState createState() => _CheckState(
        checkId: this.checkId,
        ownerId: this.ownerId,
        displayName: this.displayName,
        userName: this.userName,
        mediaUrl: this.mediaUrl,
        status: this.status,
        message: this.message,
        location: this.location,
        timestamp: this.timestamp,
        likes: this.likes,
        likeCount: getLikeCount(this.likes),
      );
}

class _CheckState extends State<Check> {
  final String currentUserId = currentUser?.id;
  final String checkId;
  final String ownerId;
  final String displayName;
  final String userName;
  final String mediaUrl;
  final String status;
  final String message;
  final String location;
  final Timestamp timestamp;
  int likeCount;
  Map likes = {};
  bool isLiked;
  int commentsCount;

  _CheckState({
    this.checkId,
    this.ownerId,
    this.displayName,
    this.userName,
    this.mediaUrl,
    this.status,
    this.message,
    this.location,
    this.timestamp,
    this.likes,
    this.likeCount,
  });

  getCheckHeader() {
    return FutureBuilder(
      future: usersRef.document(ownerId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(snapshot.data);
        return ListTile(
          isThreeLine: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          Profile(profileId: user.id)));
            },
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(user.photoUrl),
              backgroundColor: Colors.grey,
              radius: 20.0,
            ),
          ),
          title: GestureDetector(
            child: Text(
              user.displayName,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          CheckView(userId: user.id, postId: checkId)));
            },
          ),
          subtitle: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(0.0),
                    child: Text('Feeling'),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 5.0,
                    ),
                    padding: EdgeInsets.all(0.0),
                    child: StatusBadge(status: status),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    child: Text('$location — '),
                  ),
                  Container(
                    padding: EdgeInsets.all(0.0),
                    child: Text(timestamp != null
                        ? timeago.format(
                            timestamp.toDate(),
                          )
                        : ''),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  getCheckBody() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        30.0,
        20.0,
        20.0,
        20.0,
      ),
      alignment: Alignment.bottomLeft,
      child: Text(
        message == null ? '' : message,
        style: TextStyle(
          fontSize: 16.0,
          height: 1.3,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  handleLikeCheck() {
    bool _isLiked = likes[currentUserId] == true;

    if (_isLiked) {
      checksRef
          .document(ownerId)
          .collection('userPosts')
          .document(checkId)
          .updateData({'likes.$currentUserId': false});
      removeLikeFromActivityFeed();
      setState(() {
        likeCount -= 1;
        isLiked = false;
        likes[currentUserId] = false;
      });
    } else if (!_isLiked) {
      checksRef
          .document(ownerId)
          .collection('userPosts')
          .document(checkId)
          .updateData({'likes.$currentUserId': true});
      addLikeToActivityFeed();
      setState(() {
        likeCount += 1;
        isLiked = true;
        likes[currentUserId] = true;
      });
    }
  }

  addLikeToActivityFeed() {
    bool isNotOwner = currentUser.id != ownerId;
    if (isNotOwner) {
      activityFeedRef
          .document(ownerId)
          .collection('feedItems')
          .document(checkId)
          .setData({
        'type': 'like',
        'userName': currentUser.userName,
        'userId': currentUser.id,
        'userProfileImg': currentUser.photoUrl,
        'postId': checkId,
        'timestamp': DateTime.now(),
      });
    }
  }

  removeLikeFromActivityFeed() {
    bool isNotOwner = currentUser.id != ownerId;
    if (isNotOwner) {
      activityFeedRef
          .document(ownerId)
          .collection('feedItems')
          .document(checkId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    }
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text('OK'),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text('I don\'t do anything yet!'),
      content: Text('But soon, I\'ll have real functionality!'),
      actions: <Widget>[okButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  buildDeleteButton() {
    if (currentUserId == ownerId) {
      return FlatButton.icon(
        icon: Icon(
          FlutterIcons.delete_ant,
          color: Colors.grey[700],
          size: 20.0,
        ),
        label: Text(
          'Delete',
          style: TextStyle(
            color: Colors.grey[700],
          ),
        ),
        onPressed: () {
          showAlertDialog(context);
        },
      );
    } else {
      return Text('');
    }
  }

  showComments(BuildContext context, {String ownerId, String postId}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Comments(
        postId: postId,
        postOwnerId: ownerId,
      );
    }));
  }

  getCommentsCount() {
    var commentsCountQuery = Firestore.instance
        .collection('comments')
        .document(checkId)
        .collection('comments');
    return FutureBuilder(
        future: commentsCountQuery.getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          int _commentsCount = 0;
          snapshot.data.documents.forEach((doc) {
            _commentsCount += 1;
          });
          return FlatButton.icon(
            icon: Icon(
              FlutterIcons.message1_ant,
              color: Colors.grey[700],
              size: 20.0,
            ),
            label: Text(
              _commentsCount != null ? _commentsCount.toString() : '0',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
            onPressed: () {
              showComments(
                context,
                postId: checkId,
                ownerId: ownerId,
              );
            },
          );
        });
  }

  getCheckFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        FlatButton.icon(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          icon: isLiked == true
              ? Icon(FlutterIcons.heart_mco, color: Colors.red[300])
              : Icon(FlutterIcons.heart_outline_mco, color: Colors.grey[700]),
          label: Text(
            likeCount.toString(),
            style: TextStyle(
              color: isLiked == true ? Colors.red[300] : Colors.grey[700],
            ),
          ),
          onPressed: handleLikeCheck,
        ),
        getCommentsCount(),
        // FlatButton.icon(
        //   icon: Icon(
        //     FlutterIcons.message1_ant,
        //     color: Colors.grey[700],
        //     size: 20.0,
        //   ),
        //   label: Text(
        //     commentsCount != null ? commentsCount.toString() : '0',
        //     style: TextStyle(
        //       color: Colors.grey[700],
        //     ),
        //   ),
        //   onPressed: () {
        //     showComments(
        //       context,
        //       postId: checkId,
        //       ownerId: ownerId,
        //     );
        //   },
        // ),
        buildDeleteButton(),
      ],
    );
  }

  // get the owner's picture from firestore according to ownerId value
  getUserImage(id) {
    return FutureBuilder(
        future: usersRef.document(ownerId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          User user = User.fromDocument(snapshot.data);
          return UserAvatar(
            imageURL: user.photoUrl,
            userName: user.displayName,
            radius: 30.0,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    isLiked = (likes[currentUserId] == true);
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        children: <Widget>[
          getCheckHeader(),
          Divider(
            height: 0.0,
            thickness: 1.0,
            indent: 10.0,
            endIndent: 10.0,
          ),
          getCheckBody(),
          Divider(
            height: 0.0,
            thickness: 1.0,
            indent: 10.0,
            endIndent: 10.0,
          ),
          getCheckFooter(),
        ],
      ),
    );
  }
}
