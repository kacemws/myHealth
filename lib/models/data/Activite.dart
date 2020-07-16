

import 'package:flutter/foundation.dart';
import 'package:health_app/models/HttpException.dart';

import 'Client.dart';
import 'Exercice.dart';

class Activite{
  final String id;
  final DateTime dateDebut; // date de debut de l'activité
  DateTime dateFin; // date de fin

  final Client client;
  final Exercice exo;

  Activite({@required this.id, @required this.dateDebut, @required this.client, @required this.exo});

  void terminerActivite(DateTime dateFin){
    if(this.dateFin != null) throw HttpException("Activitée déjà terminée!"); // On peut pas terminer une activité qui l'est déjà! donc on throw une exception
    this.dateFin = dateFin;
  }

}