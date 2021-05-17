import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tripbudget/models/trip.dart';
import 'package:tripbudget/services/auth_service.dart';
import 'package:tripbudget/views/home_view.dart';
import 'package:tripbudget/views/pastTrips_view.dart';
import 'package:tripbudget/views/new_trips/location_view.dart';
import 'package:tripbudget/views/profile_view.dart';
import 'package:tripbudget/widgets/provider_widget.dart';

//final _primarycolor = Color.fromRGBO(55, 57, 84, 1.0);
class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  List<Widget>_children = [
    HomeView(),
    //ExplorePage(),
    PastTripsView(),
    ProfileView(),
  ];
  @override
  Widget build(BuildContext context) {
    final newTrip = Trip(null, null, null, null, null,null);
    return Scaffold(
      appBar: AppBar(
        title: Text(' Trip Budget'),
        actions: [
          IconButton(
            icon: Icon(Icons.add), 
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>NewLocation(trip: newTrip)));
            },
          ),
          // IconButton(
          //   icon: Icon(Icons.undo_outlined), 
          //   onPressed: ()async{
          //     try {
          //       AuthService auth = Provider.of(context).auth;
          //       await  auth.signOut();
          //       print('Signned Out $auth');
          //     } catch (e) {
          //       print(e);
          //     }
          //   },
          // ),
          // IconButton(
          //   icon: Icon(Icons.account_circle), 
          //   onPressed: (){
          //     Navigator.of(context).pushNamed('/convertUser');
          //   },
          // ),

        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: _botonNavigationBar(),
    );
  }
  Widget _botonNavigationBar(){
    return CurvedNavigationBar(
        backgroundColor: Color.fromRGBO(42, 183, 202, 0.80),//Color.fromRGBO(22, 189, 242, 1.0),
        
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        index: _currentIndex,
        items:  [
          Icon(Icons.home,size: 30.0, color: Colors.pinkAccent,),
          Icon(Icons.explore, size: 30.0, color: Colors.pinkAccent,),
          Icon(Icons.account_circle, size: 30.0,color: Colors.pinkAccent,),
          // BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          // BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          // BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Past Trip'),
        ],
      );
  }

}
