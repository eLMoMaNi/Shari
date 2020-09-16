import 'package:flutter/material.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../../../models/market.dart';
import '../../../providers/current_market.dart';
import 'Shari_widgets/Sempty_widget.dart';
import 'Shari_widgets/Sproduct_list_card.dart';
import 'Shari_widgets/Srow_widget.dart';

class MarketHomeScreen extends StatefulWidget {
  final CurrentMarket currentMarket;
  MarketHomeScreen(this.currentMarket);
  @override
  _MarketHomeScreenState createState() => _MarketHomeScreenState();
}

class _MarketHomeScreenState extends State<MarketHomeScreen> {
  double vh;
  double vw;

  Future<Color> _pickColor(BuildContext context, Color initColor) {
    Color retColor;

    void updateColor(Color color) {
      initColor = color;
    }

    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: initColor,
            onColorChanged: updateColor,
            showLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('Got it'),
            onPressed: () {
              retColor = initColor;
              Navigator.of(context).pop(retColor); //return picked color
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var currentMarket = widget.currentMarket;
    var marketDetails = currentMarket.details; //shortcut
    var marketTheme = marketDetails.theme; //shortcut
    vh = MediaQuery.of(context).size.height;
    vw = MediaQuery.of(context).size.width;
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.all(8),
        children: [
          buildColorPickers(context, marketTheme, currentMarket),
          SizedBox(height: 20),
          SProductListCard(currentMarket),
          SEmptyWidget(currentMarket),
          SizedBox(
            height: 34,
          ),
          SRow(
            children: [
              SEmptyWidget(currentMarket),
              SEmptyWidget(currentMarket),
              SEmptyWidget(currentMarket),
            ],
          ),
        ],
      ),
    );
  }

  Row buildColorPickers(BuildContext context, ShariTheme marketTheme,
      CurrentMarket currentMarket) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap: () => _pickColor(context, marketTheme.primaryColor)
              .then((color) => currentMarket.editTheme(primaryColor: color)),
          child: Row(
            children: [
              Text(
                "Primary Color",
                style: TextStyle(
                    color: marketTheme.primaryColor,
                    fontSize: 16,
                    fontFamily: "Comfortaa"),
              ),
              Icon(
                FlutterIcons.pencil_circle_mco,
                color: marketTheme.primaryColor,
                size: 20,
              )
            ],
          ),
        ),
        InkWell(
          onTap: () =>
              _pickColor(context, currentMarket.details.theme.accentColor)
                  .then((color) => currentMarket.editTheme(accentColor: color)),
          child: Row(
            children: [
              Text(
                "Accent Color",
                style: TextStyle(
                    color: marketTheme.accentColor,
                    fontSize: 16,
                    fontFamily: "Comfortaa"),
              ),
              Icon(
                FlutterIcons.pencil_circle_mco,
                color: marketTheme.accentColor,
                size: 20,
              )
            ],
          ),
        ),
      ],
    );
  }
}
