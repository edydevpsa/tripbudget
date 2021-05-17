import 'dart:io';
import 'dart:ui';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tripbudget/services/admob_services.dart';
import 'package:tripbudget/widgets/provider_widget.dart';
import 'package:tripbudget/widgets/trip_card.dart';

class HomeView extends StatefulWidget {

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  //Future _nextTrip;
  final primaryColor = Color.fromRGBO(22, 189, 242, 1.0);
  final adms = AdmobService();
  String _authStatus = 'Unknown';
  // @override
  // void didChangeDependencies() {
  //   _nextTrip = _getNextTrip();
  //   super.didChangeDependencies();
  // }
  @override
  void initState() { 
    Admob.initialize();
    initPlugin();
    super.initState();
    //await Admob.requestTrackingAuthorization();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          // FutureBuilder(
          //   future: _nextTrip,
          //   builder: (context, snapshot){
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       return CalculatorWidget(trip: snapshot.data,); //class CalculatorWidget
          //     }else{
          //         return Text('Loading...');
          //     }
          //   }
          // ),
          Padding(padding: EdgeInsets.only(top:10.0)),
          //Text('Tracking status $_authStatus'),
          AdmobBanner(
            adUnitId: adms.getBannerAdId(), 
            adSize: AdmobBannerSize.FULL_BANNER,
          ),
          SizedBox(height: 10.0,),
          Expanded(
            child: StreamBuilder(
              stream: getUserTripStreamSnapshot(context),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Text('Loading...');
                return ListView.builder(
                  itemCount: snapshot.data.documents.length, //con esa linea barremos la data de la BBDD
                  itemBuilder: (BuildContext context, int index) => buildTripCard(context, snapshot.data.documents[index]),
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot>getUserTripStreamSnapshot(BuildContext context)async*{
    final uid = await Provider.of(context).auth.getCurrentUId();
    yield* FirebaseFirestore.instance.collection('userData').doc(uid).collection('trips').orderBy('startDate').snapshots();
    
  }

  // Future _getNextTrip()async{
  //   final uid = await Provider.of(context).auth.getCurrentUId();
  //   var snapshot = await FirebaseFirestore.instance
  //   .collection('userData')
  //   .doc(uid).collection('trips')
  //   .orderBy('startDate')
  //   .limit(1)
  //   .get();

  //   return Trip.fromSnapshot(snapshot.docs.first);
  // }

  Future<void>initPlugin()async{
    TrackingStatus status;
    if (Platform.isIOS) {
      try {
        status = await AppTrackingTransparency.requestTrackingAuthorization();
      
      } on PlatformException {
        _authStatus = 'Failed to Open Tracking Dialog';
      }
      final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
      print('uuid $uuid');
      if (!mounted) {
        return;
      }
      setState(() {
        _authStatus = '$status';
      });
    }
  }
  
}