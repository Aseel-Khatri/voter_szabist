import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference students = FirebaseFirestore.instance.collection('students');
  get user => _auth.currentUser;
  late SharedPreferences _prefs;

  Future signUp({fname,required lname,required registerId,required program,required regEmail,required privateEmail,required password,String role = "voter"}) async {
    try {
      var formData = {'fname': fname,'lname':lname,'registerId':registerId, 'regEmail': regEmail,'privateEmail':privateEmail, 'program': program,'role':role,'isVerified':false};
      UserCredential user = await  _auth.createUserWithEmailAndPassword(email: regEmail,password: password);
      students.doc(user.user?.uid).set(formData).then((value){
        formData['uid']= user.user?.uid;
      });
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
  approveAccount(uid){
    try {
      return students.doc(uid).update({"isVerified":true}).then((value){
        return "This account has been approved now.";
      });
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN IN METHOD
  Future signIn({required String email, required String password,String role = "Voter"}) async {
    try {
      UserCredential user = await _auth.signInWithEmailAndPassword(email: email, password: password);
      _prefs= await SharedPreferences.getInstance();
      print(user.user?.uid);
      return students.doc(user.user?.uid).get().then((DocumentSnapshot value){
        Map payload = value.data() as Map;
        if(payload['isVerified']){
          if(payload['role']!=role){
            return "Please login from a ${payload['role']} form.";
          }
          payload['uid']= user.user?.uid;
          _prefs.setString(jsonEncode(payload), 'user');
          return payload;
        }else{
          signOut();
         return "Your account is not verified yet, please ask system to verify it.";
        }
      });
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN OUT METHOD
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
