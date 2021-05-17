import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tripbudget/credentials.dart';
import 'package:tripbudget/models/place.dart';
import 'package:tripbudget/models/trip.dart';
import 'package:tripbudget/widgets/dividerText.dart';
import 'package:tripbudget/views/new_trips/date_view.dart';
import 'package:uuid/uuid.dart';


class NewLocation extends StatefulWidget {
  final Trip trip;

  NewLocation({Key key, @required this.trip}) : super(key: key);

  @override
  _NewLocationState createState() => _NewLocationState();
}

class _NewLocationState extends State<NewLocation> {
  TextEditingController _searchController = TextEditingController();
  //Timer _throttle;
  String _sessionToken;
  var uuid = Uuid();

  String _heading;
  List<Place>_placeList;
  List<Place>_suggestedList = [
    // Place('NewYork', 200.00),
    // Place('Austin', 250.00),
    // Place('Boston', 250.00),
    // Place('Florence', 300.00),
    // Place('Washigton D.C', 198.00),
  ];

  //int _calls = 0;

  @override
  void initState() {
    _heading = 'Suggestion';
    _placeList = _suggestedList;
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }
  @override
  void dispose() { 
    _searchController.removeListener( _onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }


  _onSearchChanged(){
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getLocationResult(_searchController.text);
    // if (_throttle?.isActive ?? false) _throttle.cancel();

    // _throttle = Timer(Duration(milliseconds: 500), (){
    //   getLocationResult(_searchController.text);
    // });
  }

  void getLocationResult(String input)async{
    if (input.isEmpty) {
      setState(() {
        _heading = 'Suggestion';
      });
      return;
    }
    //Api request placeAutocomplete...
    //String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$PLACE_API_KEY';
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String type = '(regions)';
    String request = '$baseURL?input=$input&key=$PLACE_API_KEY&types=$type&sessiontoken=$_sessionToken';
    Response response = await Dio().get(request);
    //print(response);
    //print(request);
    final predictions = response.data["predictions"];
    List<Place>_displayResult=[];

    for (var i = 0; i < predictions.length; i++) {
      String name = predictions[i]["description"];
      String placeid = predictions[i]["place_id"];
      double averageBudget = 200;
  
      _displayResult.add(Place(name, averageBudget, placeid));
    }

    if (!mounted) return;//colocamos if(!mounted)return; entre un await y SetState() Cuando da una excepcion de setState y dispose

    setState(() {
      _heading = 'Results';
      _placeList = _displayResult;
      //_calls++;
    });
  }
  
  //Usamos Api request PlaceDetails && Api Photo para mostrar la img.
  Future<String>getLocationPhotoRef(placeId)async{
    String placeImgRequest = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=photo,geometry&key=$PLACE_API_KEY&sessiontoken=$_sessionToken';
    Response placeDetails = await Dio().get(placeImgRequest);
    final photoRerefence = placeDetails.data["result"];
    final photo = photoRerefence["photos"][0]["photo_reference"];
    //return photo;
    // if (photo == null) {
    //   return 'assets/files/noimage.jpg';
    // }
    return photo;
    //print(placeDetails);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Trip Location'),
      ),
      body: Center(
        child: Column(
          children: [
            //Text('API call $_calls'),
            Padding(
              padding: const EdgeInsets.only(top:20.0, bottom: 10.0),
              child: Text('Enter a Location'),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.indigoAccent,),
                ),
                // onChanged: (text){
                //   getLocationResult(text);
                // }, //function result segun busqueda
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:10.0, right: 10.0),
              child: DividerwithText(dividerText: _heading,),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _placeList.length,
                itemBuilder: (BuildContext context, int index) => buildPlaceCard(context, index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPlaceCard(BuildContext context, int index){
    return Hero(
      tag: 'selectetTrip-${_placeList[index].name}',
      transitionOnUserGestures: true,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left:8.0, right: 8.0),
          child: Card(
            child: InkWell(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: AutoSizeText(
                                  _placeList[index].name,
                                  maxLines: 3,
                                  style: TextStyle(fontSize: 23.0),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Average Budget: ${_placeList[index].averageBudget.toStringAsFixed(2)}"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () async{
                String photoreference = await getLocationPhotoRef(_placeList[index].placeId);
                //print(photoreference);
                widget.trip.title = _placeList[index].name;
                widget.trip.photoRerefence = photoreference;
                setState(() {
                  _sessionToken = null;
                });
                Navigator.push(context, MaterialPageRoute(builder: (contex)=> NewDateView(trip: widget.trip,)));
              },
            ),
          ),
        ),
      ),
    );
  }
}
