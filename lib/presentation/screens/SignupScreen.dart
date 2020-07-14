
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../../models/auth.dart';
import '../../models/data/Client.dart';

import '../../models/HttpException.dart';

class SignupScreen extends StatefulWidget {
  static final route = "/signup-screen";
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final _lastNameField = FocusNode(); //to move to the other textfield
  final _numPermisField = FocusNode();
  final _emailField = FocusNode();
  final _telephoneField = FocusNode();
  final _passwordField = FocusNode();
  final _confirmPassword = FocusNode();

  TextEditingController passwordController = new TextEditingController();
  
  Map<String,Object> _userInfos = {
    "firstName" : "",
    "lastName" : "",
    "numPermis" : "",
    "telephone" : "",
    "Birthdate" : "",
    "email" : "",
    "password" : ""
  };

  var _hidePassword = true;
  var _isloading = false;
  DateTime selectedDate;

  var _formKey = GlobalKey<FormState>();  // to control the form 

  void switchToggle(){ // function that changes to visibility of the password
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }


  @override
  Widget build(BuildContext context) {


    void _showErrorDialog(String message) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Erreur!'),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }

    void selectdate(){
    showDatePicker(
      context: context,
      initialDate: DateTime.now(), 
      firstDate: DateTime(1940), 
      lastDate: DateTime.now(),        
    ).then(
      (pickedDate){
        if(pickedDate == null)
          return;
        setState(() {
          selectedDate = pickedDate;
          _userInfos["Birthdate"] = selectedDate;
        });
      }
    );
  }

    Future<void> _saveFields() async{

      FocusScope.of(context).unfocus();

      var isValid = _formKey.currentState.validate();

      if(!isValid) return;
      
      _formKey.currentState.save();
      print(_userInfos["lastName"]);
      

      setState(() {
        _isloading = true;
      });

      try{
        if(_userInfos["Birthdate"] == "")
          throw Exception("Veuillez choisir une date de naissance");

        if(selectedDate.isAfter( DateTime.now().subtract(Duration(days: 6570))))//18 years == 6570 days
          throw Exception("Vous devez Avoir 18 ans");
        
        var newOne = Client(
          nom: _userInfos["firstName"],
          prenom: _userInfos["lastName"],
          birthday: _userInfos["Birthdate"],
          email: _userInfos["email"],
          taille: _userInfos["height"],
          poids: _userInfos["weight"],
          plan: null,
          objectif: null
        );
        
        print("about to signup!");

        await Provider.of<Auth>(context, listen: false).signup(
          _userInfos['email'],
          _userInfos['password'],
          newOne
        );

        print("all done!");
        Navigator.of(context).pop();
        
      } on HttpException catch(error){
        var errorMessage = 'Erreur Lors De L\'inscription, Veuillez réessayer ulterieurement';

        if (error.toString().contains('EMAIL_ALREADY_IN_USE')) {
          errorMessage = 'Email Utilisé! Veuillez saisir un autre email';
        } else if (error.toString().contains('INVALID_EMAIL')) {
          errorMessage = 'Email Invalide! Veuillez saisir un email valide';
        } else if (error.toString().contains('WEAK_PASSWORD')) {
          errorMessage = 'Mot De Passe Faible! Veuillez choisir un mot de passe d\'au moins 6 caractères';
        }
        _showErrorDialog(errorMessage);
      } catch(error){
        var errorMessage = 'Erreur Lors De L\'inscription, Veuillez réessayer ulterieurement';

        if(error.toString().contains("Veuillez choisir une date de naissance")){
          errorMessage = "Veuillez choisir une date de naissance";
        }
        else if(error.toString().contains("Vous devez Avoir 18 ans")){
          errorMessage = "Vous devez Avoir 18 ans";
        }
        _showErrorDialog(errorMessage);
      }
      setState(() {
        _isloading = false;
      });
    
    }

    var _height = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.bottom - MediaQuery.of(context).padding.top ; // the height of the current screen
    var _width = MediaQuery.of(context).size.width; // the width of the current screen

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        top: true,
        bottom: true,
        right: true,
        left: true,
        child: SingleChildScrollView(
          
          child: Column(
            children: <Widget>[
              SizedBox( // some space before the arrow
                height: _height * 0.025,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(icon: Icon(Icons.arrow_back), onPressed: ()=>Navigator.of(context).pop())
                ],
              ),

              SizedBox( // some space before the main title
                height: _height * 0.1,
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: _height * 0.0075, horizontal: _width * 0.08),
                alignment: Alignment.topLeft,
                child: Row(
                  children: <Widget>[
                    Text(
                      "Sign",
                      style: Theme.of(context).textTheme.display1,
                    ),

                    Text(
                      "UP",
                      style: Theme.of(context).textTheme.display1.copyWith(
                        color: Colors.amber,
                      ),
                    ),

                  ],
                ),
              ),

              SizedBox(
                height: _height * 0.02,
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: _height * 0.0075, horizontal: _width * 0.08),
                child: Form(
                  key : _formKey,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: <Widget>[

                      TextFormField(

                        decoration: InputDecoration(
                          labelText: "Nom",
                          labelStyle: Theme.of(context).textTheme.body2
                        ),

                        onFieldSubmitted: (_){
                          FocusScope.of(context).requestFocus(_lastNameField); // move to the other textfield
                        },

                        validator: (value){
                          if(value.isEmpty) return "Please insert a valid name";
                          return null;
                        },

                        onSaved: (value){
                          _userInfos["firstName"] = value;
                        },

                        textInputAction: TextInputAction.next,
                          
                      ),

                      SizedBox(
                        height: _height * 0.015,
                      ),

                      TextFormField(

                        decoration: InputDecoration(
                          labelText: "Prenom",
                          labelStyle: Theme.of(context).textTheme.body2,
                        ),

                        focusNode: _lastNameField,

                        textInputAction: TextInputAction.next,
                        
                        validator: (value){
                           return value.isEmpty || value.isEmpty? "insert a valid name" : null;
                        },

                        onFieldSubmitted: (_){
                          FocusScope.of(context).requestFocus(_numPermisField); // move to the other textfield
                        },

                        onSaved: (value){
                          _userInfos["lastName"] = value;
                        },                      

                      ),

                      

                      SizedBox(
                        height: _height * 0.015,
                      ),

                      Container(
                        alignment: Alignment.centerLeft,
                        child : Text("Date De Naissance", style: Theme.of(context).textTheme.body2,)
                      ),
                      SizedBox(
                        height: _height * 0.0075,
                      ),
                      Container(
                        child: Row( 
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                          children: [
                            Text((selectedDate == null)?"Choisir une date" : "date choisie :"+ DateFormat.yMd().format(selectedDate), style: Theme.of(context).textTheme.button,),
                            IconButton(icon: Icon(Icons.calendar_today),onPressed: selectdate,color: Colors.amber,)
                          ],
                        ),
                      ),

                      SizedBox(
                        height: _height *0.015,
                      ),

                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Numero de permis",
                          labelStyle: Theme.of(context).textTheme.body2,
                        ),

                        focusNode: _numPermisField,

                        textInputAction: TextInputAction.next,

                        onFieldSubmitted: (_){
                          FocusScope.of(context).requestFocus(_telephoneField); // move to the other textfield
                        },

                        validator: (value){
                          return value.isEmpty? "insert an id" : null;
                        },

                        onSaved: (value){
                          _userInfos["numPermis"] = value;
                        },   

                      ),

                      SizedBox(
                        height: _height * 0.015,
                      ),

                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Numero de telephone",
                          labelStyle: Theme.of(context).textTheme.body2,
                        ),

                        focusNode: _telephoneField,

                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,

                        onFieldSubmitted: (_){
                          FocusScope.of(context).requestFocus(_emailField); // move to the other textfield
                        },

                        validator: (value){
                          return value.isEmpty? "insert a valid phone number" : null;
                        },

                        onSaved: (value){
                          _userInfos["telephone"] = value;
                        },   
                      ),

                      SizedBox(
                        height: _height * 0.015,
                      ),

                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: Theme.of(context).textTheme.body2,
                        ),

                        focusNode: _emailField,

                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,

                        onFieldSubmitted: (_){
                          FocusScope.of(context).requestFocus(_passwordField); // move to the other textfield
                        },

                        validator: (value){
                          return value.isEmpty || !value.contains("@")? "insert a valid email" : null;
                        },

                        onSaved: (value){
                          _userInfos["email"] = value;
                        },   
                      ),
                      SizedBox(
                        height: _height * 0.015,
                      ),
                      TextFormField(

                        decoration: InputDecoration(
                          labelText: "Mot de passe",
                          labelStyle: Theme.of(context).textTheme.body2,

                          suffixIcon: IconButton(
                            icon: Icon(_hidePassword? Icons.visibility : Icons.visibility_off), 
                            onPressed: switchToggle
                          ),
                        ),

                        focusNode: _passwordField,
                        obscureText: _hidePassword,

                        validator: (value){
                          return value.isEmpty? "insert a valid password" : null;
                        },

                        onFieldSubmitted: (_){
                          FocusScope.of(context).requestFocus(_confirmPassword); // move to the other textfield
                        },

                        onSaved: (value){
                          _userInfos["password"] = value;
                        },  

                        textInputAction: TextInputAction.next,

                        

                        controller: passwordController,

                      ),

                      SizedBox(
                        height: _height * 0.015,
                      ),

                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Confirmez Mot de passe",
                          labelStyle: Theme.of(context).textTheme.body2,
                        ),
                  
                        textInputAction: TextInputAction.done,

                        validator: (value){
                          return value.isEmpty || value != passwordController.text? "password not corresponding" : null;
                        },

                        obscureText: true,

                        focusNode: _confirmPassword,

                        onFieldSubmitted: (_){
                          _saveFields();
                        },
              
                      ),

                    ]
                  ),
                ),
              ), 

              Container(
                margin: EdgeInsets.symmetric(vertical: _height * 0.04, horizontal: _width * 0.05),

                width: _width * 0.55,
                child: _isloading? Center(child: CircularProgressIndicator(),) : RaisedButton(
                  onPressed: () => _saveFields(),
                  color: Colors.amber,

                  child: Text(
                    "Signup",
                    style: Theme.of(context).textTheme.button.copyWith(
                      color : Colors.white,
                    ),
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ), 

            ],
          ),
        ),
      ),
    );
  }
}