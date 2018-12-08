import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_test/create/createAddress.dart';
import 'package:hackathon_test/classes/user.dart';
import 'package:hackathon_test/classes/deliveryRequest.dart';
class CreateDelivery extends StatefulWidget {
  DeliveryRequest deliveryRequest;  
  CreateDelivery (this.deliveryRequest);
  _CreateDeliveryState createState() => _CreateDeliveryState();
}

class _CreateDeliveryState extends State<CreateDelivery> {
  GeoPoint startGeoPoint;
  Address startAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create New Delivery"),
        actions: <Widget>[
          FlatButton(
            child: Text("Next"),
            onPressed: (){
              Function callback(Address address){
                this.startAddress = address;
              }
              SimpleDialog dialog = SimpleDialog(
                title: CreateAddress(callback),
                children: <Widget>[
                  FlatButton(
                    child: Text("Save Address"),
                    onPressed: (){
                      // if (this.dialog)//TODO
                    },
                  )],
                
                
              );
              showDialog(child: dialog, barrierDismissible: false,
              );
              //todo
              //Navigator.pushReplacement(context, )
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Text(testing),
          CreateAddress(callback)
        ],
      )//Text("Section1"),
    );
  }


  String testing = "placeholder";
  Function callback(Address address){
    setState(() {
          testing = address.toString();
        });
  }
}

//1 is to 
class CreateDelivery2 extends StatefulWidget {
  _CreateDelivery2State createState() => _CreateDelivery2State();
}

class _CreateDelivery2State extends State<CreateDelivery2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Pickup Location"),
      ),
      body: Text("Pickup Location"),
    );
  }
}