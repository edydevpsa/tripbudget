import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tripbudget/models/trip.dart';
import 'package:tripbudget/widgets/provider_widget.dart';
import 'package:tripbudget/widgets/trip_card.dart';


class PastTripsView extends StatefulWidget {

  @override
  _PastTripsViewState createState() => _PastTripsViewState();
}

class _PastTripsViewState extends State<PastTripsView> {

  TextEditingController _searchController = TextEditingController();
  Future resultLoaded;
  List _allResults = [];
  List _resultList = [];

  @override
  void initState() { 
    _searchController.addListener( _onSearchChanged);
    super.initState();
    
  }

  @override
  void dispose() { 
    _searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultLoaded = getUserPastTripsStreamSnapshot();
  }

  _onSearchChanged(){
    searchResultsList();
  }

  searchResultsList(){
    var showResults = [];
    if (_searchController.text != '') {
      for (var tripSnapshot in _allResults) {
        var title = Trip.fromSnapshot(tripSnapshot).title.toLowerCase();
        if (title.contains(_searchController.text.toLowerCase())) {
          showResults.add(tripSnapshot);
        }
      }
    }else{
      _resultList = List.from(_allResults);
    }
    setState(() {
      _resultList = _allResults;
    });
  }

  getUserPastTripsStreamSnapshot()async{
    final uid = await Provider.of(context).auth.getCurrentUId();
    var data = await FirebaseFirestore.instance
      .collection('userData')
      .doc(uid)
      .collection('trips')
      .where('endDate',isLessThanOrEqualTo: DateTime.now()) //trabajando con where
      //.where('travelType', isEqualTo: 'bus')
      .orderBy('endDate')
      .get();
    
    setState(() {
      _allResults = data.docs;
    });

    searchResultsList();
    return 'Complete';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: [
            Text('Past Trips', style: TextStyle(fontSize: 20.0,color:Colors.indigo),),
            Padding(
              padding: const EdgeInsets.only(top:15.0,left:15.0, right: 15.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _resultList.length,
                itemBuilder: (BuildContext context, int index) => buildTripCard(context, _resultList[index]),
              ),
              // StreamBuilder(
              //   stream: getUserPastTripsStreamSnapshot(context),
              //   builder: (context, snapshot) {
              //     if (!snapshot.hasData) return Text('Loading...');
              //     return ListView.builder(
              //       itemCount: snapshot.data.documents.length, //con esa linea barremos la data de la BBDD
              //       itemBuilder: (BuildContext context, int index) => buildTripCard(context, snapshot.data.documents[index]),
              //     );
              //   }
              // ),
            ),
          ],
        ),
      ),
    );
  }
}