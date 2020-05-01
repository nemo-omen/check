import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

class StatusBadge extends StatelessWidget {
  String status;

  StatusBadge({this.status});

  Color statusColor(String statusText) {
    switch (statusText) {
      case 'Happy':
        {
          return Colors.orange[200];
        }
        break;
      case 'Sad':
        {
          return Colors.indigo[200];
        }
        break;
      case 'Anxious':
        {
          return Colors.grey[200];
        }
        break;
      case 'Depressed':
        {
          return Colors.deepPurple[200];
        }
        break;
      case 'Meh':
        {
          return Colors.blueGrey[200];
        }
        break;
      case 'Sick':
        {
          return Colors.green[200];
        }
      case 'Angry':
        {
          return Colors.red[200];
        }
        break;
      case 'Okay':
        {
          return Colors.amber[200];
        }
        break;
      case 'Content':
        {
          return Colors.deepOrange[200];
        }
        break;
      case 'Tired':
        {
          return Colors.blueGrey[200];
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Badge(
      badgeContent: Text(this.status),
      badgeColor: statusColor(this.status),
      padding: EdgeInsets.all(2.0),
      shape: BadgeShape.square,
      borderRadius: 5,
      animationType: BadgeAnimationType.fade,
      elevation: 0.0,
    );
  }
}
