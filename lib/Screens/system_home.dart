import 'package:flutter/material.dart';
import 'package:voter_szabist/Screens/account_requests.dart';
import 'package:voter_szabist/Screens/login.dart';
import 'package:voter_szabist/Screens/status_screen.dart';
import 'package:voter_szabist/utils/auth_helper.dart';
import 'package:voter_szabist/utils/constants.dart';

class SystemHome extends StatelessWidget {
  const SystemHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("System Panel"),
        actions: [
          IconButton(
              onPressed: () {
                AuthHelper().signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Login()));
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
          ElevatedButton(onPressed:(){
            Navigator.push(context, MaterialPageRoute(builder: (context) => StatusScreen()));
          },child: CustomText(value: "View Statuses",color: Colors.white,fontWeight: FontWeight.w500,textAlign: TextAlign.end)),
          SizedBox(height: heightSpace(2)),
          ElevatedButton(onPressed:(){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AccountRequests()));
          },child: CustomText(value: "Account Requests",color: Colors.white,fontWeight: FontWeight.w500,textAlign: TextAlign.end)),
        ]),
      ),
    );
  }
}
