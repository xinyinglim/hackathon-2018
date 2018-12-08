import 'testObjects.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transparent_image/transparent_image.dart';
import 'create/createUser.dart';
import 'classes/currentSession.dart';
import 'package:hackathon_test/classes/user.dart';
import 'package:hackathon_test/create/createDelivery.dart';
import 'package:hackathon_test/auth.dart';
import 'package:hackathon_test/classes/deliveryRequest.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'classes/driver.dart';
import 'dart:core';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  static String mapPageRoute = "/";
  static String currentOrdersRoute = "/currentOrders";
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
        
      ),
      initialRoute: mapPageRoute,
      routes: {
        mapPageRoute : (BuildContext context) => AuthPage(),
        currentOrdersRoute : (BuildContext context) => CurrentOrdersPage(),
      }
      // home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MapPage extends StatefulWidget {
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(context).build(),
      body: Column(
  children: <Widget>[
    Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        onMapCreated: (GoogleMapController controller) {},
      ),
    ),
  ],
      ),


      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.local_shipping),
        onPressed: (){
          //todo make new new shipping order
          Navigator.push(context, new MaterialPageRoute( builder: (context) => new CreateDelivery(null)));
        },
      ),
    );
  }
}



class CustomDrawer {
  BuildContext context;

  CustomDrawer(this.context);
  Widget build(){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget> [
          DrawerHeader(
            child: Text(CurrentSession.currentUser.name),
            decoration: BoxDecoration(
              color: Colors.blue,
            )
          ),
          ListTile(
            title: Text("Map View"),
            onTap: (){
              Navigator.pushReplacementNamed(context, MyApp.mapPageRoute);
              // Navigator.pop(context);//test this
            }
          ),
          ListTile(
            title: Text("Custom Order"),
            onTap: () {
              Navigator.pushReplacementNamed(context, MyApp.currentOrdersRoute);
            }
          )
        ]
      )
    );
  }
}

class DeliveryRequestListItem extends StatefulWidget {
  DeliveryRequest deliveryRequest;
  DeliveryRequestListItem(this.deliveryRequest);
  _DeliveryRequestListItemState createState() => _DeliveryRequestListItemState();
}

class _DeliveryRequestListItemState extends State<DeliveryRequestListItem> {
  User sender;
  Courier courier;
  
  void initializeStreams(){
    User.colRef.document(widget.deliveryRequest.senderID).snapshots().listen((onData){
        setState(() {
          this.sender = User.fromDocumentSnapshot(onData);
                });
    });
    Courier.colRef.document(widget.deliveryRequest.driverID).snapshots().listen((onData){
      this.courier = Courier.fromDocumentSnapshot(onData);
    });

  }

  Widget get progressBar {
    if (this.sender == null|| this.courier == null) return Text("Retrieving data...");
    switch (widget.deliveryRequest.deliveryStatusEnum.currentEnum){
      case DeliveryStatus.FindingDrivers:
        return LinearProgressIndicator(value: 0.0);
      case DeliveryStatus.AwaitingPickup:
        return LinearProgressIndicator(value: 0.1);
      case DeliveryStatus.OnItsWay:
        // num value = (currentDistance/totalDistance*9/10 )
        return LinearProgressIndicator(value : 0.5);
      case DeliveryStatus.Delivered:
        return LinearProgressIndicator(value : 1.0);
      case DeliveryStatus.Cancelled:
        return Text("Cancelled",style: TextStyle(color:Colors.red));//todo add cancelled time

    }
  }

  String formattedDate (DateTime dateTime){
    bool isSameDay(DateTime a, DateTime b){
      if (a.day == b.day && a.month == b.month && a.year == b.year) return true; else return false;
    }
    DateTime today = DateTime.now();
    Duration difference = dateTime.difference(today);
    if (isSameDay(dateTime, today)){
      if (difference.inHours < 1){
        return difference.inMinutes.toString() + " mins";
      }else {
        return difference.inHours.toString() + " hrs";
      }

    } else {
      if (difference.inHours < 24) {
        return difference.inHours.toString() + " hrs";
      } else {
      return difference.inDays.toString() + " days";
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(widget.deliveryRequest.deliveryStatusEnum.displayString),
      title: Text("${courier.name}, ${widget.deliveryRequest.pickupAddress.kampung} to ${widget.deliveryRequest.recipientAddress.kampung}"),
      subtitle: progressBar,
      trailing: Text(formattedDate(widget.deliveryRequest.estimatedArrivalTime)),
    );
  }
}



class CurrentOrdersPage extends StatefulWidget {
  _CurrentOrdersPageState createState() => _CurrentOrdersPageState();
}

class _CurrentOrdersPageState extends State<CurrentOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DeliveryRequest.colRef.where(DeliveryRequest.senderIDFS,isEqualTo: CurrentSession.currentUser.id).snapshots(),
      builder: (context, AsyncSnapshot asyncSnap) {
        if (!asyncSnap.hasData) {
          return Center (child: Text("No Orders being sent!"));
        }
        List<DocumentSnapshot> docList = asyncSnap.data;
        List<DeliveryRequest> list = docList.map((snap) => DeliveryRequest.fromDocumentSnapshot(snap));
        return ListView.builder(
          itemCount: list.length * 2 - 1,
          itemBuilder: (context, index) {
            if (index.isOdd) return Divider();
            int i = index ~/ 2;
            DeliveryRequest currentRequest = list[i];
            return DeliveryRequestListItem(currentRequest);
          },
        );
      },
    );
  }
}

// class PreviousOrdersPage extends StatefulWidget {
//    PreviousOrdersPageState createState() =>  PreviousOrdersPageState();
// }







class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {





  // Widget buildListView(){

  //   // return Center(
  //   //           child: FadeInImage.memoryNetwork(
  //   //             placeholder: kTransparentImage,
  //   //             image:
  //   //                 'https://github.com/flutter/website/blob/master/src/_includes/code/layout/lakes/images/lake.jpg?raw=true',
  //   //           ),
  //   //         );


  //     return StreamBuilder(
  //       stream: Firestore.instance.collection("fruits").snapshots(),
  //       builder: (context, AsyncSnapshot asyncSnap){
  //         if (!asyncSnap.hasData) return CircularProgressIndicator();
  //         QuerySnapshot query = asyncSnap.data;
  //         List<Fruit> fruitList = query.documents.map((doc) => Fruit.fromSnap(doc)).toList();
  //         if (fruitList.isEmpty) {return Center(child: Text("All out"));}
  //         return ListView.builder(
  //       itemCount: fruitList.length,
  //       itemBuilder: (context, index){
  //         return FruitCard(fruitList[index]);
  //       },
  //     );
  //       },
  //     );
      
  //   }


  @override
  Widget build(BuildContext context) {
    // initializeStream();

    
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),

      body: Column(
        children: [
          Container(
            height: 400.0,
            child: Text("Not really used"),//buildListView(),
          )
        ]
      )
    );

    
  }

}

