import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:voter_smiu/Screens/voter/voting_final.dart';
import 'package:voter_smiu/components/default_profile.dart';
import 'package:voter_smiu/utils/constants.dart';

class CandidatesList extends StatelessWidget {
  final Map society, position;
  const CandidatesList(
      {super.key, required this.society, required this.position});
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> studentsStream = FirebaseFirestore.instance
        .collection('students')
        .where('role', isEqualTo: 'Candidate')
        .where('societyId', isEqualTo: society['id'])
        .where('positionId', isEqualTo: position['id'])
        .snapshots();
    //positionId societyId
    return Scaffold(
        appBar: AppBar(
          title: Text(position['name']),
        ),
        body: StreamBuilder(
            stream: studentsStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.docs.isEmpty) {
                return Center(child: Text("No Candidates found for ${position['name']} !"));
              }
              print(snapshot.data!.docs);
              List runningList = snapshot.data!.docs.where((e) => ((e.data()as Map)['withdrawn']??false)==false).toList();
              List withdrawnList = snapshot.data!.docs.where((e) => (e.data() as Map)['withdrawn']==true).toList();
              return Padding(
                padding: EdgeInsets.all(viewPadding),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  CustomText(value: 'Running',fontWeight: FontWeight.w500),
                  runningList.isEmpty
                      ? Padding(
                        padding: const EdgeInsets.symmetric(vertical:8.0),
                        child: CustomText(value: 'No running Candidate for now-',color: Colors.grey),
                      )
                      : renderList(runningList, context),
                  if(withdrawnList.isNotEmpty)...[
                    Divider(height: heightSpace(2)),
                    CustomText(value: 'Dropped out',fontWeight: FontWeight.w500),
                    renderList(withdrawnList, context),
                  ],
                ]),
              );
            }));
  }
  renderList(List data,context){
    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: heightSpace(1)),
        itemBuilder: (context, i) {
          return renderComponent(data[i],context);
        },
        itemCount: data.length);
  }
  renderComponent(data,context){
    data = data.data() as Map;
    if(data is DocumentSnapshot){
      print("Data is DocumentSnapshotPlatform");
    }
    if(data is QueryDocumentSnapshot){
      print("Data is QueryDocumentSnapshot");
    }
    if(data is Map){
      print("Data is Map");
    }
    return InkWell(
      onTap: (data?['withdraw'])==true?null:() {
        Navigator.push(context, MaterialPageRoute(builder: (c) => VotingFinal(
            societyId: society['id'],
            position: position,
            candidate: data)));
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            data?['profile']==null
                ?const DefaultProfile()
                :Container(
                width: widthSpace(15),
                height: widthSpace(15),
                decoration: BoxDecoration(
                    color: Colors.black12,
                    shape: BoxShape.circle,
                    image: DecorationImage(image: NetworkImage(data['profile']))
                )),
            SizedBox(width: widthSpace(3)),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(value: '${data?['fname']} ${data?['lname']}',fontSize: 2,fontWeight: FontWeight.w500),
                    CustomText(value: data?['program']),
                  ]),
            ),
            const Icon(Icons.chevron_right_rounded)
          ],
        ),
      ),
    );
  }
}