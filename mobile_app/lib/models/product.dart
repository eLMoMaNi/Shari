import 'package:flutter/foundation.dart';

class Product {
  final String title;
  final String description;
  final double price;
  final String featuredPic;
  final List<String> pictures;
  final String category;
  final String subCategory;
  final List<String> tags;
  //serverside properties
  final String id;
  final String date;
  final String marketId;
  final double rating;

  ///create product by passing properties
  ///
  ///this constructor is used to pass
  ///product created by market owner
  Product(
      {@required this.title,
      @required this.description,
      @required this.price,
      @required this.pictures,
      @required this.featuredPic,
      @required this.category,
      @required this.subCategory,
      @required this.tags,
      this.id,
      this.date,
      this.marketId,
      this.rating});

  //load location from server

  ///create a product from JSON
  ///
  ///The json MUST be decoded. this constructor used
  ///typically to load product from server
  Product.fromJSON(Map<String, dynamic> json)
      : title = json["title"] ?? "unknow",
        description = json["description"] ?? "",
        price = json["price"] ?? 0,
        pictures = json["pics"] as List<String>,
        featuredPic = json["wall_pic"] ?? "https://via.placeholder.com/150",
        category = json["mclass"] ?? "",
        subCategory = json["sclass"] ?? "",
        tags = json["tags"]?.cast<String>(),
        id = json["id"]?.toString() ?? "0",
        date = json["created_at"] ?? "",
        marketId = json["market"]?.toString() ?? "0",
        rating = json["rating"] ?? 0.0;
}
