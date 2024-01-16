import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:voter_szabist/Screens/status_screen.dart';
import 'package:voter_szabist/Screens/system_home.dart';
import 'package:voter_szabist/Screens/voter/societieis.dart';
import 'package:voter_szabist/Screens/voter_register.dart';
import 'package:voter_szabist/components/text_field.dart';
import 'package:voter_szabist/utils/auth_helper.dart';
import 'package:voter_szabist/utils/constants.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailVoter = TextEditingController();
  TextEditingController passwordVoter = TextEditingController();

  TextEditingController emailCandid = TextEditingController();
  TextEditingController passwordCandid = TextEditingController();

  TextEditingController emailSystem = TextEditingController();
  TextEditingController passwordSystem = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final votings =FirebaseFirestore.instance.collection('votings');
  String _selectedType = "Voter";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal:widthSpace(10),vertical: heightSpace(10)),
        child: Form(
          key:_formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,children: [
            CustomText(value: "Powered By",textAlign: TextAlign.center),
            Container(
              width: widthSpace(45),
              height: widthSpace(45),
              margin: EdgeInsets.symmetric(vertical: heightSpace(3)),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: AssetImage('assets/logo.png'),fit: BoxFit.contain)),
            ),
            CustomText(value: "Login as a $_selectedType",fontSize: 2.7,textAlign: TextAlign.center,fontWeight: FontWeight.w500),
            SizedBox(height: heightSpace(3.5)),
            Container(
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black12))
              ),child: Row(children: [
              Expanded(
                child: InkWell(
                  onTap: ()=>setState(()=>_selectedType="Voter"),
                  child: Container(
                    padding: EdgeInsets.only(bottom: heightSpace(.5)),
                    decoration: BoxDecoration(
                        border: Border(bottom: _selectedType=="Voter"?const BorderSide(width: 2):BorderSide.none)
                    ),child: CustomText(value: "Voter",fontSize: 2.3,textAlign: TextAlign.center),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: ()=>setState(()=>_selectedType="Candidate"),
                  child: Container(
                      padding: EdgeInsets.only(bottom: heightSpace(.5)),
                    decoration: BoxDecoration(
                        border: Border(bottom: _selectedType=="Candidate"?const BorderSide(width: 2):BorderSide.none)
                    ),child: CustomText(value: "Candidate",fontSize: 2.3,textAlign: TextAlign.center)
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: ()=>setState(()=>_selectedType="System"),
                  child: Container(
                    padding: EdgeInsets.only(bottom: heightSpace(.5)),
                    decoration: BoxDecoration(
                        border: Border(bottom: _selectedType=="System"?const BorderSide(width: 2):BorderSide.none)
                    ),child: CustomText(value: "System",fontSize: 2.3,textAlign: TextAlign.center),
                  ),
                ),
              ),
            ])),
            SizedBox(height: heightSpace(4)),
            CustomTextField(controller: _selectedType=="Voter"?emailVoter:_selectedType=="Candidate"?emailCandid:emailSystem,textInputType: TextInputType.emailAddress, hintText: "Email"),
            SizedBox(height: heightSpace(2)),
            CustomTextField(controller: _selectedType=="Voter"?passwordVoter:_selectedType=="Candidate"?passwordCandid:passwordSystem, hintText: "Password",obscureText:true),
            if(_selectedType!="System")...[
              SizedBox(height: heightSpace(2)),
              TextButton(onPressed:(){},style: const ButtonStyle(alignment: Alignment.centerRight),child: CustomText(value: "Forgot Password?",textAlign: TextAlign.end)),
            ],
            SizedBox(height: heightSpace(4)),
            ElevatedButton(onPressed: ()async{
              votings.get().then((res){
                votingList = res.docs.map((e)=>e.data()).toList();
              });
              if(_formKey.currentState!.validate()){
                var payload = await AuthHelper().signIn(
                    email:_selectedType=="Voter"?emailVoter.text:_selectedType=="Candidate"?emailCandid.text:emailSystem.text,
                    password: _selectedType=="Voter"?passwordVoter.text:_selectedType=="Candidate"?passwordCandid.text:passwordSystem.text,role: _selectedType);
                if(payload is String){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        payload,
                        style: const TextStyle(fontSize: 16)),
                  ));
                  return;
                }
                user = payload;
                if(payload['role']=="System"){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SystemHome()));
                }else if(payload['role']=='Voter'){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Societies()));
                }
                else{
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StatusScreen()));
                }
              }},
                style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical:widthSpace(4))),
                child: CustomText(value:"SUBMIT",fontWeight: FontWeight.w500,color: Colors.white,)),
            if(_selectedType!="System")...[
              SizedBox(height: heightSpace(1)),
              TextButton(onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Registration()));
              },child: CustomText(value: "Don't have an account? Please register.",fontWeight: FontWeight.w500,textAlign: TextAlign.end)),
            ],
          ]),
        ),
      )
    );
  }
}
