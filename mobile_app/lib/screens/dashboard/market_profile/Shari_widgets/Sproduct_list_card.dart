import 'package:Shari/screens/product_screen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../models/product.dart';
import '../../../../providers/current_market.dart';
import '../../../../providers/current_user.dart';
//

class SProductListCard extends StatelessWidget {
  final CurrentMarket currentMarket;
  SProductListCard(this.currentMarket);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 35),
      height: 300,
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
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: snap.data
                          .map((e) => InkWell(
                                onTap: () => Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (_) => ProductScreen(
                                              e,
                                              primaryColor: currentMarket
                                                  .details.theme.primaryColor,
                                              accentColor: currentMarket
                                                  .details.theme.accentColor,
                                            ))),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  child: Card(
                                    //
                                    elevation: 5,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 70,
                                          width: 100,
                                          child: Image.network(
                                            e.featuredPic,
                                            fit: BoxFit.cover,
                                            cacheHeight: 70,
                                            //cacheWidth: 100,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          e.title,
                                          style: TextStyle(
                                            fontFamily: "Tajawal",
                                            color: currentMarket
                                                .details.theme.primaryColor,
                                          ),
                                          overflow: TextOverflow.fade,
                                          maxLines: 3,
                                          textAlign: TextAlign.center,
                                        ),
                                        Expanded(
                                          child: Container(),
                                        ),
                                        Chip(
                                          label: Text(
                                            "${e.price}",
                                            style: TextStyle(
                                                fontFamily: "Comfortaa"),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          backgroundColor: currentMarket
                                              .details.theme.accentColor,
                                        )
                                      ],
                                    ),
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
