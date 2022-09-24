import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  String title;
  bool backArrow;
  AppBarWidget({super.key, required this.title, this.backArrow = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Row(
        children: [
          if (backArrow)
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  size: 28,
                )),
          if (!backArrow)
            SizedBox(
              width: 10,
            ),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}
