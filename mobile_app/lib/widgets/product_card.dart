import 'package:flutter/material.dart';

import '../models/market.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Color priceColor;
  ProductCard(this.product, this.priceColor);
  @override
  Widget build(BuildContext context) {
    var vh = MediaQuery.of(context).size.height;
    var vw = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        //TODO make product page
      },
      child: Card(
        elevation: 5,
        child: Container(
          width: double.infinity,
          height: 0.2 * vh,
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.network(
                      product.featuredPic ?? "https://via.placeholder.com/150",
                      fit: vw > 500 ? BoxFit.fitWidth : BoxFit.fitHeight,
                    ),
                  )),
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  //color: Colors.green,
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            product.title,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                          FutureBuilder<Market>(
                            future: product.getMarket(context),
                            builder: (_, snap) {
                              //
                              if (snap.connectionState ==
                                      ConnectionState.done &&
                                  snap.hasData) {
                                return Text(
                                  snap.data.name,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              }
                              if (snap.hasError) print(snap.error);
                              return Container(
                                  width: 10,
                                  height: 10,
                                  child: FittedBox(
                                      child: CircularProgressIndicator()));
                            },
                          ),
                          Container(
                            child: Text(
                              product.description,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black45,
                          spreadRadius: -3,
                          blurRadius: 5,
                          offset: Offset(-8, 0)),
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    // color: Colors.white,
                    width: double.infinity,
                    height: double.infinity,
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: FittedBox(
                                child: Column(
                          children: [
                            Text(
                              "${product.price}",
                              style: TextStyle(
                                  fontFamily: "Comfortaa",
                                  fontWeight: FontWeight.w900,
                                  color: priceColor),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "JD",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: priceColor),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ))),
                      ), //TODO
                    ),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black45,
                            spreadRadius: -3,
                            blurRadius: 0,
                            offset: Offset(0, 0)),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
