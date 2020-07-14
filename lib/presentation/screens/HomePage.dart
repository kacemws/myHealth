
import 'package:flutter/material.dart';
import 'package:health_app/models/Health.dart';
import 'package:health_app/models/data/Exercice.dart';
import 'package:health_app/models/data/Objectif.dart';
import 'package:health_app/presentation/items/ExerciceItem.dart';
import 'package:health_app/presentation/items/objectifItem.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var health = Provider.of<Health>(context);

    var objectifs = health.objectifs;
    var exercices = health.exercicesRecommande();
    
    return LayoutBuilder(
      builder: (_,constraints)=> Container(

        width: constraints.maxWidth,
        height: constraints.maxHeight,
        color: Colors.grey[100],

        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[

              space(constraints.maxHeight * 0.05),//0.05

              userGreeting(constraints.maxHeight, constraints.maxWidth, context, health.loggedIn.prenom), //0.1
              //space(constraints.maxHeight * 0.025),//0.025

              title("Objectifs Populaire",constraints, context),//0.1
              listOfObjectifs(constraints, context, objectifs),//0.25
              space(constraints.maxHeight * 0.0125),//0.025

              title("Exercices Recommandés",constraints, context),//0.1
              listOfExercices(constraints, context, exercices),//0.25
              space(constraints.maxHeight * 0.025),//0.025
            ],
          ),
        ),
      ),
    );
    
  }


  Widget space(double spaceHeight){
    return SizedBox(
      height: spaceHeight
    );
  }


  Widget userGreeting(double height,double width, BuildContext context, String userName){

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: width *0.05,
        vertical: height *0.01
      ),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[


          Text(
            DateTime.now().hour < 18? "Bonjour," : "Bonsoir,",
            style: Theme.of(context).textTheme.display2.copyWith(
              color: Colors.purple[400],
              fontWeight: FontWeight.bold
            ),
          ),

          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              userName + "!",
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

  Widget title(String text, BoxConstraints constraints, BuildContext context){
    return Container(
      height: constraints.maxHeight *0.08,
      margin: EdgeInsets.symmetric(
        horizontal: constraints.maxWidth *0.05,
        vertical: constraints.maxHeight *0.01
      ),
      alignment: Alignment.centerLeft,
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

  Widget listOfObjectifs(BoxConstraints constraints, BuildContext context, List<Objectif> objectifs){
    return Container(
      height: constraints.maxHeight *0.35,
      

      child: ListView.builder(

        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: objectifs.length,

        itemBuilder: (_,index){

          return Container(

            height: constraints.maxHeight *0.05,
            width: constraints.maxWidth *0.5,

            margin: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth *0.05,
              vertical: constraints.maxHeight *0.01
            ),

            child: ChangeNotifierProvider.value(
              value: objectifs[index],
              child: ObjectifItem(),
            ),

          );
          
        }
      ),
    );
  }

  Widget listOfExercices(BoxConstraints constraints, BuildContext context, List<Exercice> exercices){
    return Container(
      height: constraints.maxHeight *0.45,

      child: ListView.builder(

        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),

        itemCount: exercices.length,

        itemBuilder: (_,index){

          return Container(

            height: constraints.maxHeight *0.45,
            width: constraints.maxWidth *0.45,

            margin: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth *0.05,
              vertical: constraints.maxHeight *0.01
            ),

            child: ChangeNotifierProvider.value(
              value: exercices[index],
              child: ExerciceItem(),
            ),

          );
          
        }
      )
    );

  }
  
}