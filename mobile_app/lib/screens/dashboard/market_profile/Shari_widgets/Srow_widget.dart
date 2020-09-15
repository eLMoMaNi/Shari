import 'package:flutter/material.dart';

///Row handler for Shari widgets
///
///this class put widgets into a row,
///each element takes the same spacing
class SRow extends StatelessWidget {
  final List<Widget> children;
  SRow({this.children});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children
            //put each widget inside expanded
            .map((e) => Expanded(
                  child: Center(child: e),
                ))
            .toList(),
      ),
    );
  }
}
