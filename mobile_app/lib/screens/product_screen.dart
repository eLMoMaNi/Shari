import 'package:flutter/material.dart';

import 'package:flutter_icons/flutter_icons.dart';

import '../models/product.dart';
import '../widgets/rating_widget.dart';

class ProductScreen extends StatelessWidget {
  final Product product;
  ProductScreen(this.product);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {}, child: Icon(FlutterIcons.cart_evi)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1, color: Theme.of(context).accentColor))),
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
                  backgroundColor: Theme.of(context).primaryColor,
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
