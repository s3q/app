import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class InputTextFieldWidget extends StatefulWidget {
  String? text;
  String? labelText;
  String? helperText;
  String? hintText;
  IconData? prefixIcon;

  bool? enabled;

  int? maxLines;
  int? minLines;
  int? maxLength;

  TextInputType? keyboardType;

  bool? obscureText;
  bool? autofocus;

  Function? onSaved;
  Function? validator;
  Function? onChanged;
  InputTextFieldWidget({
    super.key,
    this.enabled,
    this.text,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.keyboardType,
    this.labelText,
    this.hintText,
    this.helperText,
    this.onSaved,
    this.onChanged,
    this.prefixIcon,
    this.validator,
    this.autofocus,
    this.obscureText,
  });

  @override
  State<InputTextFieldWidget> createState() => _InputTextFieldWidgetState();
}

class _InputTextFieldWidgetState extends State<InputTextFieldWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.text = widget.text ?? "";
    return TextFormField(
      key: Key(Uuid().v4()),
      enabled: widget.enabled,
      controller: _controller,
      keyboardType: widget.keyboardType ?? TextInputType.name,
      autofocus: widget.autofocus ?? false,
      obscureText: widget.obscureText ?? false,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        hintText: widget.hintText,
        helperText: widget.helperText,
        labelText: widget.labelText,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
              )
            : null,
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
        if (widget.validator != null) {
          return widget.validator!(val);
        }

        return null;
      },
      onChanged: (val) {
        if (widget.onChanged != null) {
          widget.onChanged!(val);
        }
      },
      onSaved: (val) {
        if (widget.onSaved != null) {
          widget.onSaved!(val);
        }
      },
    );
  }
}
