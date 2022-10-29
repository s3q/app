import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TextBoxActWidget extends StatelessWidget {
  String text;
  TextBoxActWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
        color: Color(0x609E9E9E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AutoSizeText(
              text,
              maxLines: 1,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
