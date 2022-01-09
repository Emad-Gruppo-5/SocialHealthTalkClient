import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../main.dart';
import 'profile.dart';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// This is the main application widget.
class Patient_Home extends StatelessWidget {
  // final String cod_fiscale;
  final String nome;
  final String cognome;
  final String email;
  final String num_cellulare;
  final int tipologia_chat;
  final String token;
  final String cod_fiscale;

  Patient_Home(
      {required this.cod_fiscale,
      required this.nome,
      required this.cognome,
      required this.email,
      required this.num_cellulare,
      required this.tipologia_chat,
      required this.token});

  Duration online_duration = const Duration(seconds: 7);
  Duration alert_duration = const Duration(seconds: 20);
  late Timer timer;
  late Timer timer_alert;
  String timerText = "Start";
  late String ultimo_accesso;

  CollectionReference _notificationsReference = FirebaseFirestore.instance.collection('prova');


  Widget _iconButtonPush(BuildContext context, IconData icon, String tooltip) {
    print("cod_fiscale: " + cod_fiscale);
    return IconButton(
      icon: Icon(icon),
      tooltip: tooltip,
      iconSize: 40,
      onPressed: () {
        timer.cancel();
        timer_alert.cancel();
        print("TAP UTENTE");
        FirebaseFirestore.instance
            .collection('patients')
            .doc(cod_fiscale)
            .update({'status': 'online'});

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Profile(
                  cod_fiscale: cod_fiscale,
                  nome: nome,
                  cognome: cognome,
                  email: email,
                  num_cellulare: num_cellulare,
                  tipologia_chat: tipologia_chat,
                  token: token)),
        );
      },
    );
  }

  Widget _iconButtonPop(BuildContext context, IconData icon, String tooltip) {
    return IconButton(
      icon: Icon(icon),
      tooltip: tooltip,
      iconSize: 40,
      onPressed: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyApp()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    timer = Timer(online_duration, handleTimeout);
    timer_alert = Timer(alert_duration, callback);

    // print("UPDATE FIRESTORE");
    FirebaseFirestore.instance
        .collection('patients')
        .doc(cod_fiscale)
        .update({'status': 'online'});
    DateFormat dateFormat = DateFormat("yyyy/MM/dd HH:mm");
    return MaterialApp(
      
      home: GestureDetector(
        child: Scaffold(
          appBar: AppBar(
            leading: _iconButtonPush(
              context,
              Icons.account_circle,
              'Profilo',
            ),
            title: const Text("Promemoria giornalieri"),
            actions: [
              _iconButtonPop(context, Icons.logout, 'Logout'),
            ],
          ),
          body: StreamBuilder<QuerySnapshot>(
              stream: _notificationsReference
                      // .where('cod_fiscale_paziente', isEqualTo: cod_fiscale)
                      // .where('data_domanda', isLessThanOrEqualTo: dateFormat.format(DateTime.now()))
                      // .orderBy("data_domanda", descending: true)
                      .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                print(DateTime.now());

                

                if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.docs.isEmpty) {
                    return Center( child: Image.asset('assets/images/promemoria.png'));
                }
                else
                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                    String subtitle = "";
                    Icon trailing;
                    print(data.toString());

                    return Center(
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Visibility(
                                    child: const Icon(Icons.circle,
                                        color: Colors.blue, size: 15),
                                    visible: !data['letto'],
                                  ),
                                ],
                              ),
                              title: Text(data['testo_domanda']),
                              subtitle: Text("Inviata da: " + data["nome"] + " " + data["cognome"] + "\n" 
                                            + data["data_domanda"] + " " + data["ora_domanda"]),
                              onTap: () {
                                _notificationsReference
                                  .doc(document.id)
                                  .update({'letto': true})
                                  .then((value) => print("Notification Updated"))
                                  .catchError((error) =>
                                      print("Failed to update notifications: $error"));
                                showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text(data['testo_domanda']),
                                  content: const Text('Hai preso la pillola?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, 'Cancel'),
                                      child: const Text('Si'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, 'OK'),
                                      child: const Text('No'),
                                    ),
                                    IconButton(
                                      onPressed: () => Navigator.pop(context, 'Keyboard voice'),
                                      icon: const Icon(Icons.mic_none_sharp, color: Colors.blue),
                                    ),
                                  ],
                                ),
                              );
                              },
                            ),
                            // row,
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
        ),
        onTap: () {
          print("TAP UTENTE");
          FirebaseFirestore.instance
              .collection('patients')
              .doc(cod_fiscale)
              .update({'status': 'online'});
          timer.cancel();
          timer_alert.cancel();
          timer = Timer(online_duration, handleTimeout);
          timer_alert = Timer(alert_duration, callback);
        },
      ),
    );
  }

  Widget _card(String title, String subtitle) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }

  void handleTimeout() {
    print("TIMEOUT\nCod_fiscale: " + cod_fiscale);
    DateFormat dateFormat = DateFormat("yyyy/MM/dd HH:mm");
    ultimo_accesso = dateFormat.format(DateTime.now());
    FirebaseFirestore.instance
        .collection('patients')
        .doc(cod_fiscale)
        .update({'status': 'offline', 'ultimo_accesso': ultimo_accesso});
  }
  
  void callback() {
    print("ALERT\nCod_fiscale: " + cod_fiscale);
    FirebaseFirestore.instance
        .collection('notifications')
        .add({
              'alert': true,
              'letto': false,
              'cod_fiscale': cod_fiscale,
              'nome': nome,
              'cognome': cognome,
              'ultimo_accesso': ultimo_accesso
        });
  }
}