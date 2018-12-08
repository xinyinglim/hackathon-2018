import 'package:cloud_firestore/cloud_firestore.dart';

//2. DRIVER OR COURIER
class Courier {
  static CollectionReference colRef = Firestore.instance.collection("couriers");

  static String courierIDFS = "courierID";
  static String nameFS = "name";
  static String currentLocationFS = "currentLocation";
  static String activeFS = "is_active";

  DocumentReference ref; //todo add to everything
  String courierID;
  String name;
  GeoPoint currentLocation; //only available if you are on activeDuty
  bool active;
  //bool busy/oncall
  //todo connect to user id

  Courier.fromDocumentSnapshot(DocumentSnapshot snap){
    ref = snap.reference;
    Map<String, dynamic> result = snap.data;
    this.courierID = result[courierIDFS];
    this.name = result[nameFS];
    this.currentLocation = result[currentLocationFS];
    this.active = result[activeFS];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      courierIDFS : this.courierID,
      nameFS : this.name,
      currentLocationFS : this.currentLocation,
      activeFS : this.active,
    };
    return result;

  }

}