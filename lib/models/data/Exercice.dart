
import 'package:flutter/foundation.dart';

import 'Difficulte.dart';
import 'Objectif.dart';

class Exercice with ChangeNotifier{

  final String id;
  final String nom;
  final int duree; //le tout en minute puis y'aura une conversion
  final Map<String,String> etapes;
  final Difficulte difficulte;
  final String imageUrl;

  final Objectif objectif;

  Exercice({@required this.id, @required this.nom, @required this.duree, @required this.etapes, @required this.difficulte, @required this.objectif, @required this.imageUrl});
}