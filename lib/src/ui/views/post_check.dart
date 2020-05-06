import 'package:cached_network_image/cached_network_image.dart';
import 'package:check/src/models/user.dart';
import 'package:check/src/models/status_types.dart';
import 'package:check/src/ui/widgets/status_badge.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

import 'home.dart';

// Todo: Add geolocation

// final checksRef = Firestore.instance.collection('checks');
// final DateTime timestamp = DateTime.now();

class PostCheck extends StatefulWidget {
  final User currentUser;
  PostCheck({this.currentUser});
  @override
  _PostCheckState createState() => _PostCheckState();
}

class _PostCheckState extends State<PostCheck> {
  String selectedStatus;
  String checkMessage;
  final _checkFormKey = GlobalKey<FormState>();
  TextEditingController _checkController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  User _currentUser;
  String currentLocation;
  String checkId = Uuid().v4();

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

  setLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    // String completeAddress =
    //     '${placemark.subThoroughfare}, ${placemark.thoroughfare}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.postalCode}, ${placemark.country}';
    String formattedAddress =
        '${placemark.locality}, ${placemark.administrativeArea}';
    setState(() {
      currentLocation = formattedAddress;
    });
  }

  submit(value) {
    checkMessage = value;
    // print(
    //     '${_currentUser.displayName}: Feeling $selectedStatus, Message: $checkMessage');
    _checkController.clear();
    createFirestoreCheck();
    setState(() {
      selectedStatus = null;
      currentLocation = null;
      checkId = Uuid().v4();
    });
    Navigator.pop(context);
  }

  createFirestoreCheck() async {
    checksRef
        .document(widget.currentUser.id)
        .collection('userPosts')
        .document(checkId)
        .setData({
      'checkId': checkId,
      'ownerId': widget.currentUser.id,
      'displayName': widget.currentUser.displayName,
      'userName': widget.currentUser.userName,
      'mediaUrl': '',
      'status': selectedStatus,
      'message': checkMessage,
      'location': currentLocation,
      'timestamp': timestamp,
      'likes': {},
      'comments': {},
    });
  }

  @override
  Widget build(BuildContext context) {
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
          'New Check In',
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 15.0),
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
                      child: StatusBadge(status: selectedStatus),
                      elevation: 1.0,
                    ),
                  ),
                  // Container(
                  //   child: StatusBadge(status: selectedStatus),
                  // ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: FlatButton.icon(
                      label: Text(
                        currentLocation == null
                            ? 'Add location'
                            : currentLocation,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      // color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      icon: Icon(
                        Icons.my_location,
                        color: Theme.of(context).primaryColor,
                        size: 20.0,
                      ),
                      onPressed: setLocation,
                    ),
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
                  maxLines: 5,
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
