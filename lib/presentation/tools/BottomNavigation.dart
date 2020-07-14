
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';


class BottomNavigation extends StatelessWidget {
  final int current;
  final Function handler;

  BottomNavigation({@required this.current, @required this.handler});  

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(

      builder: (_,constraints)=>Container(
        
        decoration: BoxDecoration(
          color: Colors.white, 
          boxShadow: [BoxShadow(
            blurRadius: 20, 
            color: Colors.black.withOpacity(.1)
          )]
        ),

        width: double.infinity,
        height: (MediaQuery.of(context).size.height <= 75)?constraints.maxHeight*0.95 : 55,

        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            //crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              navItem("Home",0),
              navItem("Explore",1),
              navItem("List",2),
              navItem("Profile",3),
            ],
          ),
        ),
      ),

    );

  }
  Widget navItem(String name,int index){
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child : Stack(
        children : [

          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height :3.75,
            alignment: Alignment.topCenter,
            color: index == current?Colors.purple[900] : Colors.white,
          ),

          GestureDetector(

            onTap: (){
              handler(index);
            },

            child : Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: AspectRatio(
                aspectRatio: 1,
                child: FlareActor(
                  "assets/$name.flr",
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: index == current? "go" : "idle",
                ),
              ),
            )
          )
        ]
      )
    );
  }
}

