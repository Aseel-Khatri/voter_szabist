import 'package:flutter/material.dart';
import 'package:voter_szabist/Screens/account_requests.dart';
import 'package:voter_szabist/Screens/login.dart';
import 'package:voter_szabist/Screens/status_screen.dart';
import 'package:voter_szabist/Screens/voter/societieis.dart';
import 'package:voter_szabist/components/common_button.dart';
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
        child: Padding(
          padding: EdgeInsets.all(viewPadding),
          child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
              Expanded(
                child: CommonButton(
                    title: 'View Statuses',
                    isBorder: true,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => StatusScreen()));
                    }),
              ),
              SizedBox(width: widthSpace(5)),
              Expanded(
                child: CommonButton(
                    title: 'Account Requests',
                    isBorder: true,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AccountRequests()));
                    }),
              ),
            ]),
            SizedBox(height: heightSpace(1)),
            CommonButton(
                title: 'View Results',
                // isBorder: true,
                width: 60,
                onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Societies()));
            }),
          ]),
        ),
      ),
    );
  }
}
