import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  final String initValue;
  final Color borederColor;
  SearchBox({this.initValue = "", this.borederColor});
  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final _searchController = TextEditingController();
  bool _hasText = false;

  void _searchProducts(String input) {}

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
                  prefixIcon: Icon(Icons.search),
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
                onPressed: () {
                  //TODO implement pick image search
                },
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