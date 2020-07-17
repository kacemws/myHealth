
import 'package:flutter/material.dart';
import 'package:health_app/presentation/items/ExerciceItem.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'package:health_app/models/Health.dart';
import 'package:health_app/models/data/Exercice.dart';

class ActivitiesHistory extends StatefulWidget {
  @override
  _ActivitiesHistoryState createState() => _ActivitiesHistoryState();
}

class _ActivitiesHistoryState extends State<ActivitiesHistory> {

  List<DateTime> week;
  DateTime selectedDate;

  List<DateTime> generateWeek(){
    
    return List.generate(7, (index){
      return DateTime.now().subtract(Duration(days: index));
    }).reversed.toList();

  }

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    week = generateWeek();
    week.forEach((day){
      print(day.day);
    });
  }

  void changeSelected(DateTime newSelection){
    setState(() {
      this.selectedDate = newSelection;
    });
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting("fr_FR", null);

    var health = Provider.of<Health>(context, listen: false);
    List<Exercice> exercices = health.exerciceParJours(selectedDate);
    print(exercices.length);
    return LayoutBuilder(
      builder:(_,constraints)=>Container(

        width: constraints.maxWidth,
        height: constraints.maxHeight,
        color: Colors.grey[100],

        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[

              space(constraints.maxHeight * 0.05),//0.05

              userGreeting(constraints.maxHeight, constraints.maxWidth), //0.1

              calendar(constraints.maxHeight, constraints.maxWidth),

              title("Exercices Faits",constraints,Alignment.centerLeft),
              gridOfExercices(constraints, exercices)

            ],
          ),
        )
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
      width: width,
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
              "Votre Historique",
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

  Widget calendar(double height, double width){
    return Container(
      height: height *0.1,
      width: width,
      margin: EdgeInsets.symmetric(
        horizontal: width *0.05,
        vertical: height *0.01
      ),

      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: week.length,
        itemBuilder: (_,index)=>GestureDetector(

          onTap: (){
            changeSelected(week[index]);
          },

          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),

            height: height *0.08,
            width: width *(0.108571429),

            margin: EdgeInsets.symmetric(
              horizontal: width *0.01,
              vertical: height *0.01
            ),

            decoration: BoxDecoration(
              color: week[index].day == selectedDate.day? Colors.purple[200] : Colors.purple[50],
              borderRadius: BorderRadius.circular(15)
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    DateFormat.E("fr").format(week[index]).substring(0,DateFormat.E("fr").format(week[index]).length-1)
                  ),
                ),

                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    week[index].day.toString()
                  ),
                )

              ],
            ),

          ),
        )
      ),
    );
  }

  Widget gridOfExercices(BoxConstraints constraints, List<Exercice> activities){
    return Container(
      height: constraints.maxHeight *0.6,
      width: constraints.maxWidth,

      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(40)
      ),

      margin: EdgeInsets.symmetric(
        horizontal: constraints.maxWidth *0.05,
        vertical: constraints.maxHeight *0.01
      ),
      child: activities.length == 0? 
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          Image.asset(
            "assets/NoItemFound.png",
            fit: BoxFit.scaleDown,
            height: constraints.maxHeight *0.35,
          ),

          title("Veuillez Faires Des Exercices", constraints, Alignment.center)
        ],
      ):GridView.builder(
        itemCount: activities.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ), 

        itemBuilder: (_,index){

          return Container(

            height: constraints.maxHeight *0.55,
            width: constraints.maxWidth *0.3,

            margin: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth *0.05,
              vertical: constraints.maxHeight *0.04
            ),

            child: ChangeNotifierProvider.value(
              value: activities[index],
              child: ExerciceItem(
                heroTag : activities[index].id + "-history"
              ),
            ),

          );
          
        }

      ),
    );
  }

}