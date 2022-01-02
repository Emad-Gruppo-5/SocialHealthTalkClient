import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
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

  Duration seconds = const Duration(seconds: 7);
  late Timer timer;
  String timerText = "Start";

  Widget _iconButtonPush(BuildContext context, IconData icon, String tooltip) {
    print("cod_fiscale: " + cod_fiscale);
    return IconButton(
      icon: Icon(icon),
      tooltip: tooltip,
      iconSize: 40,
      onPressed: () {
        timer.cancel();

        print("UPDATE FIRESTORE");
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
                  tipologia_chat: tipologia_chat)),
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
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    timer = Timer(seconds, handleTimeout);

    print("UPDATE FIRESTORE");
    FirebaseFirestore.instance
        .collection('patients')
        .doc(cod_fiscale)
        .update({'status': 'online'});

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
          body: Center(
            child: ListView(
              children: [
                _card('Hai preso la pillola?', 'Dott. Bianchi\nOre: 9:30'),
                _card(
                    'Videochiamata con Gianni Valeri', '(Parente)\nOre: 17:30'),
                _card(cod_fiscale.toString(), 'prova prova prova'),
              ],
            ),
          ),
        ),
        onTap: () {
          print("UPDATE FIRESTORE");
          FirebaseFirestore.instance
              .collection('patients')
              .doc(cod_fiscale)
              .update({'status': 'online'});
          timer.cancel();
          timer = Timer(seconds, handleTimeout);
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
    DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm");
    String ultimo_accesso = dateFormat.format(DateTime.now());
    FirebaseFirestore.instance
        .collection('patients')
        .doc(cod_fiscale)
        .update({'status': 'offline', 'ultimo_accesso': ultimo_accesso});
  }
}

void callback() {}
