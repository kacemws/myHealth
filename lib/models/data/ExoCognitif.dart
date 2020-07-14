import 'package:flutter/foundation.dart';
import 'package:health_app/models/data/Exercice.dart';

import 'Difficulte.dart';
import 'Objectif.dart';

class ExoCognitif extends Exercice{
  ExoCognitif({@required String id, @required String nom, @required int duree, @required Map<String,String> etapes,@required String imageUrl, @required Difficulte difficulte, @required Objectif objectif}) : super(
    id : id, 
    nom : nom, 
    duree : duree, 
    etapes : etapes, 
    difficulte : difficulte, 
    objectif : objectif,
    imageUrl : imageUrl
  );

}