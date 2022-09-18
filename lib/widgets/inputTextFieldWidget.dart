import 'package:flutter/material.dart';

class InputTextFieldWidget extends StatelessWidget {
  String? labelText;
  String? helperText;
  String? hintText;
  IconData? prefixIcon;

  TextInputType? keyboardType;

  bool? obscureText;
  bool? autofocus;

  Function? onSaved;
  Function? validator;
  Function? onChanged;
  InputTextFieldWidget({
    super.key,

    this.keyboardType,
    this.labelText,
    this.hintText,
    this.onSaved,
    this.onChanged,
    this.prefixIcon,
    this.validator,
    this.autofocus,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType ?? TextInputType.name,
      autofocus: autofocus ?? false,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        hintText: hintText,
        helperText: helperText,
        labelText: labelText,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(
          prefixIcon,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black45,
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black45,
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      validator: (val) {
        if (validator != null) {
          return validator!(val);
        }

        return null;
      },
      onChanged: (val) {
        if (onChanged != null) {
          onChanged!(val);
        }
      },
      onSaved: (val) {
        if (onSaved != null) {
          onSaved!(val);
        }
      },
    );
  }
}
