
import 'package:flutter/material.dart';
import 'package:health_app/models/Health.dart';
import 'package:health_app/models/data/Exercice.dart';
import 'package:health_app/presentation/items/ExerciceItem.dart';
import 'package:provider/provider.dart';

class ObjectifDetails extends StatelessWidget {

  static final String route = "/objectif-details";

  @override
  Widget build(BuildContext context) {

    var objectifId = ModalRoute.of(context).settings.arguments as String;
    var objectif = Provider.of<Health>(context).getObjectifById(objectifId);

    var _height = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.vertical;
    var _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(

          children: <Widget>[
            Stack(
              children: <Widget>[

                Hero(
                  tag: objectif.id,
                  child: Image.network(
                    objectif.imageUrl,
                    height: _height *0.4,
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

            title(objectif.nom, _height, _width, context, Alignment.center), //10%

            title(objectif.exercices.length.toString() + " Exercices", _height, _width, context, Alignment.centerLeft), //10%
            listOfExercices(_height,_width, context, objectif.exercices),

            followButton(_height, _width, context), //10%


          ],

        ),
      ),
    );

  }

  Widget title(String text, double height, double width, BuildContext context, AlignmentGeometry alignment){
    return Container(
      height: height *0.08,
      margin: EdgeInsets.symmetric(
        horizontal: width *0.05,
        vertical: height *0.01
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

  Widget followButton(double _height, double _width, BuildContext context){
    return GestureDetector(
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

        child: Center(child: Text( "Démarrer", style: Theme.of(context).textTheme.title.copyWith(color:Colors.white),)),

      ),
    );
  }
  
  Widget listOfExercices(double height, double width, BuildContext context, List<Exercice> exercices){
    return Container(
      height: height *0.325,

      child: ListView.builder(

        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),

        itemCount: exercices.length,

        itemBuilder: (_,index){

          return Container(

            height: height *0.325,
            width: width *0.45,

            margin: EdgeInsets.symmetric(
              horizontal: width *0.05,
              vertical: height *0.01
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