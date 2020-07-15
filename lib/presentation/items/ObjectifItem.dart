
import 'package:flutter/material.dart';
import 'package:health_app/presentation/screens/ObjectifDetails.dart';

import 'package:provider/provider.dart';

import 'package:health_app/models/data/Objectif.dart';

class ObjectifItem extends StatelessWidget {

  showDetails(dynamic context, id){
    Navigator.of(context).pushNamed(
      ObjectifDetails.route,
      arguments: id,
    );
  }

  @override
  Widget build(BuildContext context) {

    var objectif = Provider.of<Objectif>(context, listen: false);

    return LayoutBuilder(

      builder: (context, constraint)=> InkWell(

        onTap: ()=>showDetails(context,objectif.id),

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
                tag: objectif.id,
                child: ClipRRect(/*Force a widget to be inside of the mother widget border*/
                  child: Image.network(
                    objectif.imageUrl,
                    height: constraint.maxHeight,
                    width: double.infinity,
                    fit: BoxFit.scaleDown,
                  ),

                  borderRadius: BorderRadius.circular(15),
                ),
              ),

              Container(
                height: constraint.maxHeight * 0.95,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    

                    Container(
                      

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
                            objectif.nom.toUpperCase(),
                            style: Theme.of(context).textTheme.button,
                          )
                        ),
                      ),
                    ),


                    Container(
                      

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
                            objectif.exercices.length.toString() +  " Exercice",
                            style: Theme.of(context).textTheme.button,
                          )
                        ),
                      ),
                    ),


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