
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  double widh;
  double height;
  List<String> items;
  String hint;
  String? value;
  void Function(String?)? onChange;

  CustomDropDown(
      {this.widh = 100,
        this.height = 40,
        required this.items,
        this.hint = "",
        this.value,
        required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widh,
      height: height,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            hint: Text(hint),
            value: value,
            items: items
                .map((String e) => DropdownMenuItem(
              child: Text(e),
              value: e,
            ))
                .toList(),
            onChanged: onChange,
            menuMaxHeight: 200,
          ),
        ),
      ),
    );
  }
}
