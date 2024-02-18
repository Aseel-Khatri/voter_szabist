import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart';
import 'package:voter_smiu/Screens/login.dart';
import 'package:voter_smiu/utils/constants.dart';
import 'package:voter_smiu/utils/size_config.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      SizeConfig().init(constraints);
      return MaterialApp(
        title: 'Voter-Zsabist',
        theme: ThemeData(
          // primarySwatch: MaterialColor(0xff964B00, 0xffEADDCA),
          buttonTheme: const  ButtonThemeData(
            buttonColor: themeColor
          )
        ),
        home: const Login(),
      );
    });
  }
}
