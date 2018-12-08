import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_test/classes/user.dart';
import 'createAddress.dart';
import 'package:hackathon_test/helper/address.dart';

class CreateUser extends StatefulWidget {
  String email;
  CreateUser(this.email);
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final _formKey = GlobalKey<FormState>();

  void onSaved () {
    if (_formKey.currentState.validate()){
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Processing Data'))
      );
     }
  }
    User currentUser;


  @override
  initState(){
    super.initState();
    currentUser = User.data(
    null,null,null,widget.email
    );
  }

  bool invalidUserID = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Text")),
      body: 
        SingleChildScrollView(
         child: 
           Form(
             key: _formKey,
             child: Padding(
               padding: const EdgeInsets.all(16.0),
               child: Column( 
               crossAxisAlignment: CrossAxisAlignment.start,

               children: <Widget>[
                 TextFormField(
                   decoration: const InputDecoration(
                     labelText: "ID",
                      hintText: "Your unique user ID"
                   ),
                   onFieldSubmitted: (value) async {
                    DocumentSnapshot snap = await User.colRef.document(value).get();
                    if (!snap.exists) {
                      this.invalidUserID = true;
                      var dialog = AlertDialog(
                        title: Text ("Invalid User ID, please choose another one"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("Okay"),
                            onPressed: (){},
                          )
                        ],
                      );
                      showDialog(context: context, child: dialog);
                    } else {
                      this.invalidUserID = false;
                    }
                   },
                 ),
                 TextFormField(
                   decoration: const InputDecoration(
                     labelText: "Name",
                      border: const OutlineInputBorder(),
                   ),
                   validator: (value) {
                     if (value.isEmpty) return 'Cannot be left empty';
                   },
                   onSaved: (value){
                      currentUser.name = value;
                   },
                 ),
               
                  ListTile( leading: Text("Delivery Address"), title: FlatButton(
                    child: Text("Find your Address"),
                    onPressed: (){
                      void callback (Address newAddress) {
                        currentUser.homeAddress = newAddress;
                      }//create address should return an address
                      Navigator.of(context).push(
                        new MaterialPageRoute(builder: (context) => new CreateAddress(callback))
                      );
                    }//Navigator.push,
                  ),),
                 
                 Padding(
                   padding: const EdgeInsets.symmetric(vertical: 16.0),
                   child: RaisedButton(
                     child: Text('Submit'),
                     onPressed: (){
                       if (_formKey.currentState.validate() && invalidUserID){
                         _formKey.currentState.save();
                         User.colRef.document(this.currentUser.name).setData(this.currentUser.toMap());
                       }
                     }
                   ),
                 ),
                 
               ],
               ),
               
             ),
           )
         
       ),
      
    );
}
}



