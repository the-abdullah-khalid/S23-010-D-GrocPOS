import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../resources/routes/dashboard_feature_cards_routing.dart';
import 'feature_category_card.dart';

class GridFeatureTilesBuilder extends StatelessWidget {
  const GridFeatureTilesBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const ScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.9,
          crossAxisSpacing: 20,
          mainAxisSpacing: 22),
      itemBuilder: (context, index) {
        var featureCard = kFeatureCategoryList[index];
        return FeatureCategoryCard(featureCard['title']!, () {},
            featureCard['icon']!, featureCard['routeName']!);
      },
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      shrinkWrap: true,
      itemCount: kFeatureCategoryList.length,
    );
  }
}
