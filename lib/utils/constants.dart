import 'package:flutter/material.dart';
import 'package:voter_szabist/utils/size_config.dart';

const themeColor = Color(0xff964B00);
double heightSpace(val)=>val*SizeConfig.heightMultiplier;
double widthSpace(val)=>val*SizeConfig.widthMultiplier;
final double viewPadding = widthSpace(5);
List? votingList;
DateTime electionExpiry = DateTime.now();
Map? user;
final societies = [
  {
    'id':1,
    'name':'Debating Society'
  },
  {
    'id':2,
    'name':'Art Society'
  },
  {
    'id':3,
    'name':'Community Service Society'
  },
  {
    'id':4,
    'name':'Literary Society'
  },
  {
    'id':5,
    'name':'Science Society:'
  },
  {
    'id':6,
    'name':'Sports Society'
  },
  {
    'id':7,
    'name':'Music Society'
  },
  {
    'id':8,
    'name':'Character Building Society'
  }
];
final positions = [
  {
    'id': 1,
    'name': 'President',
    'plural': 'Presidents',
  },
  {
    'id': 2,
    'name': 'Vice President',
    'plural': 'Vice Presidents',
  },
  {
    'id': 3,
    'name': 'Female Secretary',
    'plural': 'Female Secretaries',
  },
  {
    'id': 4,
    'name': 'Male Secretary',
    'plural': 'Male Secretaries',
  },
  {
    'id': 5,
    'name': 'Treasurer',
    'plural': 'Treasurers',
  }
];

class CustomText extends StatelessWidget {
  String value;
  FontWeight? fontWeight;
  double? fontSize;
  Color? color;
  TextAlign? textAlign;
  CustomText({Key? key,required this.value,this.fontWeight,this.fontSize=1.8,this.color,this.textAlign}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(value,
      style:TextStyle(color: color??Colors.black,fontWeight: fontWeight,fontSize: heightSpace(fontSize)), textAlign: textAlign,);
  }
}
