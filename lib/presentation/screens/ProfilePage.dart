

import 'package:flutter/material.dart';
import 'package:health_app/models/Health.dart';
import 'package:health_app/models/auth.dart';
import 'package:health_app/models/data/Client.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    var health = Provider.of<Health>(context);
    var auth= Provider.of<Auth>(context, listen: false);

    Future<void> logout() async{
      await auth.logout();
    }

    return LayoutBuilder(
      builder: (_,constraints)=>Container(

        width: constraints.maxWidth,
        height: constraints.maxHeight,
        color: Colors.grey[100],
        child: Column(
          children: <Widget>[

            space(constraints.maxHeight * 0.05),//0.05

            userGreeting(constraints.maxHeight, constraints.maxWidth, context), //0.1

            title("Informations Personnelles",constraints, context),//0.1
            subtitle("Taille : " + health.loggedIn.taille.toString() + " cm", constraints.maxHeight, constraints.maxWidth, context),
            subtitle("Poids : "+ health.loggedIn.poids.toString() + " kg", constraints.maxHeight, constraints.maxWidth, context),

            title("Statistique",constraints, context),//0.1
            statistique(constraints.maxHeight, constraints.maxWidth, context, health.loggedIn),

            Expanded(child: SizedBox()),
            logoutButton(constraints.maxHeight, constraints.maxWidth, context, logout),
            space(constraints.maxHeight * 0.025)
      
            ],
          ),

      ),
    );
  }

  Widget space(double spaceHeight){
    return SizedBox(
      height: spaceHeight
    );
  }


  Widget userGreeting(double height,double width, BuildContext context){

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: width *0.05,
        vertical: height *0.01
      ),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[


          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "Profile",
              style: Theme.of(context).textTheme.display2.copyWith(
                color: Colors.purple[400],
                fontWeight: FontWeight.bold
              ),
            ),
          ),

        ],
      ),
    );

  }

  Widget title(String text, BoxConstraints constraints, BuildContext context, {AlignmentGeometry alignment}){
    return Container(
      height: constraints.maxHeight *0.08,
      margin: EdgeInsets.symmetric(
        horizontal: constraints.maxWidth *0.05,
        vertical: constraints.maxHeight *0.01
      ),
      alignment: alignment??Alignment.centerLeft,
      child: FittedBox(
        fit:BoxFit.scaleDown,
        child: Text(
          text,
          style: Theme.of(context).textTheme.body2.copyWith(
            color: Colors.purple[400],
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  Widget subtitle(String text, double height, double width, BuildContext context, {AlignmentGeometry alignment}){
    return Container(
      height: height *0.05,
      margin: EdgeInsets.symmetric(
        horizontal: width *0.075,
      ),
      alignment: alignment??Alignment.centerLeft,
      child: FittedBox(
        fit:BoxFit.scaleDown,
        child: Text(
          text,
          style: Theme.of(context).textTheme.subtitle
        ),
      ),
    );
  }

  Widget logoutButton(double _height, double _width, BuildContext context, Function handler){
    return GestureDetector(
      onTap: handler,
      child: Container(

        height: _height * 0.075,

        margin: EdgeInsets.symmetric(
          horizontal: _width *0.05,
          vertical: _height * 0.0125
        ),

        decoration: BoxDecoration(
          color: Colors.purple[100],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [

            BoxShadow(
              blurRadius: 5,
              color: Colors.black38,
              offset: Offset(2.5, 2.5)
            ),
            BoxShadow(
              blurRadius: 5,
              color: Colors.white,
              offset: -Offset(2.5, 2.5)
            ),
          ]
        ),

        child: Center(child: Text( "Se Deconnecter", style: Theme.of(context).textTheme.title.copyWith(color:Colors.white),)),

      ),
    );
  }

  Widget statistique(double height, double width, BuildContext context, Client loggedIn){
    return Container(
      height : height *0.4,
      width: width*0.8,
      // color: Colors.red,
      alignment: Alignment.center,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: <Widget>[
          Container(

            height : height *0.3,
            width: height *0.3,

            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.purple[200]),
              value: loggedIn.plan.kcalConsome / loggedIn.plan.kcalVise,
            ),
          ),

          subtitle(loggedIn.plan.kcalConsome.toString() + " Kcal consomé / "+ loggedIn.plan.kcalVise.toString() + " Kcal visé", height, width, context, alignment: Alignment.center),

        ],
      ),
    );
  }
}