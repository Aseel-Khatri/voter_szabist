import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:voter_szabist/Screens/voter/voting_final.dart';
import 'package:voter_szabist/components/default_profile.dart';
import 'package:voter_szabist/utils/constants.dart';

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
              List data = snapshot.data!.docs;
              return ListView.builder(
                padding: EdgeInsets.all(viewPadding),
                  itemBuilder: (context, i) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (c) => VotingFinal(
                            societyId: society['id'],
                            position: position,
                            candidate: data[i])));
                      },
                      child: Row(
                        children: [
                          data[i]?['profile']==null
                              ?const DefaultProfile()
                              :Container(
                              width: widthSpace(15),
                              height: widthSpace(15),
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(image: NetworkImage(data[i]['profile']))
                              )),
                          SizedBox(width: widthSpace(3)),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(value: '${data[i]['fname']} ${data[i]['lname']}',fontSize: 2,fontWeight: FontWeight.w500),
                                  CustomText(value: data[i]['program']),
                            ]),
                          ),
                          const Icon(Icons.chevron_right_rounded)
                        ],
                      ),
                    );
                  },
                  itemCount: data.length);
            }));
  }
}