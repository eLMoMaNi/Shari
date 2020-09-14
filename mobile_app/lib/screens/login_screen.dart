import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/message_exception.dart';
import '../providers/current_user.dart';
import '../screens/home_screen.dart';

class LoginScreen extends StatelessWidget {
  static const route = "/login";
  //some dealy to ensure animations
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String> _authUser(
      LoginData data, String action, CurrentUser currentUser) async {
    //this function should return null if login success
    //else return string with error message
    final host = "http://192.168.1.7:8000"; //TOCHANGE
    final _url = "/api/$action";

    try {
      await Future.delayed(loginTime);
      //get response
      final res = await http.post(host + _url,
          body: {"username": data.name, "password": data.password});
      print(res.body);
      //define body type
      Map<String, dynamic> body = json.decode(res.body);

      //if there's any error, use implemented Exception
      if (res.statusCode >= 400) {
        String message = body["error"] ?? "Something went wrong";
        throw MessageException(message);
      }

      //if login success
      currentUser.token = body["token"];
      return null;
    } catch (error) {
      return error.toString();
    }
  }

  Future<String> _recoverPassword(String name) async {
    //TODO recover password
    await Future.delayed(loginTime);

    return "This feature is not implemented yet :(";
  }

  @override
  Widget build(BuildContext context) {
    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
    return FlutterLogin(
      title: '',
      logo: 'assets/images/logo.png',
      messages: LoginMessages(usernameHint: "username"),
      onLogin: (loginData) => _authUser(loginData, "login", currentUser),
      onSignup: (loginData) => _authUser(loginData, "signup", currentUser),
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
