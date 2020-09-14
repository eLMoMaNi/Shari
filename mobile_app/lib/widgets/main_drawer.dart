import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import './profile_drawer_card.dart';

const double _iconsSize = 35;

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: [
            Container(
              //?Status bar color
              height: MediaQuery.of(context).padding.top,
              color: Theme.of(context).accentColor,
            ),
            Expanded(
              child: Column(
                children: [
                  ProfileDrawerCard(),
                  ListTile(
                    leading: Icon(Icons.message, size: _iconsSize),
                    title: Text("Messages"),
                    subtitle: Text("you have unread messages"),
                    //TODO implement navigators
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.store, size: _iconsSize),
                    title: Text("My market"),
                    subtitle: Text("Create your market"),
                    //Todo
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.bookmark, size: _iconsSize),
                    title: Text("Bookmarks"),
                    //Todo
                    onTap: () {},
                  ),
                  Expanded(child: Container()),
                  ListTile(
                    leading: Icon(Icons.logout, size: _iconsSize),
                    title: Text("Logout"),
                    //Todo
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            //
                            return AlertDialog(
                              content:
                                  Text("Are you sure you want to logout ?"),
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      //this push to Loginscreen and clear the stack
                                      //idk how it exactly works, so DON'T Touch
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              LoginScreen.route, (r) => false);
                                    },
                                    child: Text(
                                      "Logout",
                                      style: TextStyle(
                                          color: Theme.of(context).errorColor),
                                    )),
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Stay logged in",
                                    )),
                              ],
                            );
                          });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
