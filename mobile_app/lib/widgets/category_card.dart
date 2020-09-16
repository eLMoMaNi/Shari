import 'package:flutter/material.dart';

import '../screens/search_screen.dart';

class CategoryCard extends StatelessWidget {
  final String _category;
  final IconData _icon;
  final MaterialColor _color;
  const CategoryCard(this._category, this._icon, this._color);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: _color,
                image: (_category == "Other")
                    ? null
                    : DecorationImage(
                        image: AssetImage(
                            "assets/images/categories/$_category.jpg"),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.20),
                          BlendMode.srcOver,
                        )),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      offset: Offset(1, 1),
                      blurRadius: 10,
                      spreadRadius: -2)
                ]),
            child: Center(
              child: Text(
                _category,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Comfortaa",
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    shadows: [
                      Shadow(
                        color: _color,
                        offset: Offset(0, 1),
                        blurRadius: 0,
                      )
                    ]),
              ),
            ),
          ),
          Positioned.fill(
              child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: _color,
              onTap: () {
                Navigator.of(context).pushNamed(SearchScreen.route, arguments: {
                  "categories": [_category],
                  "color": _color
                });
              },
            ),
          )),
          // Container(
          //   decoration: BoxDecoration(
          //     gradient: RadialGradient(colors: [
          //       _color[200].withAlpha(100),
          //       _color[300].withAlpha(100)
          //     ]),
          //  ),
          //)
        ],
      ),
    );
  }
}
