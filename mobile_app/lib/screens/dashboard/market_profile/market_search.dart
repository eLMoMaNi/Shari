import 'package:flutter/material.dart';

import '../../../providers/current_market.dart';
import '../../../screens/search_screen.dart';

class MarketSearch extends StatelessWidget {
  final CurrentMarket currentMarket;
  MarketSearch(this.currentMarket);

  @override
  Widget build(BuildContext context) {
    return SearchScreen(
      color: currentMarket.details.theme.primaryColor,
      marktId: currentMarket.marketId,
    );
  }
}
