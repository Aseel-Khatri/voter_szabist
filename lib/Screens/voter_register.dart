import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:voter_szabist/components/common_button.dart';
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
  TextEditingController first = TextEditingController();
  TextEditingController last = TextEditingController();
  TextEditingController regId = TextEditingController();
  TextEditingController regEmail = TextEditingController();
  TextEditingController privateEmail = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController program = TextEditingController();

  String _selectedType = "Voter";
  String? image;
  int? selectedSociety,selectedPosition;
  final LocalAuthentication auth = LocalAuthentication();
  bool isLoading = false,withdrawn=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal:widthSpace(10),vertical: heightSpace(10)),
          child: Form(
            key: _formKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.center,children: [
              CustomText(value: "Powered By",textAlign: TextAlign.center),
              Container(
                width: widthSpace(45),
                height: widthSpace(45),
                margin: EdgeInsets.symmetric(vertical: heightSpace(3)),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: AssetImage('assets/logo.png'),fit: BoxFit.contain)),
              ),
              CustomText(value: "$_selectedType ${user!=null?"Edit Profile":"Registration Form"}",fontSize: 2.7,textAlign: TextAlign.center,fontWeight: FontWeight.w500),
              if(user==null)...[
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
              ],
              SizedBox(height: heightSpace(4)),
              Row(
                children: [
                  InkWell(
                      onTap: profileUpload,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                    width: widthSpace(40),
                    height: widthSpace(40),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey
                      )
                    ),
                    child:  image!=null?image!.contains('profile_image')?Image.network(image!):Image.file(File(image!)): const Icon(Icons.add_a_photo_outlined),
                  )),
                  const SizedBox(width:10),
                  Expanded(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     CustomText(value:"Profile Picture",fontWeight: FontWeight.w500),
                      CustomText(value:"You must upload a clear picture of your face.",color: Colors.grey,fontSize:1.6),
                    ]),
                  )
                ],
              ),
              CustomTextField(controller: first, hintText: "First Name",validator: (val)=>val.isEmpty?"Please fillout this field":null),
              SizedBox(height: heightSpace(2)),
              CustomTextField(controller: last, hintText: "Last Name",validator: (val)=>val.isEmpty?"Please fillout this field":null),
              SizedBox(height: heightSpace(2)),
              CustomTextField(
                controller: regId,
                hintText: "Register-ID",
                onChanged: onRegIDChanged,
                validator: (val)=>val.isEmpty?"Please fillout this field":null,
                editable: user==null,
              ),
              SizedBox(height: heightSpace(2)),
              CustomTextField(controller: regEmail,editable:false, hintText: "regId@stu.smiu.edu.pk",textInputType: TextInputType.emailAddress,validator: (val){
                return val.isEmpty?"Please fillout this field": EmailValidator.validate(val)?null:"Please enter valid Email-Address";
              }),
              SizedBox(height: heightSpace(2)),
              CustomTextField(controller: privateEmail, hintText: "Email",textInputType: TextInputType.emailAddress,validator: (val){
                return val.isEmpty?"Please fillout this field": EmailValidator.validate(val)?null:"Please enter valid Email-Address";
              }),
              SizedBox(height: heightSpace(2)),
              CustomTextField(controller: program, hintText: "Program",textInputType:TextInputType.emailAddress,validator: (val)=>val.isEmpty?"Please fillout this field":null),
              SizedBox(height: heightSpace(2)),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                    border: Border(bottom: BorderSide())
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    hint: Text('Select society to enroll with in it',style: TextStyle(fontSize: 15)),
                    value: selectedSociety,
                    isExpanded: true,
                    padding: EdgeInsets.symmetric(horizontal:10),
                    items: societies.map((e){
                    return DropdownMenuItem(
                      value: e['id'] as int,
                      child: Text('${e['name']}',style: TextStyle(fontSize: 15)),
                    );
                  }).toList(), onChanged: (value) {
                      setState(()=>selectedSociety = value);
                  }),
                ),
              ),
              if(selectedSociety!=null && _selectedType=="Candidate")...[
                SizedBox(height: heightSpace(2)),
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(bottom: BorderSide())
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                        hint: const Text('Select a position you are standing for.',style: TextStyle(fontSize: 15)),
                        value: selectedPosition,
                        isExpanded: true,
                        padding: const EdgeInsets.symmetric(horizontal:10),
                        items: positions.map((e){
                          return DropdownMenuItem(
                            value: e['id'] as int,
                            child: Text('${e['name']}',style: const TextStyle(fontSize: 15)),
                          );
                        }).toList(), onChanged: (value) {
                      setState(()=>selectedPosition = value);
                    }),
                  ),
                ),
              ],
              if(user==null)...[
                SizedBox(height: heightSpace(2)),
                CustomTextField(controller: password, hintText: "Password",obscureText:true,validator: (val)=>val.isEmpty?"Please fillout this field":null),
              ],
              if(user?['role']=='Candidate')...[
                SizedBox(height: heightSpace(2)),
                Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                        onTap: ()=>setState(()=>withdrawn=!withdrawn),
                        child: Container(
                      width: double.maxFinite,
                        padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(bottom: BorderSide())
                      ),
                        child: CustomText(value:withdrawn?"I don't want to withdraw my self":"Withdraw from your position",
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w500,fontSize: 1.75)))),
                SizedBox(height: heightSpace(.5)),
                Align(
                    alignment: Alignment.centerLeft,
                  child: CustomText(
                      value:'Note: ${withdrawn?'Click save button to make changes, click again to undo to withdrawal':'Once withdrawn can not be undone, be careful !'}',
                      fontSize: 1.65),
                )
              ],
              // SizedBox(height: heightSpace(2)),
              // InkWell(onTap: recordAuth,child:Container(
              //   padding: EdgeInsets.all(10),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     border: Border(bottom: BorderSide())
              //   ),child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //     CustomText(value: "Capture your finger print",fontSize: 1.6),
              //   Icon(Icons.fingerprint_rounded)
              // ]),
              // )),
              SizedBox(height: heightSpace(4)),
              CommonButton(onPressed: ()async{
                register();
              },
                  isLoading:isLoading,
                  title:user==null?'Submit':'Save'),
              if(user==null)...[
                SizedBox(height: heightSpace(2)),
                TextButton(
                    onPressed:(){Navigator.pop(context);},
                    child: CustomText(value: "Already have an account? Please login.",
                        fontWeight: FontWeight.w500,textAlign: TextAlign.end)),
              ],
            ]),
          ),
        )
    );
  }
  // recordAuth()async{
  //   if(await auth.canCheckBiometrics && await auth.isDeviceSupported()){
  //     final biometric =await auth.authenticate(localizedReason: 'Your biometric will be used to authenticate while casting a vote.');
  //     print(biometric.);
  //   }
  // }
  profileUpload(){
    ImagePicker().pickImage(source: ImageSource.gallery).then((res){
      if(res!=null){
        setState(()=>image = res.path);
      }
    });
  }
onRegIDChanged(val){
    regEmail.text = "$val@stu.smiu.edu.pk";
}
register()async{
  if(image==null){
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please upload a profile picture.')));
    return;
  }
  if(selectedSociety==null){
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select society to enroll with in it.')));
    return;
  }
  if(selectedPosition==null && _selectedType=="Candidate"){
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a position you are standing for.')));
    return;
  }
  if(_formKey.currentState!.validate()){
    setState(()=>isLoading=true);
    var payload = await AuthHelper().signUp(
        fname: first.text,
        lname: last.text,
        registerId: regId.text,
        program: program.text,
        regEmail: regEmail.text,
        privateEmail: privateEmail.text,
        password: password.text,
        image: image!,
        societyId:selectedSociety!,
        positionId:selectedPosition??0,
        withdrawn:withdrawn,
        role: _selectedType
    );
    setState(()=>isLoading=false);
    if(payload is String){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          payload,
          style: const TextStyle(fontSize: 16),
        ),
      ));
    }else{
      if(user!=null){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Profile has been Updated successfully',
            style: TextStyle(fontSize: 16),
          ),
        ));
        return;
      }
      showDialog(context: context, builder: (context_)=>AlertDialog(title:CustomText(value:"Registered Successfully",color: themeColor,fontSize: 2.1,fontWeight: FontWeight.bold),content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(value:"Your email ${regEmail.text} has been registered successfully, please wait for the system to verify it.",fontWeight: FontWeight.w500,fontSize: 1.9,color: Colors.black87),
          const SizedBox(height:6),
          CustomText(value:"Please don't use your private email for registration.",fontSize: 1.7,color: Colors.black38),
        ],
      ),actions: [
        TextButton(
          child: const Text("OK",style: TextStyle(color: Colors.white)),
          style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => themeColor)),
          onPressed: () {
            Navigator.pop(context_);
            Navigator.pop(context);
          },
        )
      ]));
    }
  }
}
@override
  void initState() {
    if(user!=null){
      _selectedType =user!['role'];
      image = user!['profile'];
      first.text = user!['fname'];
      last.text = user!['lname'];
      regId.text = user!['registerId'];
      regEmail.text = user!['regEmail'];
      privateEmail.text = user!['privateEmail'];
      program.text = user!['program'];
      selectedSociety = user!['societyId'];
      if(user!['role']=='Candidate'){
        selectedPosition = user!['positionId'];
        withdrawn = user?['withdrawn']??false;
      }
      setState((){});
    }
    super.initState();
  }
}