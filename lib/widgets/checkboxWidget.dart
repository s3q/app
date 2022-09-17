import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckboxWidget extends StatefulWidget {
  String label;
  bool isCheck;
  Function onChanged;
  double marginH;
  double marginV;
  CheckboxWidget(
      {super.key,
      required this.label,
      required this.isCheck,
      required this.onChanged,
      this.marginH = 0,
      this.marginV = 10,
      });

  @override
  State<CheckboxWidget> createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal:widget.marginH, vertical: widget.marginV ),
      child: Row(
        children: [
          Checkbox(
            checkColor: Colors.white,
            fillColor: MaterialStateProperty.all(Colors.blue),
            value: widget.isCheck,
            onChanged: (bool? value) {
              setState(() {
                widget.isCheck = value!;
              });

              widget.onChanged(value);
            },
          ),
          SizedBox(
            width: 5,
          ),
          Flexible(child: Text(widget.label, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black54),))
        ],
      ),
    );
  }
}
