import 'package:cached_network_image/cached_network_image.dart';
import 'package:check/src/ui/widgets/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:check/src/ui/widgets/header.dart';
import 'package:check/src/ui/views/home.dart';

class Comments extends StatefulWidget {
  final String postOwnerId;
  final String postId;

  Comments({this.postOwnerId, this.postId});

  @override
  CommentsState createState() => CommentsState(
        postOwnerId: this.postOwnerId,
        postId: this.postId,
      );
}

class CommentsState extends State<Comments> {
  TextEditingController _commentController = TextEditingController();
  final String postOwnerId;
  final String postId;
  final String currentUserId;

  CommentsState({
    this.postOwnerId,
    this.postId,
    this.currentUserId,
  });

  buildComments() {
    return StreamBuilder(
        stream: commentsRef
            .document(postId)
            .collection('comments')
            .orderBy('timeStamp', descending: true)
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          List<Comment> comments = [];
          snapshot.data.documents.forEach((doc) {
            comments.add(Comment.fromDocument(doc));
            print('Comments $comments');
          });
          return ListView(
            children: comments,
          );
        });
  }

  submitComment(currentUser, comment) {
    commentsRef.document(postId).collection('comments').add({
      'userName': currentUser.userName,
      'displayName': currentUser.displayName,
      'avatarUrl': currentUser.photoUrl,
      'userId': currentUser.id,
      'timestamp': timestamp,
      'comment': comment,
    });
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
        context,
        titleText: 'Comments',
        removeBackButton: false,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: buildComments(),
          ),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: 'Write a comment...',
              ),
            ),
            trailing: OutlineButton(
              borderSide: BorderSide.none,
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Text(
                'Post',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () =>
                  submitComment(currentUser, _commentController.text),
            ),
          ),
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String comment;
  final String userName;
  final String displayName;
  final String avatarUrl;
  final String userId;
  final Timestamp timestamp;

  Comment(
      {this.comment,
      this.userName,
      this.displayName,
      this.avatarUrl,
      this.userId,
      this.timestamp});

  factory Comment.fromDocument(DocumentSnapshot document) {
    return Comment(
        comment: document['comment'],
        userName: document['userName'],
        displayName: document['displayName'],
        avatarUrl: document['avatarUrl'],
        userId: document['userId'],
        timestamp: document['timestamp']);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(comment),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(avatarUrl),
            backgroundColor: Colors.grey,
            radius: 30.0,
          ),
          subtitle: Text(
            timeago.format(
              timestamp.toDate(),
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
