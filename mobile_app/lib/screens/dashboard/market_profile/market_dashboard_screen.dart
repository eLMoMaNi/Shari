import 'package:flutter/material.dart';

import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import './market_home.dart';
import './market_search.dart';
import '../../../providers/current_market.dart';

class MarketDashboardScreen extends StatelessWidget {
  final host = "https://shari-amazon.tk"; //TOCHANGE

//check this https://medium.com/@diegoveloper/flutter-collapsing-toolbar-sliver-app-bar-14b858e87abe
  @override
  Widget build(BuildContext context) {
    var vw = MediaQuery.of(context).size.width;
    var vh = MediaQuery.of(context).size.height;
    return FutureBuilder(
        // update the market once each time user press "my market"
        future: Provider.of<CurrentMarket>(context, listen: false).update(),
        builder: (_, snap) {
          if ((snap.hasData && snap.connectionState == ConnectionState.done)) {
            //this will change UI when market changes
            return Consumer<CurrentMarket>(
              builder: (context, currentMarket, ch) => DefaultTabController(
                length: 5,
                child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        backgroundColor:
                            currentMarket.details.theme.primaryColor,
                        title: Text(
                          currentMarket.details.name,
                          style: TextStyle(
                            fontFamily: "Comfortaa",
                            fontSize: 20,
                            //?  background: Paint()..color = Colors.blue,
                            shadows: [
                              Shadow(
                                  color:
                                      currentMarket.details.theme.accentColor,
                                  offset: Offset(2, 2),
                                  blurRadius: 0)
                            ],
                          ),
                        ),
                        centerTitle: true,
                        automaticallyImplyLeading: false,
                        expandedHeight: .35 * vh,
                        floating: false,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                            centerTitle: true,
                            //titlePadding: EdgeInsets.only(bottom: 0),

                            collapseMode: CollapseMode.parallax,
                            background: Stack(
                              children: [
                                Image.network(
                                  currentMarket.details.wallpaper,
                                  // fit: BoxFit.fitWidth,
                                  width: vw,
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(vw),
                                    child: Card(
                                      color: currentMarket
                                          .details.theme.primaryColor,
                                      child: Image.network(
                                        currentMarket.details.profilePicture,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      SliverPersistentHeader(
                        delegate: _SliverAppBarDelegate(
                          TabBar(
                            labelColor: Colors.black87,
                            unselectedLabelColor: Colors.grey,
                            //?isScrollable: true,
                            tabs: [
                              Tab(
                                  icon: Icon(
                                Icons.home,
                                color: currentMarket.details.theme.accentColor,
                              )),
                              Tab(
                                  icon: Icon(
                                FlutterIcons.search_faw,
                                color: currentMarket.details.theme.accentColor,
                              )),
                              Tab(
                                  icon: Icon(
                                Icons.category,
                                color: currentMarket.details.theme.accentColor,
                              )),
                              Tab(
                                  icon: Icon(
                                Icons.local_offer,
                                color: currentMarket.details.theme.accentColor,
                              )),
                              Tab(
                                  icon: Icon(
                                Icons.toc,
                                color: currentMarket.details.theme.accentColor,
                              )),
                            ],
                          ),
                        ),
                        pinned: true,
                      ),
                    ];
                  },
                  body: TabBarView(children: [
                    MarketHomeScreen(currentMarket),
                    MarketSearch(currentMarket),
                    Container(child: Text("3")),
                    Container(child: Text("4")),
                    Container(child: Text("5")),
                  ]),
                ),
              ),
            );
          } else {
            if ((snap.hasError)) {
              //todo hide error details from users
              return Text(snap.error.toString());
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
        });
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }
}
