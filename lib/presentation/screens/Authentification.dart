import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'SignupScreen.dart';

import '../../models/auth.dart';
import '../../models/HttpException.dart';

class Authentification extends StatefulWidget {
  @override
  _AuthentificationState createState() => _AuthentificationState();
}

class _AuthentificationState extends State<Authentification> {

  final passwordField = FocusNode(); //to move to the other textfield
  var _hidePassword = true; // to control wheter we want to show the password or not
  var _isloading = false;

  var _userInfos = {
    "email" : "",
    "password" : ""
  };

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
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }

    Future<void> _saveFields() async{

      FocusScope.of(context).unfocus();
      var isValid = _formKey.currentState.validate();
      if(!isValid) return;
      
      _formKey.currentState.save();

      print(_userInfos["email"]+" : "+_userInfos["password"]);
      setState(() {
        _isloading = true;
      });
      try{
        await Provider.of<Auth>(context, listen: false).login(
          _userInfos['email'],
          _userInfos['password'],
        );
        

      } on HttpException catch(error){
        var errorMessage = 'Authentication failed';

        if (error.toString().contains('INVALID_EMAIL')) {
          errorMessage = 'Email Invalide.';
        } else if (error.toString().contains('ERROR_USER_NOT_FOUND')) {
          errorMessage = 'Email non trouvé.';
        } else if (error.toString().contains('ERROR_WRONG_PASSWORD')) {
          errorMessage = 'Mot De Passe Invalide.';
        }
        _showErrorDialog(errorMessage);
      } catch(error){
        const errorMessage = 'Could not authenticate you. Please try again later.';
        _showErrorDialog(errorMessage);
      }
      setState(() {
        _isloading = false;
      });
    
    }

    var _height = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.bottom; // the height of the current screen
    var _width = MediaQuery.of(context).size.width; // the width of the current screen

    return Scaffold(
      backgroundColor: Colors.white, // background color of the app

      body: SafeArea(
        child: SingleChildScrollView( // in case we want to up the screen
          child: Column( // our list of widgets
            children: <Widget>[

              SizedBox( // some space before the main title
                height: _height * 0.2,
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: _height * 0.0075, horizontal: _width * 0.08),
                alignment: Alignment.topLeft,
                child: Row(
                  children: <Widget>[
                    Text(
                      "My",
                      style: Theme.of(context).textTheme.display1,
                    ),
                    Text(
                      "Health",
                      style: Theme.of(context).textTheme.display1.copyWith(
                        color: Colors.purple[900]
                      ),
                    )
                  ],
                )
              ),

              SizedBox(
                height: _height * 0.1,
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
                          labelText: "Email",
                          labelStyle: Theme.of(context).textTheme.body2
                        ),

                        onFieldSubmitted: (_){
                          FocusScope.of(context).requestFocus(passwordField); // move to the other textfield
                        },

                        validator: (value){
                          if(!value.contains("@") || value.isEmpty) return "Veuillez Introduire Un Email Valide";
                          return null;
                        },

                        onSaved: (value){
                          _userInfos["email"] = value;
                        },

                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        
                          
                      ),

                      SizedBox(
                        height: _height * 0.015,
                      ),

                      TextFormField(

                        decoration: InputDecoration(

                          labelText: "Mot de passe",
                          labelStyle: Theme.of(context).textTheme.body2,

                          suffixIcon: IconButton(
                            icon: Icon(_hidePassword? Icons.visibility_off : Icons.visibility ), 
                            onPressed: switchToggle
                          ),

                        ),

                        focusNode: passwordField,

                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,

                        obscureText: _hidePassword,

                        validator: (value){
                          return value.isEmpty? "Veuillez Introduire Un Mot De Passe" : null;
                        },

                        onFieldSubmitted: (_)=>_saveFields(),

                        onSaved: (value){
                          _userInfos["password"] = value;
                        },                      

                      ),

                      SizedBox(
                        height: _height * 0.02,
                      ),

                      Container(
                        alignment: Alignment.topRight,
                        child: Text(
                          "Mot De Passe Oublié?",
                        ),
                      ),

                      SizedBox(
                        height: _height * 0.02,
                      ),

                    ]
                  )
                )
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: _height * 0.0075, horizontal: _width * 0.05),

                width: _width * 0.55,
                child: _isloading? Center(child: CircularProgressIndicator()) : RaisedButton(
                  onPressed: () => _saveFields(),
                  color: Colors.amber,

                  child: Text(
                    "Login",
                    style: Theme.of(context).textTheme.button.copyWith(
                      color : Colors.white,
                    ),
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: _height * 0.0075, horizontal: _width * 0.05),
                  
                width: _width * 0.55,
                height: _height*0.05,

                // child: RaisedButton(
                //   onPressed: () => print(""),
                //   child: Text("Login with Google"),
                //   color: Colors.white,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(15),
                //     side: BorderSide(color: Colors.black)
                //   ),
                // ),
                child: SizedBox(),

              ),

              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Pas Un Membre?",
                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300),
                    ),

                    GestureDetector(
                      onTap: ()=>Navigator.of(context).pushNamed(
                        SignupScreen.route,
                      ),

                      child:Text(
                        " Inscrivez-Vous",
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300,color: Colors.amber),
                      ),

                    )
                  ],
                ),
              )


            ],
          ),
        ),
      )
    );
  }
}
