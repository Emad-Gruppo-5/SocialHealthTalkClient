import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../main.dart';

class ModifyProfile extends StatefulWidget {
  final String nome;
  final String cognome;
  final String email;
  final int num_cellulare;
  final int tipologia_chat;
  final String cod_fiscale;

  const ModifyProfile(
      {required this.cod_fiscale,
      required this.nome,
      required this.cognome,
      required this.email,
      required this.num_cellulare,
      required this.tipologia_chat});

  @override
  _ModifyProfile createState() => _ModifyProfile();
}

/// This is the main application widget.
class _ModifyProfile extends State<ModifyProfile> {
  late String nome;
  late String cognome;
  late String email;
  late int num_cellulare;
  late int tipologia_chat;
  late String cod_fiscale;

  @override
  void initState() {
    nome = widget.nome;
    cognome = widget.cognome;
    email = widget.email;
    num_cellulare = widget.num_cellulare;
    tipologia_chat = widget.tipologia_chat;
    cod_fiscale = widget.cod_fiscale;
    super.initState();
  }

  Duration duration = const Duration(seconds: 7);
  late Timer timer;
  String timerText = "Start";
  bool _visible = false;

  Widget _iconButtonPush(
      BuildContext context, IconData icon, String tooltip, MyApp myApp) {
    return IconButton(
      icon: Icon(icon),
      tooltip: tooltip,
      iconSize: 40,
      onPressed: () {
        timer.cancel();

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

  Widget _iconButtonPop(BuildContext context, IconData icon, String tooltip) {
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

        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    timer = Timer(duration, handleTimeout);

    return MaterialApp(
      home: GestureDetector(
        child: Scaffold(
          appBar: AppBar(
            leading: _iconButtonPop(context, Icons.arrow_back, 'Indietro'),
            title: const Center(
              child: Text("Modifica dati"),
            ),
            actions: [
              _iconButtonPush(context, Icons.logout, 'Logout', MyApp()),
            ],
          ),
          body: Center(
            child: Column(
              children: [
                Text(
                  "$nome $cognome",
                  style: TextStyle(fontSize: 30),
                ),
                _form(),
                const Text("\nTipologia chat"),
                _checkboxListTile("Solo testo", 0),
                _checkboxListTile("Videochiamata", 1),
                _checkboxListTile("Chiamata vocale", 2),
                Visibility(
                    child: const Text("Seleziona almeno una chat",
                        style: TextStyle(color: Colors.red)),
                    visible: _visible),
                _submitButton(),
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
          timer = Timer(duration, handleTimeout);
        },
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

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          print("UPDATE FIRESTORE");
          FirebaseFirestore.instance
              .collection('patients')
              .doc(cod_fiscale)
              .update({'status': 'online'});
          timer.cancel();
          timer = Timer(duration, handleTimeout);

          if (!isChecked.contains(true)) {
            setState(() {
              _visible = true;
            });
          } else {
            _visible = false;
          }

          // Validate returns true if the form is valid, or false otherwise.
          if (_formKey.currentState!.validate()) {
            // If the form is valid
          }
        },
        child: const Text('Salva'),
      ),
    );
  }

  List<bool> isChecked = [false, true, false];
  final _formKey = GlobalKey<FormState>();

  Widget _textFormField(
      IconData icon, String labelText, String initialValue, String validator) {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(icon),
        labelText: labelText,
      ),
      initialValue: initialValue,
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validator;
        }
        return null;
      },
      onTap: () {
        print("UPDATE FIRESTORE");
        FirebaseFirestore.instance
            .collection('patients')
            .doc(cod_fiscale)
            .update({'status': 'online'});
        timer.cancel();
        timer = Timer(duration, handleTimeout);
      },
      onChanged: (value) {
        print("UPDATE FIRESTORE");
        FirebaseFirestore.instance
            .collection('patients')
            .doc(cod_fiscale)
            .update({'status': 'online'});
        timer.cancel();
        timer = Timer(duration, handleTimeout);
      },
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _textFormField(Icons.smartphone, "Numero di cellulare",
                "$num_cellulare", "Inserisci numero di cellulare"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _textFormField(Icons.email, "E-mail", "$email",
                "Inserisci e-mail"),
          ),
        ],
      ),
    );
  }

  Widget _checkboxListTile(String text, int index) {
    return CheckboxListTile(
      title: Text(text),
      contentPadding: const EdgeInsets.symmetric(horizontal: 100),
      value: isChecked[index],
      onChanged: (bool? value) {
        setState(() {
          isChecked[index] = value!;
        });

        timer.cancel();
        print("UPDATE FIRESTORE");
        FirebaseFirestore.instance
            .collection('patients')
            .doc(cod_fiscale)
            .update({'status': 'online'});
      },
    );
  }
}
