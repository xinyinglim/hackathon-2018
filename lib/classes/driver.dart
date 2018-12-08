import 'package:cloud_firestore/cloud_firestore.dart';

class Driver {
  static String driverIDFS = "driverID";
  static String nameFS = "name";
  static String currentLocationFS = "currentLocation";
  static String activeFS = "active";

  DocumentReference ref; //todo add to everything
  String driverID;
  String name;
  GeoPoint currentLocation; //only available if you are on activeDuty
  bool active;
  //bool busy/oncall
  //todo connect to user id

  Driver.fromDocumentSnapshot(DocumentSnapshot snap){
    ref = snap.reference;
    Map<String, dynamic> result = snap.data;
    this.driverID = result[driverIDFS];
    this.name = result[nameFS];
    this.currentLocation = result[currentLocationFS];
    this.active = result[activeFS];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      driverIDFS : this.driverID,
      nameFS : this.name,
      currentLocationFS : this.currentLocation,
      activeFS : this.active,
    };
    return result;

  }

}