import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String _category;
  final IconData _icon;
  final MaterialColor _color;
  CategoryCard(this._category, this._icon, this._color);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      //ClipRRect is used to fix InkWell ink.
      borderRadius: BorderRadius.circular(60),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              gradient: RadialGradient(colors: [_color[200], _color[300]]),
            ),
            child: Center(
              child: Text(_category),
            ),
          ),
          Positioned.fill(
              child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                //TODO implement results screen
              },
            ),
          ))
        ],
      ),
    );
  }
}
