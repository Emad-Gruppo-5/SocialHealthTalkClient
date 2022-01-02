// ignore_for_file: unnecessary_const

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

void main() => runApp(const CreaPaziente());

/// This is the main application widget.
class CreaPaziente extends StatelessWidget {
  const CreaPaziente({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_sharp),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Center(
            child: Text("Modifica dati"),
          ),
        ),
        body: const SingleChildScrollView(child: MyModifyProfile()),
      ),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyModifyProfile extends StatefulWidget {
  const MyModifyProfile({Key? key}) : super(key: key);

  @override
  State<MyModifyProfile> createState() => _MyModifyProfile();
}

// This is the stateless widget that the main application instantiates.
class _MyModifyProfile extends State<MyModifyProfile> {
  List<bool> isChecked = [false, false, false];
  Map<String, dynamic> senddata = {};
  TextEditingController _cont1 = TextEditingController();
  TextEditingController _cont2 = TextEditingController();
  TextEditingController _cont3 = TextEditingController();
  TextEditingController _cont4 = TextEditingController();
  TextEditingController _cont5 = TextEditingController();
  int val = -1;

  Future<void> creaPazienteServer() async {
    var uri = Uri.parse('http://127.0.0.1:5000/crea_utente');
    print(uri);
    CollectionReference patients = FirebaseFirestore.instance.collection('patients');
    int role = 1;
    print(senddata);

    Map<String, dynamic> message = {
      "role": role,
      "cod_fiscale": senddata["cod_fiscale"],
      "nome": senddata["nome"],
      "cognome": senddata["cognome"],
      "num_cellulare": senddata["num_cellulare"],
      "email": senddata["email"],
      "tipologia_chat": val.toString(),
    };
    var body = json.encode(message);
    var data;
    print("\nBODY:: " + body);


    data = await http.post(uri,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body: body);

    if(data.statusCode == 200){
      patients.doc(message['cod_fiscale']).set({
          'nome': message['nome'],
          'cognome': message['cognome'],
          'status': 'offline',
          'ultimo_accesso': 'Nessun accesso'
        })
        .catchError((error) => {
          print("ERRORE LATO FIRESTORE: err: " + error)
        });

          // creaPazienteServer();
          final snackBar = SnackBar(
            content: const Text('Utente inserito con successo'),
          );
          // Find the ScaffoldMessenger in the widget tree
          // and use it to show a SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
         
    }else{
      print("ERRORE LATO POSTGRESQL: err: ");
      const snackBar = const SnackBar(
            content: Text('Utente non inserito'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    
  }

  Widget _textFormField(
      IconData icon, String labelText, String validator, String i, TextEditingController _cont) {
    return TextFormField(
      controller: _cont,
      decoration: InputDecoration(
        icon: Icon(icon),
        labelText: labelText,
      ),
      // The validator receives the text that the user has entered.
      validator: (value) {
        if(labelText == "Numero di cellulare"){
          int? val = int.tryParse(value!) ?? 0;
          if (value == null || value.isEmpty || val==0) {
            return validator;
          }
        }
        if (value == null || value.isEmpty) {
          return validator;
        }
        senddata[i] = value;
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
            child: _textFormField(Icons.credit_card, "Codice fiscale",
                "Inserisci codice fiscale", "cod_fiscale", _cont1),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                _textFormField(Icons.people, "Nome", "Inserisci nome", "nome", _cont2),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _textFormField(
                Icons.people, "Cognome", "Inserisci cognome", "cognome", _cont3),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _textFormField(Icons.smartphone, "Numero di cellulare",
                "Inserisci numero di cellulare (deve contenere solo numeri)", "num_cellulare", _cont4),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _textFormField(
                Icons.email, "E-mail", "Inserisci e-mail", "email", _cont5),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Tipologia Chat",
              style: TextStyle(fontSize: 15),
            ),
          ),
          ListTile(
            title: const Text("Solo testo"),
            leading: Radio(
              value: 0,
              groupValue: val,
              onChanged: (value) {
                setState(() {
                  val = 0;
                });
              },
              activeColor: Colors.blue,
            ),
          ),
          ListTile(
            title: const Text("Videochiamata"),
            leading: Radio(
              value: 1,
              groupValue: val,
              onChanged: (value) {
                setState(() {
                  val = 1;
                });
              },
              activeColor: Colors.blue,
            ),
          ),
          ListTile(
            title: const Text("Chiamata vocale"),
            leading: Radio(
              value: 2,
              groupValue: val,
              onChanged: (value) {
                setState(() {
                  val = 2;
                });
              },
              activeColor: Colors.blue,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate() && val>=0) {
                    creaPazienteServer();
                  } else {
                    final snackBar = SnackBar(
                      content: const Text('Seleziona tipologia di chat'),
                    );

                    // Find the ScaffoldMessenger in the widget tree
                    // and use it to show a SnackBar.
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

  Widget _checkboxListTile(String text, int index) {
    return CheckboxListTile(
      title: Text(text),
      contentPadding: const EdgeInsets.symmetric(horizontal: 100),
      value: isChecked[index],
      onChanged: (bool? value) {
        setState(() {
          isChecked[index] = value!;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Crea Paziente",
          style: TextStyle(fontSize: 50),
        ),
        _form(),
      ],
    );
  }
}