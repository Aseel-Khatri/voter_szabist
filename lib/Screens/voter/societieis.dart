import 'package:flutter/material.dart';
import 'package:voter_szabist/Screens/voter/positions.dart';
import 'package:voter_szabist/utils/constants.dart';

class Societies extends StatelessWidget {
  const Societies({super.key});

  @override
  Widget build(BuildContext context) {
    final society = societies.where((e) => e['id']==user!['societyId']);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding:EdgeInsets.all(viewPadding),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(value: 'Societies',fontWeight: FontWeight.bold,fontSize: 2.3,color: themeColor),
                SizedBox(height: heightSpace(2)),
           SizedBox(
             height: user?['role']=='Voter'?heightSpace(18):heightSpace(80),
             child: ListView.separated(
                 scrollDirection: user?['role']=='Voter'?Axis.horizontal:Axis.vertical,
                 itemBuilder: (c,i){
               return InkWell(
                 onTap: (){
                   Navigator.push(context, MaterialPageRoute(builder: (c) => Positions(society: societies[i],forResult:true)));
                 },
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     Image.asset('assets/societies/${societies[i]['id']}.jpg',width: widthSpace(25)),
                     if(user?['role']=='Voter')
                       SizedBox(height: heightSpace(1)),
                     CustomText(value: '${societies[i]['name']}',fontSize: 1.9,fontWeight: FontWeight.w500)
                   ]),
               );
                 }, separatorBuilder: (context, index) =>
             user?['role']=='Voter'?SizedBox(width: widthSpace(3)):SizedBox(height: heightSpace(4)),
                 itemCount: societies.length),
           ),
                if(user?['role']=='Voter')...[
                  SizedBox(height: heightSpace(5.5)),
                  SizedBox(
                      width: widthSpace(35),
                      child: CustomText(value: 'Cast your vote to your Society',fontWeight: FontWeight.bold,fontSize: 2.3)),
                  SizedBox(height: heightSpace(2)),
                  InkWell(
                    onTap:()=>Navigator.push(context, MaterialPageRoute(builder: (c) => Positions(society:society.first))),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(13),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset('assets/societies/${society.first['id']}.jpg',width: widthSpace(25)),
                            SizedBox(height: heightSpace(1)),
                            CustomText(value: '${society.first['name']}',fontSize: 1.9,fontWeight: FontWeight.w500)
                          ]),
                    ),
                  )
                ],
          ]),
        ),
      ),
    );
  }
}
