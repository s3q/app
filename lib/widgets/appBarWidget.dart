import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  String title;
   AppBarWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_rounded,
                size: 28,
              )),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}
