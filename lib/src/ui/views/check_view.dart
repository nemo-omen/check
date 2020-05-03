import 'package:check/src/ui/widgets/header.dart';
import 'package:check/src/ui/widgets/status_badge.dart';
import 'package:check/src/ui/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class CheckView extends StatefulWidget {
  final String friend;
  final String status;
  final String statusMessage;
  final String checkTime;
  final String profileImage;
  CheckView(
      {this.friend,
      this.status,
      this.statusMessage,
      this.checkTime,
      this.profileImage});
  @override
  _CheckViewState createState() => _CheckViewState();
}

class _CheckViewState extends State<CheckView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context,
          isAppTitle: true, titleText: 'Check', removeBackButton: false),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                  child: CircleAvatar(
                    child: UserAvatar(
                      imageURL: widget.profileImage,
                      userName: widget.friend,
                      radius: 50.0,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        widget.friend,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Feeling ',
                            style: TextStyle(
                              height: 1.5,
                            ),
                          ),
                          StatusBadge(status: widget.status),
                          Text(
                            ' ${widget.checkTime}',
                            style: TextStyle(
                              height: 1.5,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                    child: Text(widget.statusMessage),
                  ),
                ),
              ],
            ),
            Row(
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
          ],
        ),
      ),
    );
  }
}
