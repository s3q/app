import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DividerWidget extends StatelessWidget {
  String? text;
   DividerWidget({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
            SizedBox(height: 20,),
        Row(
          children: [
            Expanded(
              child: Divider(
                height: 1,
              ),
            ),
            if (text != null)
              SizedBox(
                width: 10,
              ),
            if (text != null) Text(text!),
            if (text != null)
              SizedBox(
                width: 10,
              ),
            if (text != null)
              Expanded(
                child: Divider(
                  height: 1,
                ),
              ),
          ],
        ),
              SizedBox(height: 20,),
      ],
    );
  }
}
