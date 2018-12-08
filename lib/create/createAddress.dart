import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_test/classes/user.dart';//todo split up address later

class CreateAddress extends StatefulWidget {
  Function callback;
  CreateAddress (this.callback);

  _CreateAddressState createState() => _CreateAddressState();
}

class _CreateAddressState extends State<CreateAddress> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Address currentAddress = new Address();
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
      key: _formKey,
       child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Address Line 1",
                ),
                validator: (value){
                  if (value.isEmpty) return "Cannot be empty";
                },
                onSaved: (value){
                  this.currentAddress.line1 = value;
                },
              ),
              TextFormField(//no validator because it's okay if empty
                decoration: InputDecoration(
                  labelText: "Address Line 2",
                ),
                onSaved: (value){
                  this.currentAddress.line2 = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Kampung",
                ),
                validator:  (value) {
                  if (value.isEmpty) return "Cannot be empty";
                },
                onSaved: (value){
                  this.currentAddress.kampung = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "District",
                ),
                validator:  (value) {
                  if (value.isEmpty) return "Cannot be empty";
                },
                onSaved: (value) {
                  this.currentAddress.district = value;
                }
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Country"
                ),
                initialValue: "Brunei",
                validator:  (value) {
                  if (value.isEmpty) return "Cannot be empty";
                },
                onSaved: (value) {
                  this.currentAddress.country = value;
                },
              )
            ],
          )
        ),
       )
    ),
    FlatButton(
      child: Text("Save"),
      onPressed: (){
        widget.callback(this.currentAddress);//this widget should return a currentAddress
        Navigator.pop(context);
      },
    )
      ] 
    );
  }
}