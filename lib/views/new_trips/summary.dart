import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripbudget/models/trip.dart';
import 'package:tripbudget/widgets/provider_widget.dart';

class Summary extends StatefulWidget {

  final Trip trip;

  Summary({Key key, this.trip}) : super(key: key);

  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  final db = FirebaseFirestore.instance;

  AdmobInterstitial newInterstitialAd;
  //AdmobInterstitial newInterstitialAd = AdmobService().getNewTripInstertitial();
  //AdmobService admobService;
  @override
  void initState() {
    super.initState();
    newInterstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdId(),
      listener: (AdmobAdEvent event, Map<String, dynamic>args ){
        if (event == AdmobAdEvent.closed){
          newInterstitialAd.load();
        }
      }
    );
    newInterstitialAd.load();
  }
  //interstitial ad units
  String getInterstitialAdId(){
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    }else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    }else{
      return null;
    }
  }
  @override
  Widget build(BuildContext context) {
    //newInterstitialAd.load();
    return Scaffold(
      body: Stack(
      children: [
        _fondoApp(context),
        SingleChildScrollView(
          child: Column(
            children: [
             _texts(),
             Text('Choose a Category', style: TextStyle(color: Colors.white, fontSize: 15.0,)),
             Padding(
              padding: const EdgeInsets.all(30.0),
              child: SizedBox(child: _gridViewCount(context),),
             ),
            ],
          ),
        ),
        
        //  SizedBox(child: _gridViewCount(context),),
        //  Padding(
        //    padding: const EdgeInsets.all(30.0),
        //    child: _gridViewCount(context),
        //  ),
      ],
      ),
    );
  }

  Widget _fondoApp(BuildContext context) {
    final contanerGradiente = Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset(0.0, 0.6),
          end: FractionalOffset(0.0, 1.0),
          colors: [
            Color.fromRGBO(52, 54, 101, 1.0),
            Color.fromRGBO(35, 37, 57, 1.0),
          ],
        ),
      ),
    );

    final boxPink = Transform.rotate(
      angle: -pi / 5.0,
      child: Container(
        height: MediaQuery.of(context).size.height *0.50,
        width: MediaQuery.of(context).size.width *0.85,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60.0),
          color:Colors.pink,
        ),
      ),
    );
    
    return Stack(
      children: [
        contanerGradiente,
        Positioned(
          top: -100.0,
          child: boxPink
        ),
      ],
    );
  }

  Widget _texts() {
    return SafeArea(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text('Trip Summary', style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),),
              SizedBox(height: 10.0,),
              Text('Location: ${widget.trip.title}', style: TextStyle(color: Colors.limeAccent, fontSize: 18.0,)),
              SizedBox(height: 10.0,),
              Text(
              "${DateFormat('dd/MM/yyyy').format(widget.trip.startDate).toString()} - ${DateFormat('dd/MM/yyyy').format(widget.trip.endDate).toString()}",
              style: TextStyle(fontSize:18.0,color: Colors.white),
             ),
             
            ],
          ),
        ),
      ),
    );
  }

  Widget _gridViewCount(BuildContext context) {
    final tripTypes = widget.trip.types();
    var tripKeys = tripTypes.keys.toList();
    return Container(
      height: MediaQuery.of(context).size.height *0.70,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment(30, 20),
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(62, 66, 107, 0.70),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Center(
        child: GridView.count(
          crossAxisCount: 2,
          scrollDirection: Axis.vertical,
          primary: false,
          children: List.generate(tripTypes.length, (index){
            return FlatButton(
              child: Column(
                children: [
                  tripTypes[tripKeys[index]],
                  Text(tripKeys[index],style: TextStyle(color: Colors.white70),),
                ],
              ),
              onPressed: ()async{
                //Save Data to Firebase
                widget.trip.travelType = tripKeys[index];
                final uid = await Provider.of(context).auth.getCurrentUId();
                await db.collection('userData').doc(uid).collection('trips').add(widget.trip.toJson());
                if (await newInterstitialAd.isLoaded) {
                  newInterstitialAd.show();
                }
                Navigator.of(context).popUntil((route) => route.isFirst);
              }, 
            );
          }),

        ),
      ),
    );
  }
}