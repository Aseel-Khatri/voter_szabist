import 'package:flutter/material.dart';
import 'package:voter_smiu/Screens/results.dart';
import 'package:voter_smiu/Screens/voter/candidates_list.dart';
import 'package:voter_smiu/components/common_button.dart';
import 'package:voter_smiu/utils/constants.dart';

class Positions extends StatelessWidget {
  final Map society;
  final bool forResult;
  const Positions({super.key,required this.society,this.forResult=false});
  final String note  = 'To uncover the hidden talent of Sindh Madressatul Islam University students by enhancing and polishing their oratory skills.';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal:widthSpace(7)),
        children: [
          SizedBox(height: heightSpace(10)),
          Image.asset('assets/societies/${society['id']}.jpg',height: widthSpace(27)),
          SizedBox(height: heightSpace(1.5)),
          Center(child: CustomText(value: '${society['name']}',fontSize: 2.2,fontWeight: FontWeight.bold)),
          if(!forResult)...[
            SizedBox(height: heightSpace(1)),
            Center(child: CustomText(value: note,textAlign: TextAlign.center)),
          ],
          SizedBox(height: heightSpace(4)),
          ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                bool voted = !forResult && votingList!.where((e){
                  return e['societyId']==society['id'] &&  e['positionId']==positions[index]['id'] && e['voterEmail']==user!['regEmail'];
                }).isNotEmpty;
            return  Center(child: CommonButton(title: '${positions[index]['name']}', onPressed:(){
              print(electionExpiry);
              if(electionExpiry.isBefore(DateTime.now())){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Elections timed out !")));
                return;
              }
              if(forResult){
                Navigator.push(context, MaterialPageRoute(builder:(c) =>
                    Results(
                        society:society,
                        position:positions[index])));
              }else{
                if(voted){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        'Already Voted!',
                        style: TextStyle(fontSize: 16)),
                  ));
                  return;
                }
                Navigator.push(context, MaterialPageRoute(builder:(c) => CandidatesList(society:society,position:positions[index])));
              }
            },background: voted?Colors.lightGreen:Colors.grey[300]!,width: 70,
            icon: voted?Icons.check_circle:null,
            ));
          }, separatorBuilder:(c, i) => SizedBox(height: heightSpace(.7)), itemCount: positions.length)
        ],
      ),
    );
  }
}