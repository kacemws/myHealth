
import 'package:flutter/material.dart';
import 'package:health_app/models/Health.dart';
import 'package:health_app/models/data/Difficulte.dart';
import 'package:health_app/models/data/Exercice.dart';
import 'package:health_app/presentation/items/ExerciceItem.dart';
import 'package:provider/provider.dart';

class ExerciceDetails extends StatelessWidget {

  static final String route = "/exercice-details";

  @override
  Widget build(BuildContext context) {

    var exerciceId = ModalRoute.of(context).settings.arguments as String;
    var health = Provider.of<Health>(context, listen: false);

    var exercice = health.getExerciceById(exerciceId);
    var isCurrent = health.loggedIn.getCurrentAct() == null? false : health.loggedIn.getCurrentAct().exo == exercice;

    var _height = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.vertical;
    var _width = MediaQuery.of(context).size.width;

    Future<void> doExercice() async{
      try{
        await Provider.of<Health>(context, listen: false).handleExercice(exerciceId);
      }catch(error){
        print (error);
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(

          children: <Widget>[
            Stack(
              children: <Widget>[

                Hero(
                  tag: exercice.id,
                  child: Image.network(
                    exercice.imageUrl,
                    height: _height *0.3,
                    width: double.infinity,
                    fit: BoxFit.scaleDown,
                  ),
                ),

                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: _height *0.05,
                    horizontal: _width * 0.025,
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back), 
                        onPressed: (){
                          Navigator.of(context).pop();
                        }
                      ),
                    ],
                  )
                )

              ],
            ),

            title(exercice.nom  + " - " + exercice.objectif.nom, _height, _width, context, Alignment.center), //8%

            Row(
              children: <Widget>[
                title("Durée : ", _height, _width, context, Alignment.centerLeft),
                title(exercice.duree.toString() + " minutes", _height, _width, context, Alignment.centerLeft),
              ],
            ),

            Row(
              children: <Widget>[
                title("Difficultée : ", _height, _width, context, Alignment.centerLeft),
                title((exercice.difficulte == Difficulte.facile? "Facile" : exercice.difficulte == Difficulte.moyenne ? "Moyenne" : "Difficile"), _height, _width, context, Alignment.centerLeft),
              ],
            ), //10%

            title("Etapes : ", _height, _width, context, Alignment.centerLeft),

            listOfEtapes(_height,_width, context, exercice.etapes),

            followButton(_height, _width, context, doExercice, isCurrent), //10%


          ],

        ),
      ),
    );

  }

  Widget title(String text, double height, double width, BuildContext context, AlignmentGeometry alignment){
    return Container(
      height: height *0.07,
      margin: EdgeInsets.symmetric(
        horizontal: width *0.05,
        vertical: height *0.005
      ),
      alignment: alignment,
      child: FittedBox(
        fit:BoxFit.scaleDown,
        child: Text(
          text,
          style: Theme.of(context).textTheme.title.copyWith(
            color: Colors.purple[400],
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  Widget space(double height){
    return SizedBox(
      height: height,
    );
  }

  Widget followButton(double _height, double _width, BuildContext context, Function handler, bool isCurrent){
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

        child: Center(child: Text( isCurrent? "Terminer" : "Démarrer", style: Theme.of(context).textTheme.title.copyWith(color:Colors.white),)),

      ),
    );
  }
  
  Widget listOfEtapes(double height, double width, BuildContext context, Map<String,String> etapes){
    var aux = etapes.entries;
    return Container(

      height: height *0.3,
      width: width,

      margin: EdgeInsets.symmetric(
        horizontal: width *0.05,
      ),

      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(15)
      ),

      child: ListView.builder(

        physics: BouncingScrollPhysics(),

        itemCount: aux.length,

        itemBuilder: (_,index){

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Text(
                aux.elementAt(index).key +" : ",
                style: Theme.of(context).textTheme.body2,
              ),

              SizedBox(
                width: width * 0.75,
                height: height * 0.04,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    aux.elementAt(index).value,
                    style: Theme.of(context).textTheme.body2,
                  ),

                ),
              )
            ],
          );
          
        }
      )
    );

  }

}