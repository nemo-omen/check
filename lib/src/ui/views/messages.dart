import 'package:check/src/ui/widgets/header.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_icons/flutter_icons.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: header(context, titleText: 'Messages'),
      body: Center(
        child: Text('Messages'),
      ),
    );
  }
}
