// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';

void main() => runApp(const CreaNuovoDottore());

/// This is the main application widget.
class CreaNuovoDottore extends StatelessWidget {
  const CreaNuovoDottore({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_sharp),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          title: const Center(
            child: Text("Crea nuovo dottore"),
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
            child: _textFormField(Icons.description, "Specializzazione",
                "Inserisci specializzazione"),
          ),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _form(),
      ],
    );
  }
}
