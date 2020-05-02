import 'package:cached_network_image/cached_network_image.dart';
import 'package:check/src/models/user.dart';
import 'package:check/src/ui/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PostCheck extends StatefulWidget {
  User currentUser;
  PostCheck({this.currentUser});
  @override
  _PostCheckState createState() => _PostCheckState();
}

class _PostCheckState extends State<PostCheck> {
  User _currentUser;
  @override
  void initState() {
    super.initState();
    if (widget.currentUser != null) {
      _currentUser = widget.currentUser;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          'New Check',
          style: TextStyle(
            color: Colors.grey[700],
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
                ],
              ),
            ),
            Container(
              child: TextFormField(
                maxLines: 15,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(5.0),
                ),
              ),
            ),
            Row(),
            Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {},
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
                      onPressed: () {},
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
            ),
          ],
        ),
      ),
    );
  }
}
