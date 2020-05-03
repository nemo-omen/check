import 'package:cached_network_image/cached_network_image.dart';
import 'package:check/src/models/user.dart';
import 'package:check/src/models/status_types.dart';
import 'package:check/src/ui/widgets/status_badge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final checksRef = Firestore.instance.collection('checks');
final DateTime timestamp = DateTime.now();

class PostCheck extends StatefulWidget {
  User currentUser;
  PostCheck({this.currentUser});
  @override
  _PostCheckState createState() => _PostCheckState();
}

class _PostCheckState extends State<PostCheck> {
  String selectedStatus;
  String checkMessage;
  final _checkFormKey = GlobalKey<FormState>();
  TextEditingController _checkController = TextEditingController();
  User _currentUser;

  @override
  void initState() {
    super.initState();
    if (widget.currentUser != null) {
      _currentUser = widget.currentUser;
    }
  }

  @override
  void dispose() {
    _checkController.dispose();
    super.dispose();
  }

  addStatus(status) {
    setState(() {
      selectedStatus = status;
    });
  }

  submit(value) {
    checkMessage = value;
    print('$_currentUser: Feeling $selectedStatus, Message: $checkMessage');
    _checkController.clear();
    createFirestoreCheck();
    setState(() {
      selectedStatus = null;
    });
    // Navigator.pop(context);
  }

  createFirestoreCheck() async {
    var _savedCheck = await checksRef.add({
      'checkTime': timestamp,
      'status': selectedStatus,
      'message': checkMessage,
      'userId': _currentUser.id,
    });
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          'New Check',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 10.0),
                    child: CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider(_currentUser.photoUrl),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  Container(
                    child: PopupMenuButton<String>(
                      itemBuilder: (BuildContext context) {
                        return StatusTypes.statuses.map((String status) {
                          return PopupMenuItem<String>(
                            value: status,
                            child: StatusBadge(status: status),
                          );
                        }).toList();
                      },
                      onSelected: addStatus,
                      icon: Icon(Icons.arrow_drop_down),
                      elevation: 1.0,
                    ),
                  ),
                  Container(
                    child: StatusBadge(status: selectedStatus),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey[800],
            ),
            Container(
              child: Form(
                key: _checkFormKey,
                child: TextField(
                  controller: _checkController,
                  autofocus: true,
                  maxLines: 10,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5.0),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  // color: Colors.grey,
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                FlatButton(
                    onPressed: () {
                      submit(_checkController.text);
                    },
                    // color: Theme.of(context).primaryColor,
                    child: Text(
                      'Post',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18.0,
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
