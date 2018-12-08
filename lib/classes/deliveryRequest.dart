import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_test/helper/firestoreEnum.dart';
import 'package:hackathon_test/helper/address.dart';

enum DeliveryStatus {FindingDrivers, AwaitingPickup, OnItsWay, Delivered, Cancelled}

class DeliveryStatusEnum extends FirestoreEnum<DeliveryStatus> {



  @override
  Map<DeliveryStatus, String> get enumToFirestore => {
    DeliveryStatus.FindingDrivers : "findingDrivers",
    DeliveryStatus.AwaitingPickup : "awaitingPickup",
    DeliveryStatus.OnItsWay : "onItsWay",
    DeliveryStatus.Delivered : "delivered",
    DeliveryStatus.Cancelled : "cancelled",
  };

  @override
  Map<DeliveryStatus,String> get enumToDisplay => {
    DeliveryStatus.FindingDrivers : "Finding Drivers",
    DeliveryStatus.AwaitingPickup : "Awaiting Pickup",
    DeliveryStatus.OnItsWay : "On its way",
    DeliveryStatus.Delivered : "Delivered",
    DeliveryStatus.Cancelled : "Cancelled",
  };

  DeliveryStatusEnum.fromFirestoreString(String str):super(null){
    this.currentEnum = enumFromFirestoreString(str);
  }
}

class DeliveryRequest {

  static CollectionReference colRef = Firestore.instance.collection("deliveryRequests");
  static String deliveryIDFS = "deliveryID";
  static String courierIDFS = "courierID";
  static String senderIDFS = "senderID";
  static String recipientConfirmationCodeFS = "recipientConfirmationCode";
  static String parcelIDFS = "parcelID";
  static String requestedArrivalTimeFS = "requestedArrivalTime";
  static String estimatedArrivalTimeFS = "estimatedArrivalTime";
  static String actualArrivalTimeFS = "actualArrivalTime";
  static String estimatedPickupTimeFS = "actualPickupTime";
  static String actualPickupTimeFS = "actualPickupTime";
  static String deliveryStatusEnumFS = "deliveryStatusEnum";
  static String pickupAddressFS = "pickupAddress";
  static String recipientAddressFS = "recipientAddress";

  DocumentReference ref;
  String deliveryID;
  String driverID;
  String senderID;
  String recipientConfirmationCode;
  String parcelID;
  DateTime requestedArrivalTime;  //customer can request when they want it
  DateTime estimatedArrivalTime; //customer is given notice when it will arrive
  DateTime actualArrivalTime;
  DateTime estimatedPickupTime;
  DateTime actualPickupTime;
  DeliveryStatusEnum deliveryStatusEnum;
  Address recipientAddress;
  Address pickupAddress; //pickup from sender or otherwise

  DeliveryRequest.fromDocumentSnapshot(DocumentSnapshot snap){
    this.ref = snap.reference;
    Map<String, dynamic> map = snap.data;
    this.deliveryID = map[deliveryIDFS];
    this.driverID = map[courierIDFS];
    this.senderID = map[senderIDFS];
    this.recipientConfirmationCode = map[recipientConfirmationCodeFS];
    this.parcelID = map[parcelIDFS];
    this.requestedArrivalTime = (map[requestedArrivalTimeFS] == null) ? null : DateTime.fromMillisecondsSinceEpoch(int.parse(map[requestedArrivalTimeFS].toString()));
    this.estimatedArrivalTime = (map[estimatedArrivalTimeFS] == null) ? null : DateTime.fromMillisecondsSinceEpoch(int.parse(map[estimatedArrivalTimeFS].toString()));
    this.actualArrivalTime = (map[actualArrivalTimeFS] == null) ? null : DateTime.fromMillisecondsSinceEpoch(int.parse(map[actualArrivalTimeFS].toString()));
    this.estimatedPickupTime = (map[estimatedPickupTimeFS] == null) ? null : DateTime.fromMillisecondsSinceEpoch(int.parse(map[estimatedPickupTimeFS].toString()));
    this.actualPickupTime = (map[actualPickupTimeFS] == null) ? null : DateTime.fromMillisecondsSinceEpoch(int.parse(map[actualPickupTimeFS].toString()));
    //todo null should not be an option in production code
    this.deliveryStatusEnum = DeliveryStatusEnum.fromFirestoreString(map[deliveryStatusEnum]);
    this.recipientAddress = Address.fromMap(map[recipientAddressFS]);
    this.pickupAddress = Address.fromMap(map[pickupAddress]);
  }

  DeliveryRequest();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      deliveryIDFS : deliveryID,
      courierIDFS : driverID,
      senderIDFS : senderID,
      recipientConfirmationCodeFS : recipientConfirmationCode,
      parcelIDFS : parcelID,
    };
    if (this.requestedArrivalTime != null) result.addAll({requestedArrivalTimeFS : this.requestedArrivalTime.millisecondsSinceEpoch});
      if (this.estimatedArrivalTime != null) result.addAll({estimatedArrivalTimeFS : this.estimatedArrivalTime.millisecondsSinceEpoch});
    if (this.actualArrivalTime != null) result.addAll({actualArrivalTimeFS : this.actualArrivalTime.millisecondsSinceEpoch});
    if (this.estimatedPickupTime != null) result.addAll({estimatedPickupTimeFS : this.estimatedPickupTime.millisecondsSinceEpoch});
    if (this.actualPickupTime != null) result.addAll({actualPickupTimeFS : this.actualPickupTime.millisecondsSinceEpoch});
    return result;
  }
}