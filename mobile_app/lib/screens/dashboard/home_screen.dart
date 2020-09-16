import 'package:flutter/material.dart';

import '../../widgets/category_card.dart';
import '../../widgets/search_box.dart';

const List<Map<String, dynamic>> _categories = const [
  const {"category": "Food", "color": Colors.red, "icon": Icons.restaurant},
  const {
    "category": "Grocery",
    "color": Colors.green,
    "icon": Icons.local_grocery_store
  },
  const {
    "category": "Clothes",
    "color": Colors.purple,
    "icon": Icons.design_services
  },
  const {
    "category": "Handicraft",
    "color": Colors.pink,
    "icon": Icons.handyman
  },
  const {
    "category": "Pharmacies",
    "color": Colors.orange,
    "icon": Icons.local_pharmacy
  },
  const {"category": "Other", "color": Colors.grey, "icon": Icons.waves},
];

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(20),
      // shrinkWrap: true,
      children: [
        Container(
          child: SearchBox(),
        ),
        SizedBox(
          height: 20,
        ),
        GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 15),
            primary: false,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: _categories
                .map((cate) =>
                    CategoryCard(cate["category"], cate["icon"], cate["color"]))
                .toList()),
      ],
    );
  }
}
