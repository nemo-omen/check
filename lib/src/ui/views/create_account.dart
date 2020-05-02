import 'dart:async';

import 'package:check/src/ui/widgets/header.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  // supply a form key to hold form state
  final _formKey = GlobalKey<FormState>();

  // this will be what is supplied to the form input
  String userName;

  // And this will be a key for the Welcome message snackbar
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      SnackBar snackbar = SnackBar(
        content: Text('Welcome $userName!'),
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);
      // send the value of userName back to home to be used in createFirestoreUser()
      // but wait a second so they see the snackbar!
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context, userName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context, titleText: 'Create a profile'),
      body: ListView(
        children: <Widget>[
          Container(
              child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 25.0),
                child: Center(
                  child: Text(
                    'Create a username',
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Container(
                  child: Form(
                    // form key will hold values from input for use in submit()
                    key: _formKey,
                    autovalidate: true,
                    child: TextFormField(
                      validator: (value) {
                        if (value.trim().length < 3 || value.isEmpty) {
                          return 'Username is too short';
                        } else if (value.trim().length > 20) {
                          return 'Username is too long.';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) => userName = value,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                        labelStyle: TextStyle(
                          fontSize: 15.0,
                        ),
                        hintText: 'Needs to be at least 3 characters',
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: submit,
                child: Container(
                  height: 50.0,
                  width: 350.0,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  child: Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
