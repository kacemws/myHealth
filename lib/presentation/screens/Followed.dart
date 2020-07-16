
import 'package:flutter/material.dart';
import 'package:health_app/models/Health.dart';
import 'package:health_app/models/data/Exercice.dart';
import 'package:health_app/models/data/Objectif.dart';
import 'package:health_app/presentation/items/ExerciceItem.dart';
import 'package:health_app/presentation/items/followedObjectif.dart';
import 'package:provider/provider.dart';

class FollowedPage extends StatefulWidget {
  @override
  _FollowedPageState createState() => _FollowedPageState();
}

class _FollowedPageState extends State<FollowedPage> {

  Objectif selected;
  List<Objectif> objectifs;

  @override
  void initState() {
    super.initState();
    objectifs = Provider.of<Health>(context, listen: false).loggedIn.followedObjectifs;
    print(objectifs.length);
    this.selected =  objectifs.length == 0? null : objectifs.first;
  }

  void setSelected(Objectif newObjectif){
    if(selected != newObjectif)
      setState(() {
        this.selected = newObjectif;
      });
  }

  @override
  Widget build(BuildContext context) {

    List<Exercice> exercices = selected != null? selected.exercices : [];
    
    return LayoutBuilder(
      builder: (_,constraints)=> Container(

        width: constraints.maxWidth,
        height: constraints.maxHeight,
        color: Colors.grey[100],

        child: selected == null?

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Image.asset(
              "assets/NoItemFound.png",
              fit: BoxFit.scaleDown,
              height: constraints.maxHeight *0.5,
            ),

            title("Veuillez Suivre Des Objectifs!!", constraints, Alignment.center)
          ],
        ):

        SingleChildScrollView(

          physics: BouncingScrollPhysics(),
          child: Column(

            children: <Widget>[

              space(constraints.maxHeight * 0.05),//0.05

              userGreeting(constraints.maxHeight, constraints.maxWidth), //0.1
              //space(constraints.maxHeight * 0.025),//0.025

              listOfObjectifs(constraints, objectifs),//0.25
              space(constraints.maxHeight * 0.0125),//0.025

              title("Exercices Disponibles",constraints, Alignment.centerLeft),//0.1
              listOfExercices(constraints, exercices),//0.25
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

  Widget userGreeting(double height,double width){

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
            "Objectifs Suivis",
            style: Theme.of(context).textTheme.display2.copyWith(
              color: Colors.purple[400],
              fontWeight: FontWeight.bold
            ),
          ),

        ],
      ),
    );

  }

  Widget title(String text, BoxConstraints constraints, AlignmentGeometry alignment){
    return Container(
      height: constraints.maxHeight *0.08,
      margin: EdgeInsets.symmetric(
        horizontal: constraints.maxWidth *0.05,
        vertical: constraints.maxHeight *0.01
      ),
      alignment: alignment,
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

  Widget listOfObjectifs(BoxConstraints constraints, List<Objectif> objectifs){
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
              child: FollowedObjectif(isActive: objectifs[index] == selected, handler: this.setSelected),
            ),

          );
          
        }
      ),
    );
  }

  Widget listOfExercices(BoxConstraints constraints, List<Exercice> exercices){
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
              child: ExerciceItem(
                heroTag : exercices[index].id + "-followedScreen"
              ),
            ),

          );
          
        }
      )
    );

  }
}