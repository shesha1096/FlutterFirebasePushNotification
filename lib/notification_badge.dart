import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget
{
  final int notificationCount;

  NotificationBadge(this.notificationCount);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.orange,
        shape: BoxShape.circle
      ),
      child: Padding(padding: EdgeInsets.all(8.0),
      child: Text("$notificationCount", style: TextStyle(
        color: Colors.white,
        fontSize: 20.0
      ),),),
    );
  }

}