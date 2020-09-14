import 'package:Shari/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class LoginScreen extends StatelessWidget {
  static const route = "/login";
  //some dealy to ensure animations
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String> _authUser(LoginData data, String action) async {
    //this function should return null if login success
    //else return string with error message

    //read Osama's docs for the API
    //? should I use provider for token
    //TODO check user/pass
    var url = "[api]/$action";
    return null;
  }

  Future<String> _recoverPassword(String name) async {
    //TODO recover password
    await Future.delayed(loginTime);

    return "This feature is not implemented yet :(";
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: '',
      logo: 'assets/images/logo.png',
      messages: LoginMessages(usernameHint: "username"),
      onLogin: (loginData) => _authUser(loginData, "login"),
      onSignup: (loginData) => _authUser(loginData, "signup"),
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
