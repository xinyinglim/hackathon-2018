import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_test/create/createAddress.dart';
import 'package:hackathon_test/classes/user.dart';
import 'package:hackathon_test/classes/deliveryRequest.dart';
import 'package:hackathon_test/helper/address.dart';
import 'package:hackathon_test/main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddSenderLocation extends StatefulWidget {
  DeliveryRequest deliveryRequest;
  AddSenderLocation(this.deliveryRequest);
  _AddSenderLocationState createState() => _AddSenderLocationState();
}

class _AddSenderLocationState extends State<AddSenderLocation> {
  void savePickupLocation(Address value) {
    widget.deliveryRequest.pickupAddress = value;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CreateDelivery(widget.deliveryRequest),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Sender Location"),
      ),
      body: CreateAddress(savePickupLocation),
    );
  }
}

class CreateDelivery extends StatefulWidget {
  DeliveryRequest deliveryRequest;
  CreateDelivery(this.deliveryRequest);
  _CreateDeliveryState createState() => _CreateDeliveryState();
}

class _CreateDeliveryState extends State<CreateDelivery> {
  GeoPoint startGeoPoint = GeoPoint(4.9008044, 114.9286759); //duli
//  Address startAddress;

  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create New Delivery"),
        actions: <Widget>[
          FlatButton(
            child: Text("Next"),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CreateDelivery2(widget.deliveryRequest)));
            },
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            this.mapController = controller;
            //todo not very efficient, keeps clearning and readding everything
            this.mapController.addMarker(MarkerOptions(
                  position: LatLng(this.startGeoPoint.latitude,
                      this.startGeoPoint.longitude),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue),
                ));
            // debugPrint("lattitude: ${driver.currentLocation.latitude}");

            //todo implement the 10m thing
            //map will update time ever 10s in the future, otherwise there will be a lot of updates
          },
          options: GoogleMapOptions(
            cameraPosition: CameraPosition(
              target: LatLng(
                  startGeoPoint.latitude,
                  startGeoPoint
                      .longitude), //camera centres on Progresif HQ by default
              zoom: 17.0,
              tilt: 0.0,
              bearing: 270.0,
            ),
            myLocationEnabled: true,
          ),
        ),
      ),

//        body: Column(
//          children: <Widget>[CreateAddress(callback)],
//        ) //Text("Section1"),
    );
  }

  String testing = "placeholder";
  Function callback(Address address) {
    setState(() {
      testing = address.toString();
    });
  }
}

class CreateDelivery2 extends StatefulWidget {
  DeliveryRequest deliveryRequest;
  CreateDelivery2(this.deliveryRequest);
  _CreateDelivery2State createState() => _CreateDelivery2State();
}

class _CreateDelivery2State extends State<CreateDelivery2> {
  Function callback(Address address) {
    widget.deliveryRequest.recipientAddress = address;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                GiveRecipientLocation(widget.deliveryRequest)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Pickup Location"),
      ),
      body: CreateAddress(callback),
    );
  }
}

class GiveRecipientLocation extends StatefulWidget {
  DeliveryRequest deliveryRequest;
  GiveRecipientLocation(this.deliveryRequest);
  @override
  _GiveRecipientLocationState createState() => _GiveRecipientLocationState();
}

class _GiveRecipientLocationState extends State<GiveRecipientLocation> {
  GeoPoint endGeopoint = GeoPoint(4.901934, 114.9163313);

  GoogleMapController mapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pin Recipient Location'),
        actions: <Widget>[
          FlatButton(
              child: Text("Next"),
              onPressed: () {
                widget.deliveryRequest.recipientAddress.geoPoint = endGeopoint;
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SizeAndDistancePage(widget.deliveryRequest),
                    ));
              }),
        ],
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          this.mapController = controller;
          //todo not very efficient, keeps clearning and readding everything
          this.mapController.addMarker(MarkerOptions(
                position: LatLng(
                    this.endGeopoint.latitude, this.endGeopoint.longitude),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
              ));
          // debugPrint("lattitude: ${driver.currentLocation.latitude}");

          //todo implement the 10m thing
          //map will update time ever 10s in the future, otherwise there will be a lot of updates
        },
        options: GoogleMapOptions(
          cameraPosition: CameraPosition(
            target: LatLng(
              endGeopoint.latitude,
              endGeopoint.longitude,
            ), //camera centres on Progresif HQ by default
            zoom: 17.0,
            tilt: 0.0,
            bearing: 270.0,
          ),
          myLocationEnabled: true,
        ),
      ),
    );
  }
}

//1 is to

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
        appBar: AppBar(
          title: Text("Parcel Size"),
          actions: <Widget>[
            FlatButton(
              child: Text("Next"),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CreditCardPage(widget.deliveryRequest)));
                }
              },
            )
          ],
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: "A cooler box of tuna",
                decoration: InputDecoration(
                  labelText: "Description of Package",
                ),
                validator: (value) {
                  if (value.isEmpty) return "Cannot be empty";
                },
                onSaved: (value) {
                  widget.deliveryRequest.parcelID = value;
                  widget.deliveryRequest.estimatedPickupTime =
                      DateTime.now().add(Duration(minutes: 10));
                },
              ),
              const SizedBox(
                height: 32.0,
              ),
              Text("Your Total Cost will be $price"),
            ],
          ),
        ));
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
        appBar: AppBar(
          title: Text("Checkout"),
          actions: <Widget>[
            FlatButton(
              child: Text("Send Order"),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ConfirmationPage(widget.deliveryRequest)));
              },
            )
          ],
        ),
        body: Column(children: [
          TextFormField(
            initialValue: "John Doe",
            decoration: InputDecoration(labelText: "CardHolder Name:"),
          ),
          TextFormField(
            initialValue: "1234 5678 9012 3456",
            decoration: InputDecoration(labelText: "Credit Card No:"),
          ),
          TextFormField(
            initialValue: "12/22",
            decoration: InputDecoration(
              labelText: "Date of Expiry",
            ),
          ),
          TextFormField(
              initialValue: "999",
              decoration: InputDecoration(
                labelText: "CVV",
              ))
        ]));
  }
}

class ConfirmationPage extends StatefulWidget {
  DeliveryRequest deliveryRequest;
  ConfirmationPage(this.deliveryRequest);
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  _ConfirmationPageState() {
    Firestore.instance.runTransaction((transaction) async {
      DocumentReference newRef = DeliveryRequest.colRef.document();
      await transaction.set(newRef, widget.deliveryRequest.toMap());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Confirmation Page"),
          actions: <Widget>[
            FlatButton(
              child: Text("Done"),
              onPressed: () {
                Navigator.pushReplacementNamed(context, MyApp.mapPageRoute);
              },
            )
          ],
        ),
        body: Center(
          child: Text(
              "Your Order has been received!\nWe will notify you when a driver has been found."),
        ));
  }
}
