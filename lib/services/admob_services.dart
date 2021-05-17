import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';

class AdmobService{
  AdmobInterstitial interstitialAd;
  // here admob IDs  
  String getAdmobAppId(){ 
    if (Platform.isIOS) {
      //return 'ca-app-pub-9326348509831610~3535156765'; //correcto
      return 'ca-app-pub-3940256099942544~1458002511';
    }else if(Platform.isAndroid){
      //return 'ca-app-pub-9326348509831610~5652401255'; //correcto
      return 'ca-app-pub-3940256099942544~3347511713';
    }else{
      return null;
    }
  }

  // here admob Banner Ad units
  String getBannerAdId(){
    if (Platform.isIOS) {
      //return 'ca-app-pub-9326348509831610/7282830080'; //correcto
      return 'ca-app-pub-3940256099942544/2934735716';
    }else if (Platform.isAndroid) {
      //return 'ca-app-pub-9326348509831610/5422953503'; //correcto
      return 'ca-app-pub-3940256099942544/6300978111';
    }else{
      return null;
    }
  }

  String getInterstitialAdId(){
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    }else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    }else{
      return null;
    }
  }

  // AdmobInterstitial getNewTripInstertitial(){
  //   interstitialAd = AdmobInterstitial(
  //     adUnitId: getAdmobAppId(),
  //     listener: (AdmobAdEvent event, Map<String, dynamic>args ) {
  //       if (event == AdmobAdEvent.closed){
  //         interstitialAd.load();
  //       }
  //       return interstitialAd.load();
  //     }
  //   );
  //   //interstitialAd.load();
  // }
}