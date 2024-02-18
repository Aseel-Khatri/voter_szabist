import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:voter_smiu/utils/constants.dart';
class Results extends StatefulWidget{
  final Map society,position;
  Results({super.key,required this.society,required this.position});
  @override
  ResultsState createState() => ResultsState();
}
class ResultsState extends State<Results> {
  List? students;

  @override
  Widget build(BuildContext context) {
    final voting =FirebaseFirestore.instance.collection('votings').where(
        'societyId',isEqualTo: widget.society['id']).
    where('positionId',isEqualTo:widget.position['id']);
    print("${widget.society}");
    print("${widget.position}");
    return Scaffold(
      appBar: AppBar(title: const Text('Polling Results')),
      body: students==null
          ?const Center(child:CircularProgressIndicator())
          :StreamBuilder(
        stream: voting.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if(snapshot.data!.docs.isEmpty){
              return const Center(child: Text("No Voting yet !"));
            }
            return ListView.separated(
              padding: EdgeInsets.all(viewPadding),
                itemBuilder: (context, i) {
                  var data = snapshot.data!.docs.where((e) => (e.data() as Map)['candidateEmail']==students![i]['regEmail']);
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(value: '${students![i]['fname']} ${students![i]['lname']}'),
                        CustomText(value: "${data.length}")
                  ]);
                },
                separatorBuilder: (context, index) => Divider(height: heightSpace(5)),
                itemCount: students!.length);
        }
      ),
    );
  }
  @override
  void initState() {
    getCandidates();
    super.initState();
  }
  getCandidates(){
    final collection = FirebaseFirestore.instance.collection('students').where('role',isEqualTo: 'Candidate').where(
        'societyId',isEqualTo: widget.society['id']).
    where('positionId',isEqualTo:widget.position['id']);
    collection.get().then((res){
      setState(()=>students = res.docs.map((e)=>e.data()).toList());
    });
}
}
