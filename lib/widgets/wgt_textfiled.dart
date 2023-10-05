import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class Wgt_TextField extends StatelessWidget {
  Wgt_TextField(
      {Key? key,
      this.controller,
      this.labelText,
      this.textInputType,
      this.textAlign,
      this.maxLines,
      this.hintText,
      this.errorText,
      this.onChanged,
      this.obscureText,
      this.icon,
      this.borderRadius,
      this.autofocus})
      : super(key: key);
  TextEditingController? controller = TextEditingController();
  String? labelText;
  TextInputType? textInputType;
  int? maxLines;
  TextAlign? textAlign;
  String? hintText;
  String? errorText;
  bool? autofocus;
  bool? obscureText;
  Icon? icon ;
  BorderRadius? borderRadius;
  void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(

      controller: controller,
      keyboardType: textInputType,
      maxLines: maxLines??1,
      obscureText: obscureText??false,
      autofocus: autofocus??false,
      textAlign: textAlign ?? TextAlign.start,
inputFormatters: [
  FilteringTextInputFormatter.deny("'"),
  FilteringTextInputFormatter.deny("\"")
],
      decoration: InputDecoration(

          // icon: icon,
          prefixIcon: icon,
          border: OutlineInputBorder(borderRadius: borderRadius??BorderRadius.zero ),
          hintText: hintText,
          errorText: errorText,
          labelText: labelText),
      onChanged: onChanged,

    );
  }
}
