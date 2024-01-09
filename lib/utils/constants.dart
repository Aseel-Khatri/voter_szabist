import 'package:flutter/material.dart';
import 'package:voter_szabist/utils/size_config.dart';

const themeColor = Color(0xff203f9a);
double heightSpace(val)=>val*SizeConfig.heightMultiplier;
double widthSpace(val)=>val*SizeConfig.widthMultiplier;
class CustomText extends StatelessWidget {
  String value;
  FontWeight? fontWeight;
  double? fontSize;
  Color? color;
  TextAlign? textAlign;
  CustomText({Key? key,required this.value,this.fontWeight,this.fontSize=1.8,this.color,this.textAlign}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(value,style: TextStyle(color: color??Colors.black,fontWeight: fontWeight,fontSize: heightSpace(fontSize)), textAlign: textAlign,);
  }
}
