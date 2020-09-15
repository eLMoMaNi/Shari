import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import '../models/message_exception.dart';
import '../models/product.dart';
import '../models/user.dart';

class CurrentUser with ChangeNotifier {
  User details;
  String token;
  CurrentUser();
  //TOCHANGE
  final host = "https://shari-amazon.tk";
  final url = "/api/user/myprofile";

  get headers {
    return {"Authorization": "Token $token"};
  }

  Future<void> update() async {
    //
    final res = await http.get("$host$url", headers: headers);
    Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
    details = User.fromJSON(body);
    notifyListeners();
    return;
  }

  Future<void> edit() async {
    //TODO edit my user
    throw MessageException("This Feature is not implemented yet");
  }

  Future<List<Product>> fetchProducts(
      {List<String> categories,
      int page = 1,
      String searchText = "",
      String marketId = "",
      String ordering = ""}) async {
    print('SEACHING>>>>');
    //converting categories list to query
    String categoriesQuery =
        categories?.reduce((value, element) => value + "," + element) ?? "";

    var res = await http.get(
      "$host/api/search?search=$searchText&mclass=$categoriesQuery&page=$page&market=$marketId&ordering=$ordering",
      headers: headers,
    );
    print(res.request);
    if (res.statusCode == 404) {
      //? if entered empty page, this could be deleted
      return [];
    } else if (res.statusCode >= 400) {
      throw MessageException(
          "Something went wrong, check your internet connection");
    }
    Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
    if (body["count"] == 0) return []; //check if there's no results
    List<Product> results = (body["results"] as List<dynamic>).map((e) {
      return Product.fromJSON(e as Map<String, dynamic>);
    }).toList();
    print("done sercing ");

    return results;
  }
}
