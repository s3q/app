import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckboxWidget extends StatefulWidget {
  String label;
  bool isCheck;
  Function onChanged;
  double marginH;
  double marginV;
  CheckboxWidget({
    super.key,
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
  bool _isChecked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _isChecked = widget.isCheck;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
          horizontal: widget.marginH, vertical: widget.marginV),
      child: Row(
        children: [
          Checkbox(
            
            checkColor: Colors.white,
            fillColor: MaterialStateProperty.all(Colors.blue),
            value: _isChecked,
            onChanged: (bool? value) {
              setState(() {
                _isChecked = value ?? _isChecked;
              });

              widget.onChanged(value);
            },
          ),
          SizedBox(
            width: 5,
          ),
          Flexible(
              child: GestureDetector(
            onTap: () {
              setState(() {
                _isChecked = !_isChecked;
              });
                            widget.onChanged(_isChecked);

            },
            child: Text(
              widget.label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.black54),
            ),
          ))
        ],
      ),
    );
  }
}
