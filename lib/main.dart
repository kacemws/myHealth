import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_app/models/data/Objectif.dart';
import 'package:health_app/presentation/screens/ExerciceDetails.dart';
import 'package:health_app/presentation/screens/ObjectifDetails.dart';
import 'package:provider/provider.dart';

import 'Presentation/Screens/Authentification.dart';
import 'Presentation/Screens/SignupScreen.dart';
import 'Presentation/Screens/SplashScreen.dart';


import 'Presentation/Screens/MainAppScreen.dart';
import 'models/auth.dart';
import 'models/Health.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.grey[100],
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.grey[100],
      systemNavigationBarIconBrightness: Brightness.dark
    ));

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(

      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth()
        ),

        ChangeNotifierProvider(
          create: (context) => Health()
        ),

      ],

      child: MaterialApp(

        debugShowCheckedModeBanner: false,

        title: 'MyHealth',
          
        theme: ThemeData(
            
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.transparent
          ),

          appBarTheme: AppBarTheme(
            color: Colors.white, 
            elevation: 0
          ),

          textTheme: TextTheme(
              
            title: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black
            ),

            subtitle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black
            ),

            display1: TextStyle(
              //FirstScreen
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: Colors.black
            ),

            body2: TextStyle(
              //Labels in forms
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),

            overline: TextStyle(
              //Labels in forms
              fontSize: 16,
              //fontWeight: FontWeight.bold
            ),
            button: TextStyle(
              fontSize: 16,
            ),
          ),

          primaryColor: Colors.grey[100],
          primarySwatch: Colors.purple
        ),
          
        home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.active){

              if(snapshot.hasData){
                return MainAppScreen();
              }

              return Authentification();
            }else{
              return SplashScreen();
            }
          },
        ),
        routes: {
          // '/': (context) => Authentification(),
          SignupScreen.route: (context) => SignupScreen(),
          ObjectifDetails.route : (context) => ObjectifDetails(),
          ExerciceDetails.route : (context) => ExerciceDetails(),
        },
      ),
    );
  }
}
