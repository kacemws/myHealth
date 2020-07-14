import 'package:flutter/foundation.dart';

import 'Exercice.dart';

class Objectif{
  final String id;
  final String name;

  List<Exercice> exercices;

  Objectif({@required this.id, @required this.name}){
    this.exercices = [];
  }


}