import 'package:Shari/screens/dashboard/market_profile/market_dashboard_screen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../screens/dashboard/market_profile/market_home.dart';
import '../../providers/current_market.dart';
import '../../providers/current_user.dart';
import '../../screens/dashboard/bookmarks_screen.dart';
import '../../screens/dashboard/home_screen.dart';
import '../../screens/dashboard/recent_screen.dart';
import '../../screens/dashboard/user_profile_screen.dart';
import '../../widgets/main_drawer.dart';
import '../../widgets/show_error.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Widget> tabs = [
    HomeScreen(),
    RecentScreen(),
    BookmarksScreen(),
    UserProfileScreen(),
  ];
  int _currentTabIdx = 0;
  bool _isInit = false;
  bool _delAppBar = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _isInit = true;
      Provider.of<CurrentUser>(context, listen: false)
          .update()
          .then((value) =>
              Provider.of<CurrentMarket>(context, listen: false).update())
          .catchError((e) => showError(context, e));
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Building\n\n");
    return Scaffold(
      drawer: MainDrawer(),
      appBar: _delAppBar
          ? null
          : AppBar(
              title: Text(
                "Shari",
                //style: Theme.of(context).textTheme.headline6,
              ),
              centerTitle: true,
              actions: [
                IconButton(
                    icon: Icon(Icons.message),
                    onPressed: () {
                      //TODO AWS LEX bot
                    })
              ],
            ),
      body: tabs[_currentTabIdx],
      bottomNavigationBar: Consumer2<CurrentUser, CurrentMarket>(
        builder: (_, currentUser, currentMarket, __) {
          if (currentMarket.hasMarket) tabs[3] = MarketDashboardScreen();
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentTabIdx,
            onTap: (idx) {
              setState(() {
                //delete app bar when going to market profile
                _delAppBar = (idx == 3 && currentMarket.hasMarket);
                _currentTabIdx = idx;
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), title: Text("Home")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.history), title: Text("Recent")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark), title: Text("Bookmarks")),
              BottomNavigationBarItem(
                  icon: Icon(currentMarket.hasMarket
                      ? Icons.storefront
                      : Icons.person),
                  title: Text(
                      currentMarket.hasMarket ? "My Market" : "My Profile")),
            ],
          );
        },
      ),
    );
  }
}
