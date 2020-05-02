import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  AppBar buildSearchField() {
    return AppBar(
      primary: false,
      backgroundColor: Colors.blue[200],
      elevation: 0.0,
      bottomOpacity: 0.25,
      title: TextFormField(
        decoration: InputDecoration(
          hintText: 'Search',
          filled: false,
          prefixIcon: Icon(
            FlutterIcons.account_box_mdi,
            size: 28.0,
            color: Colors.white,
          ),
          suffixIcon: IconButton(
            icon: Icon(FlutterIcons.close_ant),
            onPressed: () => print('cleared'),
          ),
        ),
      ),
    );
  }

  buildNoContent() {
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Icon(
              FlutterIcons.search1_ant,
              color: Colors.grey[200],
              size: 200.0,
            ),
            Text(
              'Find Users',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 60.0,
                fontWeight: FontWeight.w200,
                color: Theme.of(context).accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: buildSearchField(),
      body: buildNoContent(),
    );
  }
}

class UserResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('User Result');
  }
}
