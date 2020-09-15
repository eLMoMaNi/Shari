import 'dart:convert' as convert;
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/message_exception.dart';
import '../providers/current_market.dart';
import '../widgets/show_error.dart';

class Location {
  String country;
  String city;
  String address;
  String map;
  Location({
    this.country = "unknown",
    this.city = "unknown",
    this.address = "unknown",
    this.map = "unknown",
  });
  //load location from server

  ///create a location from JSON
  ///
  ///The json MUST be decoded.
  Location.fromJSON(Map<String, String> json)
      : country = json["country"] ?? "unknown",
        city = json["city"] ?? "unknown",
        address = json["address"] ?? "unknown",
        map = json["map"] ?? "unknown";
}

class ShariTheme {
  //TODO implement ShariTheme
  ///the layout used for market homepage
  ///
  ///this contains the structre for the market
  ///profile. layout could be nested.
  Color primaryColor;
  Color accentColor;
  //? should I use enum for layout
  List<Map<String, dynamic>> layout;
  ShariTheme(
      {this.primaryColor = Colors.blue,
      this.accentColor = Colors.blueGrey,
      this.layout});

  //TODO implement loading from server
  ShariTheme.fromJSON(Map<String, dynamic> json)
      //the color will be loaded as ARGB hexadecimal
      : primaryColor = json["primaryColor"] == null
            ? Colors.blue
            : Color(int.parse(json["primaryColor"])),
        accentColor = json["accentColor"] == null
            ? Colors.blueGrey
            : Color(int.parse(json["accentColor"])),
        layout = json["layout"]?.cast<Map<String, dynamic>>();
}

class Market {
  final String name;
  final String bio;
  final String number;

  final String profilePicture;
  final String wallpaper;
  final List<String> categories;
  Location location;
  ShariTheme theme;
  //serverside variables
  final String id;
  final String date;
  final String userId;
  final double rating;
  static String host = "http://192.168.1.7:8000"; //TOCHANGE
  static String url = "/api/market";

  ///create market by passing properties
  ///
  ///this constructor is used to pass
  ///market created by a user
  Market(
      {@required this.name,
      @required this.bio,
      @required this.number,
      @required this.location,
      @required this.profilePicture,
      @required this.wallpaper,
      @required this.categories,
      this.id,
      this.date,
      this.userId,
      this.rating}) {
    //users will always get default theme when they create a market
    this.theme = ShariTheme();
  }

  //load market from server

  ///create a market from JSON
  ///
  ///The json MUST be decoded. this constructor used
  ///typically to load market from server
  Market.fromJSON(Map<String, dynamic> json)
      : name = json["name"] ?? "unknown",
        bio = json["bio"] ?? "",
        number = json["number"]?.toString() ?? "unknown",
        location =
            Location.fromJSON(Map<String, String>.from(json["location"] ?? {})),
        profilePicture = json["pic"] ?? "https://via.placeholder.com/150",
        wallpaper = json["wall_pic"] ?? "https://via.placeholder.com/350x150",
        categories = json["mclass"]?.cast<String>() ?? ["Other"],
        //todo change layout to theme in serverside
        theme = ShariTheme.fromJSON(json["layout"] ?? {}),
        id = json["id"]?.toString() ?? "1",
        date = json["created_at"] ?? "unkown",
        userId = json["user"]?.toString() ?? "1",
        rating = json["rating"] ?? 0;

  ///return market details as a map
  ///
  ///you must send userId and currentUser token.
  ///`userId` must follow the server specification
  static Future<Market> getMarketbyId(
      String marketId, BuildContext context) async {
    //get token
    var headers = Provider.of<CurrentMarket>(context).headers;
    var res = await http
        .get("$host$url/$marketId", headers: headers)
        .catchError((_) => showError(
            context,
            MessageException(
                "Something went wrong, check your internet connection")));
    Map<String, dynamic> body =
        convert.json.decode(convert.utf8.decode(res.bodyBytes));
    var market = Market.fromJSON(body);
    return market;
  }
}
