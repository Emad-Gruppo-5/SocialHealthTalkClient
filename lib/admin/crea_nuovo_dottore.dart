// ignore_for_file: unnecessary_const

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

/// This is the main application widget.
class CreaNuovoDottore extends StatelessWidget {
  const CreaNuovoDottore({Key? key}) : super(key: key);

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
  TextEditingController _cont6 = TextEditingController();
  int val = -1;

  Future<String> creaDottoreServer() async {
    var uri = Uri.parse('http://127.0.0.1:5000/admin/crea_utente');
    print(uri);

    int role = 2;
    print(senddata);
    Map<String, String> message = {
      "role": role.toString(),
      "cod_fiscale": senddata["cod_fiscale"],
      "nome": senddata["nome"],
      "cognome": senddata["cognome"],
      "num_cellulare": senddata["num_cellulare"],
      "email": senddata["email"],
      "specializzazione": senddata["specializzazione"],
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

    if (data.statusCode == 200){
      creaDottoreServer();
      const snackBar = const SnackBar(
        content: Text('Utente inserito con successo'),
      );
      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      const snackBar = const SnackBar(
        content: Text('Utente non inserito'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return data.body;
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _textFormField(
                Icons.description_outlined, "specializzazione", "Inserisci specializzazione", "specializzazione", _cont6),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    creaDottoreServer();
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
          "Crea Dottore",
          style: TextStyle(fontSize: 50),
        ),
        _form(),
      ],
    );
  }
}
