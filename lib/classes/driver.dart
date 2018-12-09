import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_test/helper/firestoreEnum.dart';
enum CourierStatus {OffDuty, Available, Working}//todo later add one for cars that suddenly vanish without clocking out, and alerts eg accidents
class CourierStatusEnum extends FirestoreEnum<CourierStatus>{
  @override
    Map<CourierStatus, String> get enumToDisplay => {
      CourierStatus.Available : "Available",
      CourierStatus.Working : "Working",
      CourierStatus.OffDuty : "Off Duty"
    };

  @override
  Map<CourierStatus, String> get enumToFirestore => {
    CourierStatus.Available : "available",
    CourierStatus.Working : "working",
    CourierStatus.OffDuty : "offDuty"
  };

  CourierStatusEnum.fromFirestoreString(String str) : super(null){
    super.currentEnum = enumFromFirestoreString(str);
  }
}

//2. DRIVER OR COURIER
class Courier {
  static CollectionReference colRef = Firestore.instance.collection("couriers");

  static String courierIDFS = "courierID";
  static String nameFS = "name";
  static String currentLocationFS = "currentLocation";
  static String statusFS = "status";

  DocumentReference ref; //todo add to everything
  String courierID;
  String name;
  GeoPoint currentLocation; //only available if you are on activeDuty
  CourierStatusEnum status;
  //bool busy/oncall
  //todo connect to user id

  Courier.fromDocumentSnapshot(DocumentSnapshot snap){
    ref = snap.reference;
    Map<String, dynamic> result = snap.data;
    this.courierID = result[courierIDFS];
    this.name = result[nameFS];
    this.currentLocation = result[currentLocationFS];
    this.status = CourierStatusEnum.fromFirestoreString(result[statusFS]);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      courierIDFS : this.courierID,
      nameFS : this.name,
      currentLocationFS : this.currentLocation,
      statusFS : this.status.firestoreString,
    };
    return result;

  }

}