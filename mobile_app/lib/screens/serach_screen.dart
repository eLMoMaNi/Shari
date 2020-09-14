import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/current_user.dart';
import '../widgets/product_card.dart';
import '../widgets/search_box.dart';

class SearchScreen extends StatefulWidget {
  static const route = "/search";
  final String marktId;
  final Color color;
  //TODO convert this screen from args based to constructor based
  //this code looks ugly :/
  SearchScreen({this.marktId, this.color});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchText;
  List<String> _categories;
  List<String> _tags;
  String _marketId;
  String _query;
  Color _color;
  //? bool _isInit=false;

  //properties used for lazy loading
  final host = "http://192.168.1.7:8000";
  final url = "/api/search"; //TOCHANGE
  int _currentPage = 1;
  List<Product> _results = <Product>[];
  bool _isLoading = true;
  bool _hasMore = true;

  void _loadProducts() {
    _isLoading = true;
    print("PAGE:::$_currentPage");
    Provider.of<CurrentUser>(context, listen: false)
        .fetchProducts(
            categories: _categories,
            page: _currentPage,
            searchText: _searchText,
            marketId: _marketId ?? "")
        .then((List<Product> fetchedList) {
      //if fetch returned "no results"
      if (fetchedList.isEmpty) {
        setState(() {
          //TODO add end of results card
          _isLoading = false;
          _hasMore = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _results.addAll(fetchedList);
        });
      }
    });
    _currentPage += 1;
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _hasMore = true;
  }

  @override
  void didChangeDependencies() {
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments ?? {};
    _searchText = args["searchText"] ?? "";
    _categories = args["categories"];
    print("CAAAAAAAAAT\n\n\n${_categories}");

    _tags = args["tags"];
    _marketId = widget.marktId;
    _query = args["query"];
    _color = args["color"] ?? widget.color;
    print(_color);
    print("SearCHING FOR $_searchText");
    _loadProducts();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("Search for $_searchText\n cates:$_categories");
    return Scaffold(
        body: Column(
      children: [
        Container(
          height: MediaQuery.of(context).padding.top,
          color: _color,
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBox(
              withBackButton: true,
              initValue: _searchText,
              borederColor: _color,
              initArgs: {
                "categories": _categories,
                "color": _color,
                "marketId": _marketId
              },
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            // if there's more, add 1 to the length for the loading indicator
            itemCount: _hasMore ? _results.length + 1 : _results.length,
            itemBuilder: (_, index) {
              // debuging the builder
              if (index >= _results.length) {
                // Don't trigger if one async loading is already under way
                if (!_isLoading) {
                  print("Loading next page");
                  _loadProducts();
                }
                return Center(
                  child: SizedBox(
                    child: CircularProgressIndicator(),
                    height: 30,
                    width: 30,
                  ),
                );
              }
              print("building $index");
              return Center(child: ProductCard(_results[index], _color));
            },
          ),
        ),
      ],
    ));
  }
}