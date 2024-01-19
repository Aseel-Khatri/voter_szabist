import 'package:flutter/material.dart';
import 'package:voter_szabist/utils/constants.dart';

class CommonButton extends StatelessWidget{
  final VoidCallback? onPressed;
  final String title;
  final bool isLoading,isBorder;
  final Color background;
  final double borderRadius;
  final double width;
  final IconData? icon;
  final Color? textColor;
  CommonButton({required this.title,required this.onPressed,this.isLoading=false,this.isBorder=false,this.background=themeColor,this.borderRadius=12,this.width=40,this.icon,this.textColor});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: isBorder?Colors.white:background,
            minimumSize: Size(widthSpace(width),heightSpace(5)),
            maximumSize: Size(widthSpace(width),heightSpace(5)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: isBorder?BorderSide(color: background):BorderSide.none
            )),
        onPressed: isLoading?null:onPressed, child: 
    isLoading
        ?const SizedBox(width: 20,height: 20,child: CircularProgressIndicator(color: themeColor))
        :Row(
      mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(value:title,fontWeight: FontWeight.w500,color: textColor??(isBorder?background:background==themeColor?Colors.white:Colors.black)),
            if(icon!=null)Icon(icon,color: Colors.white),
          ],
        ));
  }

}