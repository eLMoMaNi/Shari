import 'package:flutter/material.dart';

class MarketHomeScreen extends StatefulWidget {
  @override
  _MarketHomeScreenState createState() => _MarketHomeScreenState();
}

class _MarketHomeScreenState extends State<MarketHomeScreen> {
  double vh;
  double vw;

  @override
  Widget build(BuildContext context) {
    vh = MediaQuery.of(context).size.height;
    vw = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        //TODO make parallax image appbar + tabs
        title: Text("Market name"),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(8),
          children: [
            Center(child: Text("Element Card")),
            Center(child: Text("Element Card")),
            Center(child: Text("Element Card")),
            Center(child: Text("Element Card")),
          ],
        ),
      ),
    );
  }
}
