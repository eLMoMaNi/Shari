import 'package:flutter/material.dart';

import 'package:flutter_icons/flutter_icons.dart';

import '../models/product.dart';
import '../widgets/rating_widget.dart';

class ProductScreen extends StatelessWidget {
  final Product product;
  final Color primaryColor;
  final Color accentColor;
  ProductScreen(this.product,
      {this.primaryColor = Colors.blue, this.accentColor = Colors.blueGrey});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(product.title),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {}, child: Icon(FlutterIcons.cart_evi)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(width: 1, color: accentColor))),
              child: Image.network(
                product.featuredPic,
                fit: BoxFit.fitWidth,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RatingWidget(
                  rating: product.rating,
                  size: 30,
                ),
                Chip(
                  label: Text(
                    "${product.price} JD",
                    style: TextStyle(
                        fontFamily: "Comfortaa",
                        fontSize: 20,
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                  backgroundColor: primaryColor,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              product.description,
              style: TextStyle(
                fontFamily: "Comfortaa",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
