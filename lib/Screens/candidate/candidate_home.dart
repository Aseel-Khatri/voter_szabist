import 'package:flutter/material.dart';
import 'package:voter_szabist/Screens/voter/societieis.dart';
import 'package:voter_szabist/components/common_button.dart';
import 'package:voter_szabist/utils/constants.dart';

import '../../utils/auth_helper.dart';
import '../login.dart';
import '../status_screen.dart';

class CandidateHome extends StatelessWidget {
  const CandidateHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${user!['fname']} ${user!['lname']}"),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StatusScreen()));
                },
                title: 'View & manage statuses',width: 60,isBorder: true),
            CommonButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Societies()));
                },
                title: 'View Results',width: 60),
          ],
        ),
      )
    );
  }
}
