import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Wgt_button extends StatelessWidget {
  Wgt_button({
    Key? key,
    required this.onPressed,
    required this.text,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);
  void Function()? onPressed;
  String text;
  double? width;
  double? height;
  Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero)),
            onPressed: onPressed,
            child: Text(text.toString())));
  }
}
