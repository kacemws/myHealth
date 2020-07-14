import 'package:flutter/foundation.dart';
import 'package:health_app/models/data/Exercice.dart';

import 'Difficulte.dart';
import 'Objectif.dart';

class ExoPhysique extends Exercice{
  final double kcal;

  ExoPhysique({@required String id, @required String nom, @required double duree, @required Map<String,String> etapes, @required Difficulte difficulte, @required Objectif objectif, @required this.kcal}) : super(
    id : id, 
    nom : nom, 
    duree : duree, 
    etapes : etapes, 
    difficulte : difficulte, 
    objectif : objectif
  );
}