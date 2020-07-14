/*Class that acts as a provider between the bl and the front end, containts all methods and objects.*/

import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_app/models/data/Activite.dart';
import 'package:health_app/models/data/Difficulte.dart';
import 'package:health_app/models/data/Exercice.dart';
import 'package:health_app/models/data/ExoCognitif.dart';
import 'package:health_app/models/data/ExoPhysique.dart';
import 'package:health_app/models/data/Nutrition.dart';
import 'package:health_app/models/data/Objectif.dart';

import 'data/Client.dart';





class Health with ChangeNotifier{
  bool loaded = false;
  Client loggedIn;

  final Firestore _db = Firestore.instance;

  List<Objectif> objectifs = [];
  List<Exercice> _exercices = [];

  Health({this.loggedIn, this.objectifs});


  List<Objectif> allObjectifs(){
    return objectifs;
  }


  Objectif getObjectifById(String id){

    for (Objectif objectif in objectifs){
      if(objectif.id == id) return objectif;
    }
    return null;

  }

  Exercice getExerciceById(String id){

    for (Exercice exercice in _exercices){
      if(exercice.id == id) return exercice;
    }
    return null;

  }

  Difficulte getDifficulte(String name){
    if(name == "facile") return Difficulte.facile;
    else if(name == "moyenne") return Difficulte.moyenne;
    return Difficulte.difficile;
  }

  List<Exercice> exercicesRecommande() {

    List<Exercice> doneExercies = loggedIn.doneExercices();
    List<Exercice> aux = [];

    for (Exercice exercice in _exercices) { // on parcours les exercices disponible

      if(!doneExercies.contains(exercice) && loggedIn.followedObjectifs.contains(exercice.objectif) ){ // on vérifie que l'exercice n'est pas déjà fait et qu'il réalise un des objectifs suivis
        aux.add(exercice);
      }

    }

    return aux;

  }
  


  Future<void> fetchData() async{


    await this.fetchObjectifs();
    print("got objectifs");

    await this.fetchExercices();
    print("got exercices");

    await this.fetchUser();
    print("got user");
    
    await this.fetchActivities();
    print("got user's activities");

    loaded = true;
    print("done");

    notifyListeners();
    
  }

  Future<void> fetchUser() async{

    try{

      var user = await FirebaseAuth.instance.currentUser();

      final userDocument = await _db.collection("People").document(user.uid).get();

      final extractedData = userDocument.data;

      if (extractedData == null) {
        return;
      }

      Client aux = new Client(
        id: user.uid,
        nom: extractedData["lastName"],
        prenom: extractedData["firstName"],
        email: extractedData["email"],
        birthday: DateTime.parse(extractedData["birthday"]),
        taille: extractedData["height"],
        poids: extractedData["weight"],
        plan: null,
        objectif : null
      );

      final planData = await _db.collection("Plans").document(extractedData["plan"]).get();

      aux.plan = Nutrition(
        kcalConsome: planData["kcalConsome"],
        kcalVise: planData["kcalVise"],
      );

      loggedIn = aux;
      print(loggedIn.id);

    }catch(error){
      print(error.toString());
      throw error;
    }

  }
  
  Future<void> fetchObjectifs() async{

    try{
      final snapshot = await _db.collection("Objectifs").getDocuments();
      this.objectifs = [];

      snapshot.documents.forEach((document) async{

        print("got objectif "+document.documentID);
        this.objectifs.add(
          objectifFromDocument(document)
        );
        
      });

    }catch(e){
      throw e;
    }
    
  }

  Future<void> fetchExercices() async{

    try{
      final snapshot = await _db.collection("Exercices").getDocuments();
      this._exercices = [];

      snapshot.documents.forEach((document) async{
        print("got exercice "+document.documentID);
        Exercice exo;

        if(document.data.containsKey("kcal")) exo = exoPhysiqueFromDocument(document);
        else exo = exoCognitifFromDocument(document);
        getObjectifById(exo.objectif.id).exercices.add(exo);
        this._exercices.add(exo);
      });


    }catch(e){
      throw e;
    }
    
  }

  Future<void> fetchActivities() async{

    try{

      final snapshot = await _db.collection("Activites").getDocuments();

      loggedIn.activites = [];  

      snapshot.documents.forEach((document) async{

        if(document.documentID.contains(loggedIn.id)){
          print("got activity "+document.documentID);
        
          var data = document.data;

          var aux = Activite(
            id: document.documentID, 
            dateDebut: DateTime.parse(data["dateDebut"]), 
            client: loggedIn,
            exo: getExerciceById(data["exercice"])
          );

          if(data.containsKey("dateFin")) aux.terminerActivite(DateTime.parse(data["dateFin"]));

          this.loggedIn.activites.add(aux);
        }
        
      });

    }catch(error){
      throw error;
    }
  }

  Objectif objectifFromDocument(DocumentSnapshot document){
    var data = document.data ?? {};

    return Objectif(
      id: document.documentID, 
      name: data["name"] ?? "", 
    );

  }

  ExoPhysique exoPhysiqueFromDocument(DocumentSnapshot document){
    var data = document.data ?? {};

    return ExoPhysique(
      id: document.documentID, 
      nom: data["name"] ?? "", 
      duree: double.parse(data["duree"]) ?? 0.0,
      etapes: data["etapes"] ?? {}, 
      difficulte: getDifficulte(data["difficulte"]), 
      objectif: getObjectifById(data["objectif"]), 
      kcal: double.parse(data["kcal"]) ?? 0.0,
    );
  }

  ExoCognitif exoCognitifFromDocument(DocumentSnapshot document){
    var data = document.data ?? {};
    
    return ExoCognitif(
      id: document.documentID, 
      nom: data["name"] ?? "", 
      duree: double.parse(data["duree"]) ?? 0.0,
      etapes: data["etapes"] ?? {}, 
      difficulte: getDifficulte(data["difficulte"]),
      objectif: getObjectifById(data["objectif"]), 
    );
  }
}