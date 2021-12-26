import 'dart:async';
//import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// This is the main application widget.
// ignore: must_be_immutable
class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final String patientId = "patient1"; // patientId
  Duration seconds = const Duration(seconds: 5);
  late Timer timer;

  handleTimeout() {
    FirebaseFirestore.instance
        .collection('patients')
        .doc(patientId) // patientId
        .update({'status': 'offline', 'last_seen': Timestamp.now()})
        .then((value) => print("patient status updated"))
        .catchError(
            (error) => print("Failed to update patient status: $error"));
    //await http.get("http://127.0.0.1:5000/timeout");
  }

  Widget _iconButtonPush(BuildContext context, IconData icon, String tooltip,
      StatelessWidget statelessWidget) {
    return IconButton(
      icon: Icon(icon),
      tooltip: tooltip,
      iconSize: 40,
      onPressed: () {
        timer.cancel();

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => statelessWidget),
        ).then((value) {
          timer = Timer(seconds, handleTimeout);
        });
      },
    );
  }

  Widget _iconButtonPop(BuildContext context, IconData icon, String tooltip) {
    return IconButton(
      icon: Icon(icon),
      tooltip: tooltip,
      iconSize: 40,
      onPressed: () {
        timer.cancel();

        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    timer = Timer(seconds, handleTimeout);

    return MaterialApp(
      home: GestureDetector(
        child: Scaffold(
          appBar: AppBar(
            leading: _iconButtonPush(
                context, Icons.account_circle, 'Profilo', const Profile()),
            title: const Text("Promemoria giornalieri"),
            actions: [
              _iconButtonPop(context, Icons.logout, 'Logout'),
            ],
          ),
          body: const Center(
            child: MyHome(),
          ),
        ),
        onTap: () {
          timer.cancel();
          FirebaseFirestore.instance
              .collection('patients')
              .doc(patientId)
              .update({'status': 'online'})
              .then((value) => print("patient status updated"))
              .catchError(
                  (error) => print("Failed to update patient status: $error"));
          timer = Timer(seconds, handleTimeout);
        },
      ),
    );
  }
}

/// This is the stateless widget that the main application instantiates.
class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  Widget _card(String title, String subtitle) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _card('Hai preso la pillola?', 'Dott. Bianchi\nOre: 9:30'),
        _card('Videochiamata con Gianni Valeri', '(Parente)\nOre: 17:30'),
        _card(
            'Qual è il tuo livello di pressione?', 'Dott. Bianchi\nOre: 18:00'),
      ],
    );
  }
}