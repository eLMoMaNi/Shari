import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../models/product.dart';
import '../../../../providers/current_market.dart';
import '../../../../providers/current_user.dart';
//

class SProductListCard extends StatelessWidget {
  final host = "192.168.1.7:8000"; //TOCHANGE
  final CurrentMarket currentMarket;
  SProductListCard(this.currentMarket);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 35),
      height: 200,
      child: Card(
        elevation: 10,
        margin: EdgeInsets.only(bottom: 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Recent",
                    style: TextStyle(
                      fontFamily: "Comfortaa",
                      fontSize: 24,
                      color: currentMarket.details.theme.primaryColor,
                    ),
                  ),
                  Divider(
                    thickness: 2,
                    endIndent: 100,
                    indent: 100,
                    color: currentMarket.details.theme.accentColor,
                  ),
                ],
              ),
            ),
            FutureBuilder<List<Product>>(
              future: Provider.of<CurrentUser>(context, listen: false)
                  .fetchProducts(
                      marketId: currentMarket.marketId,
                      ordering: "-created_at"),
              builder: (context, snap) {
                if (snap.hasData) {
                  return Container(
                    //  width: double.infinity,
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: snap.data
                          .map((e) => Container(
                                height: 100,
                                width: 100,
                                child: Card(
                                  //
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 70,
                                        width: 100,
                                        child: Image.network(e.featuredPic,
                                            fit: BoxFit.cover),
                                      ),
                                      Text(e.title)
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
