import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:voter_szabist/components/text_field.dart';
import 'package:voter_szabist/utils/auth_helper.dart';
import 'package:voter_szabist/utils/constants.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  // XFile? profile;
  TextEditingController first = TextEditingController();
  TextEditingController last = TextEditingController();
  TextEditingController regId = TextEditingController();
  TextEditingController regEmail = TextEditingController();
  TextEditingController privateEmail = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController program = TextEditingController();

  String _selectedType = "Voter";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal:widthSpace(10),vertical: heightSpace(10)),
          child: Form(
            key: _formKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,children: [
              CustomText(value: "Powered By",textAlign: TextAlign.center),
              Image.asset("assets/logo.png",scale: 5.3),
              SizedBox(height: heightSpace(5)),
              CustomText(value: "$_selectedType Registration Form",fontSize: 2.7,textAlign: TextAlign.center,fontWeight: FontWeight.w500),
              const SizedBox(height: 2),
              CustomText(value: "Register yourself to support your candidate",fontSize: 1.7,color: Colors.black38,textAlign: TextAlign.center),
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
                )
              ])),
              SizedBox(height: heightSpace(4)),
              InkWell(child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all()
                ),
                child: const Icon(Icons.add_a_photo_outlined),
              )),
              CustomTextField(controller: first, hintText: "First Name",validator: (val)=>val.isEmpty?"Please fillout this field":null),
              SizedBox(height: heightSpace(2)),
              CustomTextField(controller: last, hintText: "Last Name",validator: (val)=>val.isEmpty?"Please fillout this field":null),
              SizedBox(height: heightSpace(2)),
              CustomTextField(controller: regId, hintText: "Register-ID", onChanged: onRegIDChanged,validator: (val)=>val.isEmpty?"Please fillout this field":null),
              SizedBox(height: heightSpace(2)),
              CustomTextField(controller: regEmail,editable:false, hintText: "regId@szabist.com",textInputType: TextInputType.emailAddress,validator: (val){
                return val.isEmpty?"Please fillout this field": EmailValidator.validate(val)?null:"Please enter valid Email-Address";
              }),
              SizedBox(height: heightSpace(2)),
              CustomTextField(controller: privateEmail, hintText: "Email",textInputType: TextInputType.emailAddress,validator: (val){
                return val.isEmpty?"Please fillout this field": EmailValidator.validate(val)?null:"Please enter valid Email-Address";
              }),
              SizedBox(height: heightSpace(2)),
              CustomTextField(controller: password, hintText: "Password",obscureText:true,validator: (val)=>val.isEmpty?"Please fillout this field":null),
              SizedBox(height: heightSpace(2)),
              CustomTextField(controller: program, hintText: "Program",textInputType:TextInputType.emailAddress,validator: (val)=>val.isEmpty?"Please fillout this field":null),
              SizedBox(height: heightSpace(4)),
              ElevatedButton(onPressed: ()async{
                if(_formKey.currentState!.validate()){
                  var payload = await AuthHelper().signUp(
                      fname: first.text,
                      lname: last.text,
                      registerId: regId.text,
                      program: program.text,
                      regEmail: regEmail.text,
                      privateEmail: privateEmail.text,
                      password: password.text,
                      role: _selectedType
                  );
                  if(payload is String){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        payload,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ));
                  }else{
                    showDialog(context: context, builder: (context_)=>AlertDialog(title:CustomText(value:"Registered Successfully",color: themeColor,fontSize: 2.1,fontWeight: FontWeight.bold),content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(value:"Your email ${regEmail.text} has been registered successfully, please wait for the system to verify it.",fontWeight: FontWeight.w500,fontSize: 1.9,color: Colors.black87),
                        const SizedBox(height:6),
                        CustomText(value:"Please don't use your private email for registration.",fontSize: 1.7,color: Colors.black38),
                      ],
                    ),actions: [
                      TextButton(
                        child: const Text("OK"),
                        onPressed: () {
                          Navigator.pop(context_);
                          Navigator.pop(context);
                        },
                      )
                    ]));
                  }
                }
              },
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical:widthSpace(4))),
                  child: CustomText(value:"SUBMIT",fontWeight: FontWeight.w500,color: Colors.white)),
              SizedBox(height: heightSpace(2)),
              TextButton(onPressed:(){Navigator.pop(context);},child: CustomText(value: "Already have an account? Please login.",fontWeight: FontWeight.w500,textAlign: TextAlign.end)),
            ]),
          ),
        )
    );
  }
onRegIDChanged(val){
    regEmail.text = "$val@stu.smiu.edu.pk";
}
}
