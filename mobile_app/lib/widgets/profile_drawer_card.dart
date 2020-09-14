import 'package:flutter/material.dart';

class ProfileDrawerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //TODO implement the dynamic look of profile card
    return ListTile(
      leading: Icon(Icons.person_outline_rounded),
      title: Text("Profile"),
      onTap: () {
        //TODO go to profile page
      },
    );
  }
}
