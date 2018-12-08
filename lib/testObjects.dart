import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/material.dart';
class TestObjects {
  static final TestObjects _instance = new TestObjects._();

  static get instance => _instance;
  TestObjects._() {
    // initializeFirestore();
//    fruits = [
//      Fruit("apple", "apple", 2),
//      Fruit("orange", "orange", 4),
//      Fruit("pear", "pear", 6),
//    ];
  }

  TestObjects();

  Stream<List<Fruit>> fruitStream = Fruit.colRef.snapshots().map((querySnap){
      List<DocumentSnapshot> docList = querySnap.documents;
      return docList.map((docSnap) => Fruit.fromSnap(docSnap));
    });

  void initializeFirestore(){
    this.fruitStream = Fruit.colRef.snapshots().map((querySnap){
      List<DocumentSnapshot> docList = querySnap.documents;
      return docList.map((docSnap) => Fruit.fromSnap(docSnap));
    });
  }
  
    List<Fruit> fruits = [];

  void addNewFruit(Fruit fruit) {
    this.fruits.add(fruit);
  }
}

class Fruit {
  static CollectionReference colRef = Firestore.instance.collection("fruits");
  //todo include collection reference to pictures for card view
  DocumentReference get ref => colRef.document(id);

  String fruitNameFS = "fruitName";
  String imageFS = "image";
  String qtyFS = "qty";
  String idFS = "id";
  String id;
  String fruitName;
  String image;
  num qty;

  Fruit(this.id, this.fruitName, this.qty);

  Fruit.fromSnap(DocumentSnapshot snap) {
    Map<String, dynamic> map = snap.data;
    this.id = snap.documentID;
    this.fruitName = map[fruitNameFS];
    this.qty = map[qtyFS];
    this.image = map[imageFS];
  }

  Map<String, dynamic> toMap() =>
      {idFS: id, fruitNameFS: fruitName, qtyFS: qty, imageFS : image};

  Future<void> uploadToFirestore(Transaction transaction) async {
    await transaction.set(this.ref, toMap());
  }

  void addFruit(num qty) {
    this.qty += qty;
    TestObjects().fruits.forEach((fruit){
      if (this.id == fruit.id){
        fruit.qty += qty;
      }
    });
  }

  void removeFruit(num qty) {
    this.qty -= qty;
    if (qty < 0) throw LessThanZeroFruits();
    TestObjects().fruits.forEach((fruit){
      if (this.id == fruit.id){
        fruit.qty -= qty;
      }
    });
  }

  String toString(){
    return "${this.fruitName} has ${this.qty} pcs";
  }
}

class LessThanZeroFruits implements Exception {
  String message = "Not enough Fruits";
  LessThanZeroFruits({this.message});
}
