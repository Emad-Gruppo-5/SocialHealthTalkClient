import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_emad/patient/home.dart';
import '../main.dart';
import 'modify_profile.dart';

/// This is the main application widget.
class Profile extends StatefulWidget {
  final String nome;
  final String cognome;
  final String email;
  final String num_cellulare;
  final int tipologia_chat;
  final String cod_fiscale;
  final String token;

  const Profile(
      {required this.cod_fiscale,
      required this.nome,
      required this.cognome,
      required this.email,
      required this.num_cellulare,
      required this.tipologia_chat,
      required this.token});

  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  late String nome;
  late String cognome;
  late String email;
  late String num_cellulare;
  late int tipologia_chat;
  late String cod_fiscale;
  late String token;
  late String ultimo_accesso;
  @override
  void initState() {
    nome = widget.nome;
    cognome = widget.cognome;
    email = widget.email;
    num_cellulare = widget.num_cellulare;
    tipologia_chat = widget.tipologia_chat;
    cod_fiscale = widget.cod_fiscale;
    token = widget.token;
    super.initState();
  }
  Duration alert_duration = const Duration(seconds: 20);
  Duration online_duration = const Duration(seconds: 7);
  late Timer timer;
  late Timer timer_alert;
  String timerText = "Start";

  Widget _iconButtonPush(BuildContext context, IconData icon, String tooltip) {
    if (tooltip != 'Logout') {
      return IconButton(
        icon: Icon(icon),
        tooltip: tooltip,
        iconSize: 40,
        onPressed: () {
          timer.cancel();
          timer_alert.cancel();
          print("UPDATE FIRESTORE");
          FirebaseFirestore.instance
              .collection('patients')
              .doc(cod_fiscale)
              .update({'status': 'online'});

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ModifyProfile(
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
    } else {
      return IconButton(
        icon: Icon(icon),
        tooltip: tooltip,
        iconSize: 40,
        onPressed: () {
          timer.cancel();
          timer_alert.cancel();
          DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm");
          String ultimo_accesso = dateFormat.format(DateTime.now());
          FirebaseFirestore.instance
              .collection('patients')
              .doc(cod_fiscale)
              .update({'status': 'offline', 'ultimo_accesso': ultimo_accesso});

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyApp()));
        },
      );
    }
  }

  Widget _iconButtonPop(BuildContext context, IconData icon, String tooltip) {
    return IconButton(
      icon: Icon(icon),
      tooltip: tooltip,
      iconSize: 40,
      onPressed: () {
        timer.cancel();
        timer_alert.cancel();
        print("UPDATE FIRESTORE");
        FirebaseFirestore.instance
            .collection('patients')
            .doc(cod_fiscale)
            .update({'status': 'online'});

        Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Patient_Home(
                      cod_fiscale: cod_fiscale,
                      nome: nome,
                      cognome: cognome,
                      email: email,
                      num_cellulare: num_cellulare,
                      tipologia_chat: tipologia_chat,
                      token: token
                      ),
                  ),
                );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    timer = Timer(online_duration, handleTimeout);
    timer_alert = Timer(alert_duration, callback);
    return MaterialApp(
      home: GestureDetector(
        child: Scaffold(
          appBar: AppBar(
            leading: _iconButtonPop(context, Icons.arrow_back, 'Indietro'),
            title: const Center(
              child: Text("Profilo"),
            ),
            actions: [
              _iconButtonPush(context, Icons.edit, 'Modifica'),
              _iconButtonPush(context, Icons.logout, 'Logout'),
            ],
          ),
          body: Column(
            children: [
              Text(
                "$nome $cognome",
                style: TextStyle(fontSize: 30),
              ),
              _card("$cod_fiscale", Icons.person),
              _card("$num_cellulare", Icons.smartphone),
              _card("$email", Icons.email),
              const Text("\nTipologia chat"),
              _checkboxListTile(
                  "Solo testo", tipologia_chat == 0 ? true : false),
              _checkboxListTile(
                  "Videochiamata", tipologia_chat == 1 ? true : false),
              _checkboxListTile(
                  "Chiamata vocale", tipologia_chat == 2 ? true : false),
            ],
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

  Widget _card(String title, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
      ),
    );
  }

  Widget _checkboxListTile(String text, bool value) {
    return CheckboxListTile(
      title: Text(text),
      contentPadding: const EdgeInsets.symmetric(horizontal: 100),
      value: value,
      onChanged: null,
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
              'data': ultimo_accesso
        });
  }
}


