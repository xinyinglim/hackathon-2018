import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hackathon_test/classes/currentSession.dart';
import 'package:hackathon_test/classes/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_test/create/createUser.dart';
import 'dart:async';

class AuthPage extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;
Future<FirebaseUser> _handleSignIn() async {
  GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  FirebaseUser user = await _auth.signInWithGoogle(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  return user;
}
 
  GlobalKey <ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            child: Text("Sign In With Google"),
            onPressed: (){
              _handleSignIn()
                .then((FirebaseUser user) async {
                  String email = user.email;
                  QuerySnapshot snap = await User.colRef.where(User.emailFS, isEqualTo: email).getDocuments();
                  List<DocumentSnapshot> docList = snap.documents;
                  if (docList.length == 0) {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => new CreateUser(email)
                    ));
                  }
                  CurrentSession.currentUser = User.fromDocumentSnapshot(docList[0]);
                })
                  .catchError((e) => print(e));
            },
          )
        ],
      ),
    );
  }
}