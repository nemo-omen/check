import 'dart:async';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:check/src/models/user.dart';
import 'package:check/src/ui/views/home.dart';
import 'package:check/src/ui/widgets/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart'
    as Im; //aliasing this si it doesn't conflict with vars
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class EditProfile extends StatefulWidget {
  final String currentUserId;
  EditProfile({this.currentUserId});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // text field controllers
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  File file;
  String imageId = Uuid().v4();

  String newProfilePhotoUrl;

  User user;

  // keep track of whether page is awaiting results
  bool isLoading = false;

  // keep track of whether the bio field is validated
  bool _bioValid = true;
  // keep track of whether the displayName field is valid
  bool _displayNameValid = true;
  // keep track of whether profile image is uploading
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    // fetch the user and init state with result
    getUser();
  }

  getUser() async {
    setState(() {
      // since we are fetching a user, the page is now loading
      isLoading = true;
    });
    // usersRef is available because we imported Home(), where the usersRef object lives
    DocumentSnapshot doc = await usersRef.document(widget.currentUserId).get();
    user = User.fromDocument(doc);
    displayNameController.text = user.displayName;
    bioController.text = user.bio;
    setState(() {
      isLoading = false;
    });
  }

  Column buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            'Display Name',
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey,
            ),
          ),
        ),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
            hintText: 'Update display name',
            errorText: _displayNameValid ? null : 'Needs to be longer...',
          ),
        ),
      ],
    );
  }

  Column buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            'Bio',
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey,
            ),
          ),
        ),
        TextField(
          controller: bioController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Update bio',
            errorText: _bioValid ? null : 'That\'s too short...',
          ),
        ),
      ],
    );
  }

  // call this when user pressed 'Update' button
  updateProfileData() {
    setState(() {
      // if either displayName or bio fields are empty or have fewer than three characters
      // set their validity flags to false
      if (bioController.text.trim().length < 3 ||
          bioController.text.trim().isEmpty ||
          bioController.text.trim().length > 240) {
        _bioValid = false;
      } else {
        _bioValid = true;
      }

      if (displayNameController.text.trim().length < 3 ||
          displayNameController.text.trim().isEmpty) {
        _displayNameValid = false;
      } else {
        _displayNameValid = true;
      }
    });
    // now, if both validity flags are true, proceed to submit changes
    if (_displayNameValid && _bioValid) {
      usersRef.document(widget.currentUserId).updateData({
        'displayName': displayNameController.text,
        'bio': bioController.text,
        'photoUrl':
            newProfilePhotoUrl == null ? user.photoUrl : newProfilePhotoUrl
      });

      SnackBar snackbar = SnackBar(
        content: Text('Successfully updated profile!'),
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);
      // send the value of userName back to home to be used in createFirestoreUser()
      // but wait a second so they see the snackbar!
      Timer(Duration(milliseconds: 1000), () {
        Navigator.pop(context);
      });
    }
  }

  handleTakePhoto() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    if (file == null) {
      return;
    } else {
      setState(() {
        this.file = file;
        showUploadModal();
      });
    }
  }

  handleChoosePhoto() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.file = file;
    });
    showUploadModal();
  }

  // firebase has a pretty small file limit. Compress your image!
  compressImage() async {
    // first, get a reference to temp directory
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    // read the image using the dart/image package
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    // compress the image & encode as .jpg, writing to the temp directory
    final compressedImage = File('$path/image_$imageId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 80));
    // finally, replace the original variable reference with a reference to the compressed file
    setState(() {
      file = compressedImage;
    });
  }

  handlePhotoSubmit() async {
    setState(() {
      isLoading = true;
    });
    await compressImage();
    String mediaUrl = await uploadImage(file);
    setState(() {
      newProfilePhotoUrl = mediaUrl;
      isLoading = false;
    });
    Navigator.pop(context);
  }

  Future<String> uploadImage(imageFile) async {
    StorageUploadTask uploadTask =
        storageRef.child('profile_$imageId.jpg').putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  // setUserPhoto() {
  //   setState(() {
  //     user.photoUrl = newProfilePhotoUrl;
  //   });
  // }

  showUploadModal() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Colors.blueGrey[900],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  height: 300,
                  child: Image.file(
                    file,
                    fit: BoxFit.cover,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: FlatButton(
                        onPressed: () {},
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.grey[100]),
                        ),
                      ),
                    ),
                    Container(
                        child: FlatButton(
                      onPressed: () {
                        handlePhotoSubmit();
                      },
                      child: Text(
                        'Set Photo',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )),
                  ],
                )
              ],
            ),
          );
        });
  }

  selectImage(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text('Change Profile Picture'),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('Photo with Camera'),
              onPressed: handleTakePhoto,
            ),
            SimpleDialogOption(
                child: Text('Image from Gallery'),
                onPressed: handleChoosePhoto),
            SimpleDialogOption(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontFamily: 'IBM Plex Sans',
            fontSize: 30.0,
            fontWeight: FontWeight.w200,
            color: Theme.of(context).primaryColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? circularProgress()
          : ListView(
              children: <Widget>[
                Container(
                    child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        top: 16.0,
                        bottom: 8.0,
                      ),
                      child: GestureDetector(
                        onTap: () => selectImage(context),
                        child: Badge(
                          position: BadgePosition(bottom: 0, right: 0),
                          badgeContent: Icon(FlutterIcons.camera_ant,
                              color: Colors.white),
                          badgeColor:
                              Theme.of(context).primaryColor.withOpacity(0.4),
                          child: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                newProfilePhotoUrl == null
                                    ? user.photoUrl
                                    : newProfilePhotoUrl),
                            backgroundColor: Colors.grey,
                            radius: 60.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          buildDisplayNameField(),
                          buildBioField(),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                FlatButton.icon(
                                  label: Text(
                                    'Update',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  icon: Icon(
                                    FlutterIcons.update_mdi,
                                    color: Colors.white,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  color: Colors.green,
                                  onPressed: updateProfileData,
                                ),
                                FlatButton.icon(
                                  label: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  icon: Icon(
                                    FlutterIcons.cancel_mdi,
                                    color: Colors.white,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  color: Colors.red[400],
                                  onPressed: () {
                                    print('Cancel update');
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
              ],
            ),
    );
  }
}
