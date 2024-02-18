import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:voter_smiu/utils/auth_helper.dart';
import 'package:voter_smiu/utils/constants.dart';

class AccountRequests extends StatelessWidget {
  final user;
  AccountRequests({Key? key, this.user}) : super(key: key);
  Stream<QuerySnapshot> studentsStream =
      FirebaseFirestore.instance.collection('students').where('isVerified',isEqualTo: false).snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Students Account Requests"),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         AuthHelper().signOut();
        //         Navigator.pushReplacement(context,
        //             MaterialPageRoute(builder: (context) => const Login()));
        //       },
        //       icon: const Icon(Icons.logout))
        // ],
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
            if(snapshot.data!.docs.isEmpty){
              return const Center(child: Text("No requests yet !"));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(15),
                itemBuilder: (context,i){
                  var data = snapshot.data!.docs[i].data() as Map;
                  Map society = societies.firstWhere((e) => e['id']==data['societyId']);
                  Map? position;
                  if(data['positionId']!=0){
                    position = positions.firstWhere((e) => e['id']==data['positionId']);
                  }
                return Card(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      color: Colors.white,
                      child: Row(
                        children: [
                          if(data['profile']!=null)
                            Container(
                              width: widthSpace(15),
                                height: widthSpace(15),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(image: NetworkImage(data['profile']))
                                )),
                          SizedBox(width: widthSpace(5)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(value:"${data['fname']} ${data['lname']} (${data['role']})",fontWeight: FontWeight.w500,fontSize: 1.9),
                                Row(
                                    children: [
                                  CustomText(value:'Registration ID: ',color: Colors.grey),
                                  CustomText(value:data['registerId']),
                                ]),
                                CustomText(value:data['regEmail']),
                                const Divider(),
                                CustomText(value:'Applying for ',fontSize: 1.7),
                                CustomText(value:society['name'],fontWeight: FontWeight.w500),
                                if(data['role']=='Candidate')...[
                                  CustomText(value: 'as a ',fontSize: 1.7),
                                  CustomText(value:position!['name'],fontWeight: FontWeight.w500),
                                ],
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton.icon(onPressed: ()async{
                                    String payload = await AuthHelper().approveAccount(snapshot.data!.docs[i].id);
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                          payload,
                                          style: const TextStyle(fontSize: 16)),
                                    ));
                                  }, icon: const Icon(Icons.check_rounded,color: Colors.green),label: const Text("Accept",style: TextStyle(color:Colors.green))),
                                )],
                            ),
                          ),
                        ],
                      ),
                    )) ;
                },separatorBuilder: (context,i)=>const SizedBox(height: 10),itemCount: snapshot.data!.docs.length);
          }),
    );
  }
}
