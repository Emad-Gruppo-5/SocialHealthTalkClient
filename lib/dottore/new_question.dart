// ignore_for_file: unnecessary_const

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:test_emad/main.dart';
import 'main_dottore.dart';
import 'profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// This is the main application widget.
class NewQuestion extends StatelessWidget {
  final String paz_cod_fiscale;
  final String token;
  final String cod_fiscale;
  final String nome;
  final String cognome;
  final String email;
  final String num_cellulare;
  final String specializzazione;
  NewQuestion({
    required this.paz_cod_fiscale,
    required this.cod_fiscale,
    required this.token,
    required this.nome,
    required this.cognome, 
    required this.email, 
    required this.num_cellulare,
    required this.specializzazione,
  } );
  TextEditingController _testo_domanda = TextEditingController();
  TextEditingController _data_domanda = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<bool> isChecked = [false, true, false];
  String dropdownValue = 'Una volta';
  Widget _iconButton(BuildContext context, IconData icon, String tooltip,
      StatelessWidget statelessWidget) {
    IconButton iconButton;

    if (tooltip != "Logout") {
      iconButton = IconButton(
        icon: Icon(icon),
        tooltip: tooltip,
        iconSize: 40,
        onPressed: () {
          Navigator.pop(context);
        },
      );
    } else {
      iconButton = IconButton(
        icon: Icon(icon),
        tooltip: tooltip,
        iconSize: 40,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => statelessWidget),
          );
        },
      );
    }

    return iconButton;
  }

   Widget _form() {
    final _formKey = GlobalKey<FormState>();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _textFormField(Icons.help_center_rounded, "Inserisci domanda",
                "Ricordati di inserire la domanda", _testo_domanda),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DateTimePicker(
              controller: _data_domanda,
              type: DateTimePickerType.dateTimeSeparate,
              dateMask: 'd MMM, yyyy',
              locale : const Locale("it","IT"),
              initialDate: DateTime.now(),
              firstDate: DateTime.now().subtract(Duration(days: 0)),
              lastDate: DateTime(2100),
              icon: const Icon(Icons.event),
              dateLabelText: 'Data',
              timeLabelText: "Ora",
              selectableDayPredicate: (date) {
                _textFormField(Icons.help_center_rounded,
                                "Inserisci data",
                                "Ricordati di inserire la data",
                                _data_domanda);
                return true;
              },
              onChanged: (val) { 
                print(val);
                  _textFormField(Icons.help_center_rounded,
                                "Inserisci data",
                                "Ricordati di inserire la data",
                                _data_domanda);
                
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Ripeti:  "),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.blue),
                  underline: Container(
                    height: 2,
                    color: Colors.grey,
                  ),
                  onChanged: (String? newValue) {
                      dropdownValue = newValue!;
                  },
                  items: <String>['Una volta', 'Ogni giorno', 'Ogni settimana', 'Ogni mese']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  DateFormat dateFormat = DateFormat("yyyy/MM/dd HH:mm");
                  print("DATI DA INVIARE:\nTesto: " + _testo_domanda.text);
                  print("Data: " + _data_domanda.text);
                  print("Ripeti: " + dropdownValue);
                  print(nome + " " + cognome + " " + cod_fiscale);
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    CollectionReference questions = FirebaseFirestore.instance.collection('questions');
                    questions.add({
                      'cod_fiscale_dottore' : cod_fiscale,
                      'cod_fiscale_paziente': paz_cod_fiscale,
                      'cognome': cognome,
                      'nome': nome,
                      'letto': false,
                      'data_domanda':  _data_domanda.text,
                      'ripeti': dropdownValue,
                      'testo_domanda': _testo_domanda.text
                    });
                    ScaffoldMessenger.of(_scaffoldKey.currentContext!)
                      .showSnackBar(const SnackBar(
                    content: Text("Domanda inviata con successo")));
                  }

                },
                child: const Text('Salva'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textFormField(
      IconData icon, String labelText, String validator, TextEditingController _con) {
    return TextFormField(
      controller: _con,
      decoration: InputDecoration(
        icon: Icon(icon),
        labelText: labelText,
      ),
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validator;
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
         GlobalMaterialLocalizations.delegate
       ],
       supportedLocales: [
         const Locale('it')
       ],
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: _iconButton(
              context, Icons.arrow_back, 'Indietro', Profile(nome: nome, cognome: cognome, email: email, num_cellulare: num_cellulare, specializzazione: specializzazione ,cod_fiscale: cod_fiscale, token:token)),
          title: const Center(
            child: Text("Modifica dati"),
          ),
          actions: [
            _iconButton(context, Icons.logout, 'Logout', LoginPage()),
          ],
        ),
        body: Center(
                child : Column(
                  children: [
                    const Text(
                      "Nuova domanda",
                      style: TextStyle(fontSize: 30),
                    ),
                    _form(),
                  ],
                ),
        ),
      ),
    );
  }
}

