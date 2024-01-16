import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'constants.dart';

class AuthHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference students = FirebaseFirestore.instance.collection('students');
  // get user => _auth.currentUser;
  late SharedPreferences _prefs;
  final storageRef = FirebaseStorage.instance.ref();
  Future<String> uploadPic(String image,String regId) async {
    Reference reference = storageRef.child("profile_images/$regId.png");
    try{
      await reference.putFile(File(image));
      return await reference.getDownloadURL();
    }catch(e){
      print("Storageeroor: $e");
      rethrow;
    }
  }
  Future signUp({fname,required lname,required registerId,required program,required regEmail,required privateEmail,required password,required String image,required int societyId,required int positionId,String role = "voter",bool withdrawn=false,bool isEdit=false}) async {
    try {
      var formData = {'fname': fname,'lname':lname,'registerId':registerId, 'regEmail': regEmail,'privateEmail':privateEmail,
        'societyId':societyId,
        'positionId':positionId,
        'program': program,'role':role,'isVerified':false,'withdrawn':withdrawn};
      String? user_ = user!=null?user!['uid']:(await _auth.createUserWithEmailAndPassword(email: regEmail,password: password)).user?.uid;
      if(image!=user?['profile']){
        String imgPath = await uploadPic(image,registerId);
        formData['profile'] = imgPath;
      }
      if(user!=null){
        user!.addAll(formData);
      }
      students.doc(user_).set(formData,SetOptions(merge: true)).then((value){
        formData['uid']= user_;
      });
      print(formData);
      return true;
    } on FirebaseAuthException catch (e) {
      print("yhn serror: ${e}");
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
    user = null;
    await _auth.signOut();
  }
}
