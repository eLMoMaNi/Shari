import 'package:flutter/material.dart';

import 'package:dotted_border/dotted_border.dart';

import '../../../../providers/current_market.dart';

class SEmptyWidget extends StatelessWidget {
  final CurrentMarket currentMarket;
  SEmptyWidget(this.currentMarket);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 0),
      child: DottedBorder(
        color: currentMarket.details.theme.accentColor,
        strokeCap: StrokeCap.square,
        strokeWidth: 2,
        dashPattern: <double>[10],
        child: Container(
          height: 200,
          child: Center(
            child: InkWell(
              onTap: () {
                //TODO show dialog with available widgets
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text(
                            "Widgets are not available currently :(",
                            style: TextStyle(color: Colors.blue),
                          ),
                          actions: [
                            FlatButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text("Ok"))
                          ],
                        ));
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(1.5),
                  child: DottedBorder(
                    //todo change theme provider
                    color: currentMarket.details.theme.accentColor,
                    strokeCap: StrokeCap.square,
                    strokeWidth: 2,
                    dashPattern: <double>[20.333, 20.333],
                    child: Container(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: Icon(
                          Icons.add,
                          color: currentMarket.details.theme.accentColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
