import 'package:app/helpers/colorsHelper.dart';
import "package:flutter/material.dart";

class CategoryCardWidget extends StatelessWidget {
  String imagePath;
  String title;
  Function() onPressed;
  CategoryCardWidget({Key? key, required this.imagePath, required this.title, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 4,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(
              imagePath,
              width: 120,
              height: 80,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
