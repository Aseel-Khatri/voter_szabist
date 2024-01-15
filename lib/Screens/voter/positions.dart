import 'package:flutter/material.dart';
import 'package:voter_szabist/Screens/voter/candidates_list.dart';
import 'package:voter_szabist/components/common_button.dart';
import 'package:voter_szabist/utils/constants.dart';

class Positions extends StatelessWidget {
  final Map society;
  const Positions({super.key,required this.society});
  final String note  = 'To uncover the hidden talent of Sindh Madressatul Islam University students by enhancing and polishing their oratory skills.';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal:widthSpace(7)),
        children: [
          SizedBox(height: heightSpace(10)),
          Image.asset('assets/societies/${society['id']}.jpg',height: widthSpace(27)),
          SizedBox(height: heightSpace(1.5)),
          Center(child: CustomText(value: '${society['name']}',fontSize: 2.2,fontWeight: FontWeight.bold)),
          SizedBox(height: heightSpace(1)),
          Center(child: CustomText(value: note,textAlign: TextAlign.center)),
          SizedBox(height: heightSpace(4)),
          ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                bool voted = votingList!.where((e) =>e['societyId']==society['id'] &&  e['positionId']==positions[index]['id']).isNotEmpty;
            return  Center(child: CommonButton(title: '${positions[index]['name']}', onPressed:(){
              if(voted){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      'Already Voted!',
                      style: TextStyle(fontSize: 16)),
                ));
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder:(c) => CandidatesList(society:society,position:positions[index])));
            },background: voted?Colors.lightGreen:Colors.grey[300]!,width: 70,
            icon: voted?Icons.check_circle:null,
            ));
          }, separatorBuilder:(c, i) => SizedBox(height: heightSpace(.7)), itemCount: positions.length)
        ],
      ),
    );
  }
}