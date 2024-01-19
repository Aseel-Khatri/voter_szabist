import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voter_szabist/Screens/account_requests.dart';
import 'package:voter_szabist/Screens/login.dart';
import 'package:voter_szabist/Screens/status_screen.dart';
import 'package:voter_szabist/Screens/voter/societieis.dart';
import 'package:voter_szabist/components/common_button.dart';
import 'package:voter_szabist/utils/auth_helper.dart';
import 'package:voter_szabist/utils/constants.dart';
class SystemHome extends StatefulWidget{
  const SystemHome({super.key});

  @override
  SystemHomeState createState()=>SystemHomeState();
}
class SystemHomeState extends State<SystemHome> {
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
          child: Column(children: [
            Container(
              width: widthSpace(45),
              height: widthSpace(45),
              margin: EdgeInsets.only(bottom: heightSpace(5)),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: AssetImage('assets/logo.png'),fit: BoxFit.contain)),
            ),
            Container(
              padding: EdgeInsets.all(12),
              decoration:BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(9)
              ),child: Column(children: [
                CustomText(value: "Elections ${electionExpiry.isBefore(DateTime.now())?"Expired, click to Change.":"Expiry"}",fontWeight: FontWeight.w500,fontSize: 2.0),
                SizedBox(height: heightSpace(2)),
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap:(){
                    showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime(DateTime.now().year+1)).then((res){
                      if(res!=null){
                        setState(()=>electionExpiry = res);
                        AuthHelper().setElectionsExpiry(electionExpiry.toString(), context).then((_){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Election expiry Updated")));
                        });
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomText(
                            value: DateFormat.yMMMd().format(electionExpiry),
                        fontWeight: FontWeight.bold,
                          fontSize: 3),
                        CustomText(value: DateFormat.jms().format(electionExpiry))
                      ],
                    ),
                  ),
                ),
              SizedBox(height: heightSpace(2)),
              if(electionExpiry.isAfter(DateTime.now()))Align(
                alignment: Alignment.bottomRight,
                  child: CommonButton(
                      title:'Expire Now !',
                      onPressed: (){
                        showDialog(context: context, builder: (context_)=>AlertDialog(
                            title:CustomText(value:"Warning !",color: themeColor,fontSize: 2.1,fontWeight: FontWeight.bold),content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText(value:"Are you sure you want to expire all your pollings?",fontWeight: FontWeight.w500,fontSize: 1.9,color: Colors.black87),
                          ],
                        ),actions: [
                          TextButton(
                            child: Text("Yes",style: TextStyle(color: Colors.white)),
                            style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => themeColor)),
                            onPressed: () async{
                              Navigator.pop(context);
                              setState(()=>electionExpiry = DateTime(DateTime.now().year-1));
                              AuthHelper().setElectionsExpiry(electionExpiry.toString(), context).then((_){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Election expiry Updated")));
                              });
                            },
                          )
                        ]));
                      },
                      borderRadius: 6,
                      width: 40,
                      background: Colors.red,textColor: Colors.white))
            ])),
            SizedBox(height: heightSpace(4)),
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
  @override
  void initState() {
    super.initState();
  }
}
