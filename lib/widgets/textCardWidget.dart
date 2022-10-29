import 'package:flutter/material.dart';
class TextCardWidget extends StatelessWidget {
  String title;
  String? text;
  TextCardWidget({super.key, this.text, required this.title});

  @override
  Widget build(BuildContext context) {
    if (text == "" || text == null) {
      return SizedBox();
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          //   const SizedBox(
          //     height: 8,
          //   ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text ?? "",
            ),
          ),
        ],
      ),
    );
  }
}
