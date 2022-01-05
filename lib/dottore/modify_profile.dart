// ignore_for_file: unnecessary_const

import 'dart:convert';

import 'package:flutter/material.dart';
import 'main_dottore.dart';
import 'profile.dart';
import 'package:http/http.dart' as http;


/// This is the main application widget.
class ModifyProfile extends StatelessWidget {
  final String token;
  final String cod_fiscale;

  ModifyProfile({
    required this.cod_fiscale,
    required this.token
  });

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: _iconButton(
              context, Icons.arrow_back, 'Indietro', Profile(cod_fiscale: cod_fiscale, token: token)),
          title: const Center(
            child: Text("Modifica dati"),
          ),
          actions: [
            _iconButton(context, Icons.logout, 'Logout', MainDottore(cod_fiscale: cod_fiscale, token: token,)),
          ],
        ),
        body: Center(child: MyModifyProfile(cod_fiscale: cod_fiscale, token:token)),
      ),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyModifyProfile extends StatefulWidget {
  final String token;
  final String cod_fiscale;

  MyModifyProfile({
    required this.token,
    required this.cod_fiscale
  });

  @override
  State<MyModifyProfile> createState() => _MyModifyProfile();
}

// This is the stateless widget that the main application instantiates.
class _MyModifyProfile extends State<MyModifyProfile> {

  late String token;
  late String cod_fiscale;

  var data;
  Map<String, dynamic> senddata = {};

  @override
  @protected
  @mustCallSuper
  void initState() {
    getDoctor();
    cod_fiscale = widget.cod_fiscale;
    token = widget.token;
    super.initState();
  }

  Future<String> getDoctor() async {
    
    print(cod_fiscale + "ukff");

    var uri = Uri.parse('http://127.0.0.1:5000/admin/dati_profilo');
    print(uri);

    Map<String, String> message = {
      "cod_fiscale": cod_fiscale.toString().lastChars(6),
      "role": 2.toString(),
    };
    var body = json.encode(message);
    print("\nBODY:: " + body);
    data = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: body);
    print('Response status: ${data.statusCode}');
    print('Response body: ' + data.body);

    setState(() {
      data = data;
    });

    return data.body;
  }

  Future<String> modificaUtente() async {
    var uri = Uri.parse('http://127.0.0.1:5000/admin/modifica_utente');
    print(uri);

    print(cod_fiscale + "ukff");

    int role = 2;
    print(senddata);
    Map<String, String> message = {
      "cod_fiscale": cod_fiscale,
      "role": role.toString(),
      "num_cellulare": senddata["Numero di cellulare"],
      "email": senddata["E-mail"],
    };
    var body = json.encode(message);
    print("\nBODY:: " + body);
    var data = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: body);
    print('Response status: ${data.statusCode}');
    print('Response body: ' + data.body);

    if (data.statusCode == 200) {
      final snackBar = SnackBar(
        content: const Text('Utente aggiornato con successo'),
      );
      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      const snackBar = const SnackBar(
        content: Text('Utente non aggiornato'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return data.body;
  }

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
        if (labelText == "Numero di cellulare") {
          int? val = int.tryParse(value!) ?? 0;
          if (value == null || value.isEmpty || val == 0) {
            return validator;
          }
        }
        if (value == null || value.isEmpty) {
          return validator;
        }
        senddata[labelText] = value;
        return null;
      },
    );
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
            child: _textFormField(
                Icons.smartphone,
                "Numero di cellulare",
                json.decode(data.body)['num_cellulare'],
                "Inserisci numero di cellulare"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _textFormField(Icons.email, "E-mail",
                json.decode(data.body)['email'], "Inserisci e-mail"),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    modificaUtente();
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

  @override
  Widget build(BuildContext context) {
    if (data != null) {
      return Column(
        children: [
          Text(
            json.decode(data.body)['cognome'] +
                " " +
                json.decode(data.body)['nome'],
            style: const TextStyle(fontSize: 50),
          ),
          _form(),
        ],
      );
    } else {
      return Text("loading...");
    }
  }
}