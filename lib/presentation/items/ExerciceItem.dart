
import 'package:flutter/material.dart';
import 'package:health_app/models/data/Difficulte.dart';

import 'package:provider/provider.dart';

import 'package:health_app/models/data/Exercice.dart';

class ExerciceItem extends StatelessWidget {

  showDetails(dynamic context, id){
    // Navigator.of(context).pushNamed(
    //   StationDetails.route,
    //   arguments: id,
    // );
  }

  @override
  Widget build(BuildContext context) {

    var exercice = Provider.of<Exercice>(context, listen: false);

    return LayoutBuilder(

      builder: (context, constraint)=> InkWell(

        onTap: ()=>showDetails(context,exercice.id),

        splashColor: Colors.purple[900],

        child:Container(

          height: constraint.maxHeight,
          width: constraint.maxWidth, 

          decoration: BoxDecoration(
            color: Colors.purple[100],
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                color: Colors.white,
                offset: Offset(-7.5, -5)
              ),
              BoxShadow(
                blurRadius: 5,
                color: Colors.black12,
                offset:  - Offset(-5, -5)
              ),
            ]
          ),


          child: Stack(
            children: <Widget>[

              Hero(
                tag: exercice.id,
                child: ClipRRect(/*Force a widget to be inside of the mother widget border*/
                  child: Image.network(
                    exercice.imageUrl,
                    height: constraint.maxHeight,
                    width: double.infinity,
                    fit: BoxFit.scaleDown,
                  ),

                  borderRadius: BorderRadius.circular(15),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  cardItem(constraint, exercice.nom.toUpperCase(), context),
                  cardItem(constraint, exercice.duree.toString() + " mn", context),
                  cardItem(constraint, "Difficultée : " + (exercice.difficulte == Difficulte.facile? "Facile" : exercice.difficulte == Difficulte.moyenne ? "Moyenne" : "Difficile"), context)
                ],
              )



            ],
          ),
        ),
      )
    );
  }

  Container cardItem(BoxConstraints constraint, String text, BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(5)
      ),

      child: Padding(
                    
        padding: EdgeInsets.symmetric(
          horizontal: constraint.maxWidth *0.01,
          vertical: constraint.maxHeight *0.01
        ),

        child: FittedBox(
          fit: BoxFit.scaleDown,
          child : Text(
            text,
            style: Theme.of(context).textTheme.button,
          )
        ),
      ),
    );
  }
}