import 'package:flutter/material.dart';

import '../models/message_exception.dart';

void showError(BuildContext context, Exception error) {
  String msg;
  if (error is MessageException)
    msg = error.message;
  else
    msg = "Something went wrong...";
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
            title: Container(
              child: Text(
                "Error",
                style: TextStyle(color: Theme.of(context).errorColor),
              ),
            ),
            content: Text(msg),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Okay"))
            ],
          ));
}
