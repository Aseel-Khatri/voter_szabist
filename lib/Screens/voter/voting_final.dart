import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:voter_szabist/Screens/voter/societieis.dart';
import 'package:voter_szabist/components/common_button.dart';
import 'package:voter_szabist/components/default_profile.dart';
import 'package:voter_szabist/utils/constants.dart';

class VotingFinal extends StatelessWidget {
  final int societyId;
  final Map position;
  final candidate;
  VotingFinal({super.key, required this.societyId,required this.position,required this.candidate});
  final LocalAuthentication auth = LocalAuthentication();
  final votingsDb =FirebaseFirestore.instance.collection('votings');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal:widthSpace(9)),
          width: double.maxFinite,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: heightSpace(9)),
            candidate['profile']==null
                ?DefaultProfile(size: widthSpace(35))
                :Container(
                width: widthSpace(35),
                height: widthSpace(35),
                decoration: BoxDecoration(
                    color: Colors.black12,
                    shape: BoxShape.circle,
                    image: DecorationImage(image: NetworkImage(candidate['profile']))
                )),
                SizedBox(height: heightSpace(4)),
                CustomText(value: '${candidate['fname']} ${candidate['lname']}',fontSize: 2.2,fontWeight: FontWeight.w500),
                CustomText(value: candidate['program'],fontSize: 2),
                SizedBox(height: heightSpace(3)),
                CustomText(
                    value: 'A dynamic leader with a passion for positive change, strives to bring innovation and inlusivity to SMI University as I runs for the position of ${position['name']}',
                  textAlign: TextAlign.center,
                  fontSize: 1.7,
                ),
                SizedBox(height: heightSpace(5)),
                CommonButton(title: 'Vote', onPressed: (){
                  recordAuth(context);
                },width: 65)
          ]),
        ),
      ),
    );
  }
recordAuth(context)async{
  if(await auth.canCheckBiometrics && await auth.isDeviceSupported()){
    final biometric =await auth.authenticate(localizedReason: 'Your biometric will be used to authenticate while casting a vote.');
    if(biometric){
      Map<String,dynamic> voting = {
        "candidateEmail": candidate!['regEmail'],
        "voterEmail": user!['regEmail'],
        "societyId" : societyId,
        'positionId':position['id']
      };
      if(votingList!=null){
        votingList!.add(voting);
      }
        votingsDb.add(voting).then((value){
          Navigator.popUntil(context, (route) => route.isFirst);
          showDialog(context: context, builder: (c) => Dialog(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal:viewPadding,vertical: heightSpace(6)),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(value: 'Your vote has been casted!',fontWeight: FontWeight.w500,fontSize: 2.1),
                    SizedBox(height: heightSpace(1.5)),
                    Image.asset('assets/voting.png'),
                    SizedBox(height: heightSpace(3)),
                    CustomText(value: 'Thank you for submitting vote.'),
                  ]),
            ),
          ));
        });
    }
  }else{
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seems like your finger print is not set on your device, you must record your finger print to cast your vote.')));
  }
}
}
