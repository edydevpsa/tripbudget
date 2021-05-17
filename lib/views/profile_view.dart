import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripbudget/models/user.dart';
import 'package:tripbudget/services/auth_service.dart';
import 'package:tripbudget/widgets/provider_widget.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  User user = User('');
  //bool _isAdmin = false;
  //TextEditingController _userCountryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Center(
          child: Column(    
          children: [
            FutureBuilder(
              future: Provider.of(context).auth.getCurrentUser(),
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.done) {
                  return displayuserInformation(context, snapshot);
                }else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget displayuserInformation(BuildContext context, AsyncSnapshot snapshot){
    final authData = snapshot.data;
    return Column(
      children: [
        Text('$authData'),
        //adminFeature(),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
          child: Provider.of(context).auth.getProfileImage(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("${authData.displayName ?? 'Anonymous'}" , maxLines: 3 , style: TextStyle(color:Colors.pinkAccent, fontSize: 25.0,fontWeight: FontWeight.bold,),),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Email: ", style: TextStyle(color:Colors.pinkAccent, fontSize: 20.0,fontStyle: FontStyle.italic),),
              Text(" ${authData.email ?? 'Anonymous'}", maxLines: 3, style: TextStyle(color:Colors.indigoAccent, fontSize: 20.0),),
            ],
          ),
        ),
        // FutureBuilder(
        //   future: _getProfileData(),
        //   builder: (context, snapshot){
        //     if (snapshot.connectionState == ConnectionState.done) {
        //       _userCountryController.text = user.homeCountry;
        //       _isAdmin = user.admin ?? false;
        //     }
        //     return Column(
        //       children: [
        //         Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: Text('Home Country: ${_userCountryController.text}',style: TextStyle(fontSize: 20.0)),
        //         ),
        //       ],
        //     );
        //   },
        // ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Created: ", style: TextStyle(color:Colors.pinkAccent, fontSize: 20.0,fontStyle: FontStyle.italic),),
              Text(" ${DateFormat('dd/MM/yyyy').format(authData.metadata.creationTime).toString()}", style: TextStyle(color:Colors.indigoAccent, fontSize: 20.0),)
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Last SignIn: ", style: TextStyle(color:Colors.pinkAccent, fontSize: 20.0,fontStyle: FontStyle.italic),),
              Text(" ${DateFormat('dd/MM/yyyy').format(authData.metadata.lastSignInTime).toString()}", style: TextStyle(color:Colors.indigoAccent, fontSize: 20.0),),
            ],
          ),
        ),
        SizedBox(height: 25.0,),
        showSignOut(context, authData.isAnonymous),
        // RaisedButton(
        //   shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20.0)),
        //   color: Colors.indigo,
        //   child: Text('Edit your profile', style: TextStyle(color: Colors.white),),
        //   onPressed: (){
        //     _userEdithButtonSheet(context);
        //   }
        // ),
      ],
    );
  }

  Widget showSignOut(BuildContext context, bool isAnonymous ){
    if (isAnonymous == true) {
      return RaisedButton(
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20.0)),
        color: Colors.black,
        child: Text('Create your Profile', style: TextStyle(color: Colors.white),),
        onPressed: (){
          Navigator.of(context).pushNamed('/convertUser');
        },
      );
    }else {
      return Padding(
        padding: const EdgeInsets.only(top:8.0, bottom: 8.0, left: 20.0, right: 20.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20.0)),
          color: Colors.indigoAccent,
          child: Padding(
            padding: const EdgeInsets.only(top:10.0, bottom: 10.0, left: 35.0, right: 35.0),
            child: Text('Sign Out',style: TextStyle(color: Colors.white),),
          ),
          onPressed: ()async{
            try {
              await Provider.of(context).auth.signOut(); 
            } catch (e) {
                  print(e);
            }
          },
        ),
      );
    }
  }

  // Future _getProfileData() async{
  //   final uid = await Provider.of(context).auth.getCurrentUId();
  //   await FirebaseFirestore.instance.collection('userData').doc(uid).get().then(
  //     (value){
  //       user.homeCountry = value.data()['homeCountry'];
  //       user.admin = value.data()['admin'];
  //     }
  //   );
  // }

  // Widget adminFeature(){
  //   if (_isAdmin == true) {
  //     return Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Text('you are an Admin' ,style: TextStyle(fontSize: 20.0)),
  //     );
  //   }else{
  //     return Container();
  //   }
  // }

  // void _userEdithButtonSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context, 
  //     builder: (BuildContext contex){
  //       return Container(
  //         height: MediaQuery.of(context).size.height * 0.50,
  //         child: Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: SingleChildScrollView(
  //             child: Column(
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                   children: [
  //                     Text('Update Profile', style: TextStyle(fontSize: 20, color: Colors.redAccent),),
  //                     Spacer(),
  //                     IconButton(
  //                       icon: Icon(Icons.cancel, size: 28.0, color: Colors.orange), 
  //                       onPressed: (){
  //                         Navigator.of(context).pop();
  //                       }
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(height: 20.0,),
  //                 Row(
  //                   children: [
  //                     Expanded(
  //                       child: Padding(
  //                         padding: const EdgeInsets.only(right: 15.0),
  //                         child: TextField(
  //                           controller: _userCountryController,
  //                           decoration: InputDecoration(
  //                             helperText: 'Home Country',
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),           
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: [
  //                     RaisedButton(
  //                       shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10.0)),
  //                       child: Text('Save'),
  //                       textColor: Colors.white,
  //                       color: Colors.indigoAccent,
  //                       onPressed: ()async{
  //                         user.homeCountry = _userCountryController.text;
  //                         setState(() {
  //                           _userCountryController.text = user.homeCountry;
  //                         });
  //                         final uid = await Provider.of(context).auth.getCurrentUId();
  //                         await Provider.of(context).db
  //                         .collection('userData')
  //                         .doc(uid)
  //                         .set(user.toJson());
  //                         Navigator.pop(context);
  //                       },
  //                     ),
  //                   ],
  //                 ),
                  
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     }
  //   );
  // }
}