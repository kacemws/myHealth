
import 'package:flutter/foundation.dart';
import 'package:health_app/models/HttpException.dart';

import 'Activite.dart';
import 'Exercice.dart';
import 'Nutrition.dart';
import 'Objectif.dart';
import 'Personne.dart';

class Client extends Personne{
  double poids;
  double taille;

  List<Activite> activites;

  List<Objectif> followedObjectifs;
  Nutrition plan;

  Client({String id, @required String nom, @required String prenom, @required String email, @required DateTime birthday, @required this.poids, @required this.taille, @required this.plan, @required Objectif objectif}) : super(
    id : id,
    nom : nom,
    prenom : prenom,
    email : email,
    birthday : birthday
  ){
    activites = [];
    followedObjectifs = [];
    if(objectif != null) this.followObjectif(objectif);
  }


  Activite getCurrentAct(){

    for (Activite act in activites) {
      if(act.dateFin == null) return act;
    }

    return null;
  }// pour récuperer l'activité en cours

  void setCurrentAct(Exercice exercice){

    if(this.getCurrentAct() != null) throw Exception("Vous etes entrain de faire une activité !");

    Activite activite = new Activite(id: this.id+exercice.id, dateDebut: DateTime.now(), client: this, exo: exercice);
    activites.add(activite);

  }

  void followObjectif(Objectif obj){
    if(followedObjectifs.contains(obj)) throw Exception("vous suivez déjà cette objectif");
    followedObjectifs.add(obj);
  }

  List<Exercice> doneExercices(){
    List<Exercice> aux = [];

    for(Activite activite in activites){ // parcours toutes activités pour
      if (! aux.contains(activite.exo)) aux.add(activite.exo);
    }

    return aux;
  }

  Activite getActiviteById(String id){

    for (Activite act in activites) {
      if(act.id == id) return act;
    }

    return null;
  }
}