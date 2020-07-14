
import 'package:flutter/material.dart';
import 'package:health_app/presentation/screens/HomePage.dart';
import 'package:provider/provider.dart';

// import 'Explore.dart';
// import 'ProfilePage.dart';
// import 'Rentals.dart';
import '../tools/BottomNavigation.dart';
import '../../models/Health.dart';



class MainAppScreen extends StatefulWidget {
  @override
  _MainAppScreenState createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int currentIndex = 0;

  update(newIndex){
    setState(() {
      currentIndex = newIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    print("hey");

    Future.delayed(Duration.zero).then((_) async{
      Provider.of<Health>(context, listen: false).fetchData();
    });

  }

  Widget bodyBuilder(){
    // if(currentIndex == 0) return HomePage();
    // if(currentIndex == 1) return Explore();
    // if(currentIndex == 2) return Rentals();
    // return ProfilePage();
    return HomePage();
  }


  @override
  Widget build(BuildContext context) {
    print("reload");
    var _height = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom;


    return Scaffold(

      body: SafeArea(
        top: true,
        bottom: true,
        right: true,
        left: true,
        
        child: Consumer<Health>(
          builder: (context,health,_)=> health.loaded? Container(
            height: _height *0.9,
            width: double.infinity,
            child: bodyBuilder()
          ) : 
          Center( 
            child: const CircularProgressIndicator(),
          ),
        ) 
      ),

      bottomNavigationBar: Container(
        height: _height *0.1,
        width: double.infinity,
        child: BottomNavigation(current : currentIndex, handler : update)
      ),
    );

  }
}