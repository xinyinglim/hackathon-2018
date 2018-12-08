import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_test/classes/user.dart';
import 'createAddress.dart';
class CreateUser extends StatefulWidget {
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

  User currentUser = User();

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
                      Navigator.of(context).push(
                        new MaterialPageRoute(builder: (context) => new CreateAddress())
                      );
                    }//Navigator.push,
                  ),),
                 
               
                 Padding(
                   padding: const EdgeInsets.symmetric(vertical: 16.0),
                   child: RaisedButton(
                     child: Text('Submit'),
                     onPressed: (){
                       if (_formKey.currentState.validate()){
                         _formKey.currentState.save();
                         Firestore.instance.collection("users").document(this.currentUser.name).setData(this.currentUser.toMap());
    
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



