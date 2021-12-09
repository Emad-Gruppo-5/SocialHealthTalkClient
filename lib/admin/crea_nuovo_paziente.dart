// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';

void main() => runApp(const CreaNuovoPaziente());

/// This is the main application widget.
class CreaNuovoPaziente extends StatelessWidget {
  const CreaNuovoPaziente({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: Icon(Icons.arrow_back_ios_sharp),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          title: const Center(
            child: Text("Crea nuovo paziente"),
          ),
        ),
        body: const SingleChildScrollView(child: CreateProfile()),
      ),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class CreateProfile extends StatefulWidget {
  const CreateProfile({Key? key}) : super(key: key);

  @override
  State<CreateProfile> createState() => _MyModifyProfile();
}

// This is the stateless widget that the main application instantiates.
class _MyModifyProfile extends State<CreateProfile> {
  List<bool> isChecked = [false, false, false];

  @override
  void initState() {

    super.initState();
  }

  Widget _textFormField(
      IconData icon, String labelText, String validator) {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(icon),
        labelText: labelText,
      ), // The validator receives the text that the user has entered.
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validator;
        }
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
            child: _textFormField(Icons.person_rounded, "Nome",
                "Inserisci Nome"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _textFormField(Icons.person_rounded, "Cognome",
                "Inserisci Cognome"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _textFormField(Icons.credit_card_outlined, "Codice Fiscale",
                "Inserisci Codice Fiscale"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _textFormField(Icons.smartphone, "Numero di cellulare",
                 "Inserisci numero di cellulare"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _textFormField(Icons.email, "E-mail",
                "Inserisci e-mail"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              "Tipologia Chat",
              style: TextStyle(fontSize: 15),
            ),
          ),
          _checkboxListTile("Solo testo", 0),
          _checkboxListTile("Videochiamata", 1),
          _checkboxListTile("Chiamata vocale", 2),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid
                  }
                },
                child: const Text('Crea'),
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
        _form(),
      ],
    );
  }
}
