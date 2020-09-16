import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import '../../models/message_exception.dart';
import '../../providers/current_user.dart';
import '../../widgets/show_error.dart';

class UserProfileScreen extends StatefulWidget {
  static const route = "/profile";
  //TODO make this screen receive user Id
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String username;
  String fname;
  String lname;
  String number;
  File picture;
  Map<String, String> values;
  bool _isEditing = false;
  bool _isInit = false;
  //TOCHANGE
  final host = "https://shari-amazon.tk";

  Future<void> _postData() async {
    Provider.of<CurrentUser>(context, listen: false)
        .edit()
        .catchError((e) => showError(context, e));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      Provider.of<CurrentUser>(context, listen: false).update().then((_) {
        //
        var details = Provider.of<CurrentUser>(context, listen: false).details;
        values = {
          "username": details.username,
          "First Name": details.fname,
          "Last Name": details.lname,
          "Mobile Number": details.number,
          "Full Name": details.fname + " " + details.lname,
        };
        setState(() => _isInit = true);
      }).catchError((error) {
        showError(
            context, MessageException("Network Error, check your internet"));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_isInit
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () =>
                  Provider.of<CurrentUser>(context, listen: false).update(),
              child: Consumer<CurrentUser>(
                builder: (_, user, __) {
                  var header = [
                    Container(
                      height: 150,
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).accentColor,
                        minRadius: 100,
                        maxRadius: 100,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 150),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              "${user.details.profilePicture}" ??
                                  "https://via.placeholder.com/150",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        width: 200,
                        child: _getListTile(
                            null, "username", "@" + values["username"],
                            trailing: _isEditing
                                ? IconButton(
                                    icon: Icon(Icons.done_all),
                                    onPressed: () async {
                                      await _postData();
                                      setState(() => _isEditing = false);
                                    })
                                : IconButton(
                                    icon: Icon(FlutterIcons.account_edit_mco),
                                    onPressed: () =>
                                        setState(() => _isEditing = true)))),
                    Divider(),
                    SizedBox(
                      height: 50,
                    ),
                  ];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 50),
                    child: ListView(
                      children: [
                        Column(
                          children: header,
                        ),
                        if (_isEditing)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Expanded(
                                    child: _getListTile(null, "First Name",
                                        values["First Name"])),
                                SizedBox(width: 30),
                                Expanded(
                                    child: _getListTile(null, "Last Name",
                                        values["Last Name"])),
                              ],
                            ),
                          ),
                        if (!_isEditing)
                          _getListTile(
                              Icons.person, "Full Name", values["Full Name"]),
                        _getListTile(Icons.call, "Mobile Number",
                            values["Mobile Number"]),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 50),
                          child: RaisedButton(
                            onPressed: () {
                              //createMarket
                            },
                            child: Text("Create Market",
                                textAlign: TextAlign.center),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _getListTile(IconData icon, String title, String initVal, {trailing}) {
    return ListTile(
      trailing: trailing,
      leading: (icon == null)
          ? null
          : Icon(
              icon,
              size: 50,
            ),
      title: Text(
        title,
        style: TextStyle(fontSize: 16),
      ),
      subtitle: Container(
        child: (_isEditing)
            ? TextFormField(
                initialValue: initVal,
                onChanged: (val) => values[title] = val,
              )
            : Text(initVal),
        height: 20,
      ),
    );
  }
}
