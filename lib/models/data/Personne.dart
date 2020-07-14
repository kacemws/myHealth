
import 'package:flutter/cupertino.dart';

class Personne{
  String id;
  final String nom;
  final String prenom;
  final String email;
  final DateTime birthday;

  Personne({this.id, @required this.nom, @required this.prenom, @required this.email, @required this.birthday});
}