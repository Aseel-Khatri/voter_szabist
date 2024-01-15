import 'package:flutter/material.dart';
import 'package:voter_szabist/utils/constants.dart';

class CommonButton extends StatelessWidget{
  final VoidCallback? onPressed;
  final String title;
  final bool isLoading;
  final Color background;
  final double borderRadius;
  final double width;
  final IconData? icon;
  CommonButton({required this.title,required this.onPressed,this.isLoading=false,this.background=themeColor,this.borderRadius=12,this.width=35,this.icon});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: background,
            minimumSize: Size(widthSpace(width),heightSpace(5)),
            maximumSize: Size(widthSpace(width),heightSpace(5)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius))),
        onPressed: isLoading?null:onPressed, child: 
    isLoading
        ?const SizedBox(width: 20,height: 20,child: CircularProgressIndicator(color: themeColor))
        :Row(
      mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 3,child: CustomText(value:title,fontWeight: FontWeight.w500,color: background==themeColor?Colors.white:Colors.black)),
            if(icon!=null)Icon(icon,color: Colors.white),
          ],
        ));
  }

}