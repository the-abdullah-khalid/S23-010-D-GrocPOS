import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeatureCategoryCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final String routeName;
  final Function onTapCallback;
  const FeatureCategoryCard(
      this.title, this.onTapCallback, this.iconPath, this.routeName,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapCallback();
        Navigator.pushNamed(context, routeName);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4.0,
              spreadRadius: 0.05,
            ),
          ],
          color: Colors.white,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Image(
                height: 60,
                fit: BoxFit.contain,
                image: AssetImage(iconPath),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(title.tr),
          ],
        ),
      ),
    );
  }
}
