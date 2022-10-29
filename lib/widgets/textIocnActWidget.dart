import 'package:flutter/material.dart';

class TextIconInfoActWidget extends StatelessWidget {
  IconData icon;
  Color color;
  String text;
  TextIconInfoActWidget({Key? key, required this.text, required this.icon, this.color = Colors.grey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            icon,
            color:
               color,
            size: 18,
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
