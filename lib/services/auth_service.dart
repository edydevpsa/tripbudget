import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  Stream<String> get authStateChanges => _firebaseAuth.authStateChanges().map(
    (User user) => user?.uid,
  );

  //Recuerda q la conexion ala BBDD es con hilos osea Asyncrono
  //con currentUser.uid acada usuario tendra su propia info en la BBDD
  Future<String>getCurrentUId()async{
    String uid = _firebaseAuth.currentUser.uid;
    return uid;
  }

  //GET Current User
  Future getCurrentUser()async{
    return _firebaseAuth.currentUser;
  }

  //Email and Password Sign Up
  Future<String>createUserWithEmailandPassword(String email, String password, String name)async{
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    
    //Update User Name and Profile;
    updateUserandProfile(name, authResult.user);

    return authResult.user.uid;
    
  }

  // Function Update the UserName and Profile
  Future updateUserandProfile(String name, User currentUser)async{
    await currentUser.updateProfile(displayName: name);
    await currentUser.reload();
  }
  
  //Email and Password Sign In
  Future<String> signInWithEmailandPassword(String email, String password)async{

    return (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user.uid;
  }

  getProfileImage(){
    if (_firebaseAuth.currentUser.photoURL != null) {
      return Image.network(_firebaseAuth.currentUser.photoURL, height: 100.0, width: 100.0);
    }else{
      return Icon(Icons.account_circle, size: 100.0);
    }
  }

  //Sign Out
  signOut(){
    return _firebaseAuth.signOut();
  }

  //Reset Password
  Future<void>sendPasswordResetEmail(String email)async{
    final auth = await _firebaseAuth.sendPasswordResetEmail(email: email);
    return auth;
  }

  //Create Anonymous User
  Future signInAnonymously()async{
    final user = await  _firebaseAuth.signInAnonymously();
    return user;
  }

  //GOOGLE Authentication
  Future<String>signInWithGoogle()async{
    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleSignInAuth = await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: _googleSignInAuth.idToken, accessToken: _googleSignInAuth.accessToken
    );
    return (await _firebaseAuth.signInWithCredential(credential)).user.uid;

  }

  //Convert User Permanet  with EMAIL if logging anonimously
  Future convertUserWithEmail(String email, String password, String name)async{
    final currentUser = _firebaseAuth.currentUser;
    final credential = EmailAuthProvider.credential(email: email, password: password);
    await currentUser.linkWithCredential(credential);
    await updateUserandProfile(name, currentUser);

  }

  //Convert User Permanet  with GOOGLE if logging anonimously
  Future convertWithGoogle()async{
    final currentUser = _firebaseAuth.currentUser;
    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleSignInAuth = await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: _googleSignInAuth.idToken, accessToken: _googleSignInAuth.accessToken,
    );
    await currentUser.linkWithCredential(credential);
    await updateUserandProfile(_googleSignIn.currentUser.displayName, currentUser);
  }
  //APPLE Authentication
  Future signInWithApple()async{
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName]),
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:
        final AppleIdCredential _auth = result.credential;
        final OAuthProvider oAuthProvider = new OAuthProvider('apple.com');
        final AuthCredential credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(_auth.identityToken),
          accessToken: String.fromCharCodes(_auth.authorizationCode),
        );
        await _firebaseAuth.signInWithCredential(credential);

        //Update the User Information
        if (_auth != null) {
          await _firebaseAuth.currentUser.updateProfile(
            displayName: '${_auth.fullName.givenName} ${_auth.fullName.familyName}'
          );
        }
        break;
      case AuthorizationStatus.cancelled:
        print('User Cancelled');
        break;
      case AuthorizationStatus.error:
        print('Sign In Falled ${result.error.localizedDescription}');
        break;    
      default:
    }
  }

  //Login with Facebook
  Future<void>loginWithFacebook()async{
    try {
      final accessToken = await _facebookAuth.login();
      print(accessToken.toJson());
      final AuthCredential credential = FacebookAuthProvider.credential(accessToken.token);
      final result = _firebaseAuth.signInWithCredential(credential);
      print(result);
    } catch (e,s) {
      print(s);
      if (e is FacebookAuthException) {
        switch (e.errorCode) {
          case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
            print('Operation in Progress');
            break;
          case FacebookAuthErrorCode.CANCELLED:
            print('Cancelled');
            break;
          case FacebookAuthErrorCode.FAILED:
            print('Failed');
            break;
          default:
        }
      }
    }
  }

}

class NameValidator{
  static String validateName(String value){
    if (value.isEmpty) {
      return 'Name can\'t be empty';
    }
    if (value.length < 2) {
      return 'Name must be at last 2 characters long';
    }
    if (value.length > 50) {
      return 'Name must be less than 50 characters long';
    }
    return null;
  }
}

class EmailValidator{
  static String validateEmail(String value){
    if (value.isEmpty) {
      return 'Email can\'t be empty'; 
    }
    return null;
  }
}

class PasswordValidator{
  static String validatePassword(String value){
   if (value.isEmpty) {
     return 'Password can\'t be empty';
   }
   return null;
  }
  
}