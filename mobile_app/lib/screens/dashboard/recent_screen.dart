import 'package:flutter/material.dart';

class RecentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {},
        child: Center(
          child: Text("Recent"),
        ),
      ),
    );
  }
}
