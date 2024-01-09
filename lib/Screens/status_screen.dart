import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:voter_szabist/Screens/login.dart';
import 'package:voter_szabist/utils/auth_helper.dart';
import 'package:voter_szabist/utils/constants.dart';

class StatusScreen extends StatelessWidget {
  Map user;
  final _formKey = GlobalKey<FormState>();
  TextEditingController statusText = TextEditingController();
  StatusScreen({Key? key,required this.user}) : super(key: key);

  final statuses =FirebaseFirestore.instance.collection('statuses');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statuses Listing"),
        actions: [
          if(user['role']!="Voter")IconButton(
              onPressed: () {
                showDialog(context: context, builder: (context) {
                  return Dialog(alignment: Alignment.center,child: SizedBox(
                    height: heightSpace(35),
                    child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.stretch,children: [
                      Container(
                        color:Colors.blue[50],
                        padding: EdgeInsets.all(widthSpace(5)),
                        child:CustomText(value:"Publish your Status",fontSize: 2,fontWeight: FontWeight.w500)
                      ),
                      Padding(
                        padding: EdgeInsets.all(widthSpace(5)),
                        child: Form(key: _formKey,child: TextFormField(
                          controller: statusText,
                          validator: (val)=>val!.isEmpty?"Please enter some text.":null,
                          decoration: const InputDecoration(hintText: "Status Text"),
                        )),
                      ),
                      ElevatedButton(onPressed: (){
                        if(_formKey.currentState!.validate()){
                          statuses.add({
                            "name": "${user['fname']} ${user['lname']}",
                            "regEmail" : user['regEmail'],
                            'role':user['role'],
                            'text':statusText.text,
                          }).then((value){
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  "Status has been Added",
                                  style: TextStyle(fontSize: 16)),
                            ));
                          });
                        }
                      }, child: const Text("Submit"))
                    ]),
                  ));
                });
              },
              icon: const Icon(Icons.add)),
          IconButton(
              onPressed: () {
                AuthHelper().signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Login()));
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder(
          stream: statuses.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if(snapshot.data!.docs.isEmpty){
              return const Center(child: Text("No Status has been published yet !"));
            }
            return ListView.separated(
                padding: const EdgeInsets.all(15),
                itemBuilder: (context,i){
                  var data = snapshot.data!.docs[i].data() as Map;
                  return Card(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(value:"${data['name']}",color: Colors.grey),
                                if(user['regEmail']==data['regEmail'])InkWell(child: Container(
                                  padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.red[50],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.delete_outline_rounded,color: Colors.red[300],size: 20)),onTap: (){
                                  statuses.doc(snapshot.data!.docs[i].id).delete().then((value){
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text(
                                        "Status has been deleted.",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ));
                                  });

                                })
                              ],
                            ),
                            SizedBox(height: heightSpace(2)),
                            CustomText(value:data['text'],fontSize: 2.2,fontWeight: FontWeight.w500),
                            SizedBox(height: heightSpace(2)),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: CustomText(value:data['role'],color:data['role']=="System"?Colors.red:data['role']=="Candidate"?Colors.blueAccent:Colors.green,

                                  fontWeight: data['role']=="System"?FontWeight.bold:FontWeight.w500),
                            ),
                          ],
                        ),
                      )) ;
                },separatorBuilder: (context,i)=>const SizedBox(height: 10),itemCount: snapshot.data!.docs.length);
          })
    );
  }
}
