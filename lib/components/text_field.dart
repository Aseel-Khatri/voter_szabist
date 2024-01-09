import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  TextEditingController controller;
  String hintText;
  Color? fillColor;
  bool obscureText,editable;
  TextInputType? textInputType;
  var validator,onChanged;
  CustomTextField({Key? key,required this.controller,required this.hintText,this.fillColor,this.obscureText=false,this.editable=true,this.textInputType,this.validator,this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
       controller: controller,
      enabled: editable,
      validator: validator,
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: textInputType,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white
      ),
    );
  }
}
