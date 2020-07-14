import 'package:flutter/foundation.dart';

import 'Exercice.dart';

class Objectif with ChangeNotifier{
  final String id;
  final String nom;
  final String imageUrl;

  List<Exercice> exercices;

  Objectif({@required this.id, @required this.nom, @required this.imageUrl}){
    this.exercices = [];
  }


}