import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../screens/search_screen.dart';

class SearchBox extends StatefulWidget {
  final bool withBackButton;
  final String initValue;
  final Map<String, dynamic> initArgs;

  final Color borederColor;
  SearchBox({
    this.initValue = "",
    this.borederColor,
    this.initArgs = const {},
    this.withBackButton = false,
  });
  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final _searchController = TextEditingController();
  bool _hasText = false;
  final picker = ImagePicker();
  File _pickedImage;

  Future pickImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.camera, maxHeight: 480, maxWidth: 640);
    if (pickedFile == null) return;

    _pickedImage = File(pickedFile.path);
    var imageBytes = _pickedImage.readAsBytesSync();
    String imageB64 = base64Encode(imageBytes);
    var res = await http.post(
        "https://bf7we8up0e.execute-api.eu-central-1.amazonaws.com/alpha/getFeatures2",
        body: json.encode({
          //
          "img": imageB64,
        }));
    if (res.body == null) return;
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              //
              content: Container(
                width: MediaQuery.of(context).size.width * .65,
                height: MediaQuery.of(context).size.height * .50,
                child: ListView(
                  children: ((json.decode(res.body) as List).cast<String>())
                      .map((e) => Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(e),
                          ))
                      .toList(),
                ),
              ),
            ));
  }

  void _searchProducts(String input) {
    var args = {...widget.initArgs};
    args["searchText"] = input;
    if (widget.withBackButton) {
      Navigator.of(context)
          .pushReplacementNamed(SearchScreen.route, arguments: args);
    } else {
      Navigator.of(context).pushNamed(SearchScreen.route, arguments: args);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.initValue != "") {
      _searchController.text = widget.initValue;
      _hasText = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Container(
        height: 50,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  prefixIcon: (widget.withBackButton)
                      ? BackButton()
                      : Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: widget.borederColor ??
                            Theme.of(context).primaryColor,
                      )),
                  hintText: "Search for a product",
                  suffixIcon: (_hasText)
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.grey,
                          ),
                          onPressed: () => setState(() {
                            _searchController.clear();
                            _hasText = false;
                          }),
                        )
                      : null,
                ),
                onChanged: (_) => setState(() {
                  _hasText = _searchController.text.isNotEmpty;
                }),
                onEditingComplete: () =>
                    _searchProducts(_searchController.text),
                //    onSubmitted: (_) => _searchProducts(_searchController.text),
              ),
            ),
            IconButton(
                onPressed: () => pickImage(),
                icon: Icon(
                  Icons.camera_enhance,
                  color: widget.borederColor ?? Theme.of(context).accentColor,
                  size: 28,
                ))
          ],
        ),
      ),
    );
  }
}
