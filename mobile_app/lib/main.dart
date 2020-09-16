import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'package:provider/provider.dart';

import 'screens/dashboard/user_profile_screen.dart';
import 'screens/search_screen.dart';
import 'providers/current_user.dart';
import 'providers/current_market.dart';

void main() {
  runApp(ShariApp());
}

class ShariApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // precache categories background images
    for (String cate in [
      "Food",
      "Grocery",
      "Clothes",
      "Handicraft",
      "Pharmacies"
    ]) precacheImage(AssetImage("assets/images/categories/$cate.jpg"), context);

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => CurrentUser(),
          ),
          ChangeNotifierProxyProvider<CurrentUser, CurrentMarket>(
              create: null,
              update: (_, currentUser, prevMarket) {
                if (prevMarket == null)
                  return CurrentMarket(currentUser.token);
                else {
                  prevMarket.token = currentUser.token;
                  return prevMarket;
                }
              }),
        ],
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Colors.blueGrey,
            textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                      fontFamily: "Tajawal",
                      fontWeight: FontWeight.w600,
                      fontSize: 26,
                      color: Colors.white),
                  bodyText2: TextStyle(
                    fontFamily: "Tajawal",
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  //
                ),
          ),
          home: // DashboardScreen(),
              LoginScreen(),
          routes: {
            "/login": (_) => LoginScreen(),
            "/search": (_) => SearchScreen(),
            "/profile": (_) => UserProfileScreen()
          },
        ));
  }
}
