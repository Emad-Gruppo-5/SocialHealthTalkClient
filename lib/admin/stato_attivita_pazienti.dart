import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatoAttivitaPazienti extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stato attività pazienti',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: new AppBar(
          title: Text('Stato attività pazienti'),
          leading: new IconButton(
            icon: Icon(Icons.arrow_back_ios_sharp),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: BodyLayout(),
      ),
    );
  }
}

class BodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }
}

Widget _myListView(BuildContext context) {
  final Stream<QuerySnapshot> _patients =
      FirebaseFirestore.instance.collection('patients').snapshots();

  return StreamBuilder<QuerySnapshot>(
    stream: _patients,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return const Text('Something went wrong');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Text("Loading");
      }

      return ListView(
        children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          Icon online = const Icon(Icons.circle, color: Colors.green),
              offline = const Icon(Icons.circle, color: Colors.red);
          Timestamp timestamp = data['last_seen'];
          DateTime lastSeen = DateTime.parse(timestamp.toDate().toString());
          int hour = lastSeen.hour, minute = lastSeen.minute;
          return ListTile(
            leading: data['status'] == 'online' ? online : offline,
            title: Text(data['name']),
            subtitle: data['status'] == 'online'
                ? Text(data['status'])
                : Text("ultimo accesso alle " +
                    hour.toString() +
                    ":" +
                    minute.toString()),
          );
        }).toList(),
      );
    },
  );
}
