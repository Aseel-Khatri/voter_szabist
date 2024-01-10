import 'package:flutter/material.dart';
import 'package:voter_szabist/utils/constants.dart';

class CommonButton extends StatelessWidget{
  final VoidCallback onPressed;
  final String title;
  final bool isLoading;
  CommonButton({required this.title,required this.onPressed,this.isLoading=false});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: themeColor,
            minimumSize: Size(widthSpace(35),heightSpace(5))),
        onPressed: isLoading?null:onPressed, child: 
    isLoading
        ?const SizedBox(width: 20,height: 20,child: CircularProgressIndicator(color: themeColor))
        :CustomText(value:title,fontWeight: FontWeight.w500,color: Colors.white));
  }

}