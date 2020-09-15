import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../models/message_exception.dart';
import '../models/product.dart';
import './current_user.dart';
import '../models/market.dart';

class CurrentMarket with ChangeNotifier {
  String token;
  Market details;
  bool hasMarket = false;
  String marketId;
  CurrentMarket(this.token);

  final String host = "https://shari-amazon.tk"; //TOCHANGE
  final String url = "/api/market";

  get headers {
    return {"Authorization": "Token $token"};
  }

  ///updates the currentMarket provider
  ///
  ///if the user has no market it dose nothing and return flase.
  ///else it return true and update the provider's `marketId` and `details`
  Future<bool> update() async {
    try {
      final res = await http.get("$host$url/myprofile", headers: headers);
      //check if page not found (user has no market)
      if (res.statusCode == 404) {
        this.hasMarket = false;
        return false;
      }
      Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
      //check if user has a market
      if (body["id"] != null) {
        _fetchDetails(body);
        return true;
      }

      //otherwise there must be an error
      throw MessageException("Something went wrong");
    } catch (error) {
      throw error;
    }
  }

  ///This Only update locally because PATCH is not ready yet in server-side
  Future<void> editTheme({
    Color primaryColor,
    Color accentColor,
    List<Map<String, dynamic>> layout,
  }) async {
    //TODO edit my market to update server
    //This Only update locally
    var newTheme = ShariTheme();
    //Change colors:

    // if primary color not passed, keep original //? there're maybe better approachs
    newTheme.primaryColor =
        (primaryColor != null) ? primaryColor : details.theme.primaryColor;
    newTheme.accentColor =
        (accentColor != null) ? accentColor : details.theme.accentColor;
    details.theme = newTheme;

    //Change layout

    notifyListeners();
  }

  Future<void> edit({ShariTheme theme}) async {
    //TODO edit my market
  }

  Future<void> delete() async {
    //TODO delete my market
  }
  Future<void> create() async {
    //TODO create my market
  }

  ///get current market details
  ///
  ///This function should be called only if the user
  ///has a market.
  void _fetchDetails(Map<String, dynamic> body) {
    this.hasMarket = true;

    this.marketId = body["id"]?.toString();
    this.details = Market.fromJSON(body);

    notifyListeners();
  }

  Future<List<Product>> getProducts(BuildContext context) async {
    return Provider.of<CurrentUser>(context, listen: false)
        .fetchProducts(marketId: marketId);
  }
}
