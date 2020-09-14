import 'package:Shari/screens/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ShariApp());
}

class ShariApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.blueGrey,
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                  fontFamily: "Tajawal",
                  fontWeight: FontWeight.w600,
                  fontSize: 26,
                  color: Colors.white),
              bodyText2: TextStyle(
                fontFamily: "Tajawal",
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              //
            ),
      ),
      home: // DashboardScreen(),
          LoginScreen(),
      routes: {
        "/login": (_) => LoginScreen(),
      },
    );
  }
}
