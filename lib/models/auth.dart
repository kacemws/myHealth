import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/foundation.dart';

import 'HttpException.dart';
import 'data/Client.dart';


class Auth with ChangeNotifier{



  
  Future<void> _authenticate( String email, String password, String urlSegment,{Client newOne}) async {

    
    try {
      AuthResult aux;

      if(urlSegment == "signUp"){

        aux = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

        print("bout to add user to db");
        var data = {
          "birthday" : newOne.birthday.toIso8601String(),
          "email" : newOne.email,
          "firstName" : newOne.prenom,
          "lastName" : newOne.nom,
          "height" : newOne.taille,
          "weight" : newOne.poids,
          "plan : " : newOne.plan, 
        };
        await Firestore.instance.collection("People").document(aux.user.uid).setData(data);
        print("added user to db");

      }else{
        aux = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      }
           
    } catch (error) {
      print(error);
      throw HttpException(error.toString());
    }
  }
  
  Future<void> signup(String email, String password, Client newOne) async {
    return _authenticate(email, password, 'signUp', newOne: newOne);
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  

  
}