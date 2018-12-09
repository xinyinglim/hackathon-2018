import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_test/create/createAddress.dart';
import 'package:hackathon_test/classes/user.dart';
import 'package:hackathon_test/classes/deliveryRequest.dart';
import 'package:hackathon_test/helper/address.dart';
import 'package:hackathon_test/main.dart';
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
                      Navigator.pushReplacement(context,  MaterialPageRoute(
                        builder: (context) => CreateDelivery2(this.widget.deliveryRequest)));
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

class AddSenderLocation extends StatefulWidget {
  DeliveryRequest deliveryRequest;
  AddSenderLocation(this.deliveryRequest){
  }
  _AddSenderLocationState createState() => _AddSenderLocationState();
}

class _AddSenderLocationState extends State<AddSenderLocation> {
  void savePickupLocation(Address value){
    widget.deliveryRequest.pickupAddress = value;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Sender Location"),
      actions: <Widget>[
        FlatButton(child: Text("Save"),
        onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => CreateDelivery2(widget.deliveryRequest),
          ));
        },)
      ],),
      body: CreateAddress(savePickupLocation),
    );
  }

  
}

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Test"),
    );
  }
}

//1 is to 
class CreateDelivery2 extends StatefulWidget {
  DeliveryRequest deliveryRequest;
  CreateDelivery2 (this.deliveryRequest);
  _CreateDelivery2State createState() => _CreateDelivery2State();
}

class _CreateDelivery2State extends State<CreateDelivery2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Pickup Location"),
        actions: <Widget>[
          FlatButton(
            child: Text("Next"),
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => SizeAndDistancePage(widget.deliveryRequest)
              ));
            },
          )
        ],
      ),
      body: Text("Pickup Location"),
    );
  }
}

class SizeAndDistancePage extends StatefulWidget {
  DeliveryRequest deliveryRequest;
  SizeAndDistancePage(this.deliveryRequest);
  _SizeAndDistancePageState createState() => _SizeAndDistancePageState();
}

class _SizeAndDistancePageState extends State<SizeAndDistancePage> {
  num price = 3;
  
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: Text("Parcel Size"), actions: <Widget>[
        FlatButton(child: Text("Next"), onPressed: (){
          if(_formKey.currentState.validate()){
            _formKey.currentState.save();
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => CreditCardPage(widget.deliveryRequest)
            ));
          }
        },)
      ],),
      body: Form(
        key: _formKey,
        child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: "Description of Package",
            ),
            validator: (value){
              if (value.isEmpty) return "Cannot be empty";
            },
            onSaved: (value){
              widget.deliveryRequest.parcelID = value;
              widget.deliveryRequest.estimatedPickupTime = DateTime.now().add(Duration(minutes:10));
            },
          ),
          const SizedBox(
            height: 32.0,
          ),
          Text("Your Total Cost will be $price"),
        ],
      ),
    )
    );
  }
}

class CreditCardPage extends StatefulWidget {
  DeliveryRequest deliveryRequest;
  CreditCardPage(this.deliveryRequest);
  _CreditCardPageState createState() => _CreditCardPageState();
}

class _CreditCardPageState extends State<CreditCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Checkout"),
      actions: <Widget>[FlatButton(child: Text("Send Order"),
      onPressed: (){
        Navigator.pushReplacementNamed(context, MyApp.mapPageRoute);
      },
      )],),
      body: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: "CardHolder Name:"
            ),
          ),
          TextFormField(
          decoration: InputDecoration(
            labelText: "Credit Card No:",
          hintText: "1234 5678 9012 3456"
          ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Date of Expiry",
                  hintText: "MM/YY"
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "CVV",
                )
              )
            ],
          )
        
        ]
      )
     );
    
  }
}

class ConfirmationPage extends StatefulWidget {
  DeliveryRequest deliveryRequest;
  ConfirmationPage(this.deliveryRequest);
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {

  _ConfirmationPageState(){
    Firestore.instance.runTransaction((transaction)async{
      DocumentReference newRef = DeliveryRequest.colRef.document();
      transaction.set(newRef, widget.deliveryRequest.toMap());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Confirmation Page"),
      actions: <Widget>[
        FlatButton(
          child: Text("Done"),
          onPressed: (){
            Navigator.pushReplacementNamed(context, MyApp.mapPageRoute);
          },
        )
      ],
    ),
    body: Center(child: Text("Your Order has been received!\nWe will notify you when a driver has been found."),)
    );

  }
}