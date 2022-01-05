// ignore_for_file: unnecessary_const

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'main_dottore.dart';
import 'profile.dart';


/// This is the main application widget.
class NewQuestion extends StatelessWidget {

  final String token;
  final String cod_fiscale;
  final String nome;
  final String cognome;
  final String email;
  final String num_cellulare;
  final String specializzazione;
  const NewQuestion({
    required this.cod_fiscale,
    required this.token,
    required this.nome,
    required this.cognome, 
    required this.email, 
    required this.num_cellulare,
    required this.specializzazione,
  } );

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
              context, Icons.arrow_back, 'Indietro', Profile(nome: nome, cognome: cognome, email: email, num_cellulare: num_cellulare, specializzazione: specializzazione ,cod_fiscale: cod_fiscale, token:token)),
          title: const Center(
            child: Text("Modifica dati"),
          ),
          actions: [
            _iconButton(context, Icons.logout, 'Logout', MainDottore(nome: nome, cognome: cognome, email: email, num_cellulare: num_cellulare, specializzazione: specializzazione ,cod_fiscale: cod_fiscale, token:token)),
          ],
        ),
        body: const Center(child: MyNewQuestion()),
      ),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyNewQuestion extends StatefulWidget {
  const MyNewQuestion({Key? key}) : super(key: key);

  @override
  State<MyNewQuestion> createState() => _MyNewQuestion();
}

// This is the stateless widget that the main application instantiates.
class _MyNewQuestion extends State<MyNewQuestion> {
  List<bool> isChecked = [false, true, false];

  String dropdownValue = 'Una volta';

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
            child: _textFormField(Icons.help_center_rounded, "Inserisci domanda",
                "Qual'è il tuo livello di pressione", "Inserisci domanda"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DateTimePicker(
              type: DateTimePickerType.dateTimeSeparate,
              dateMask: 'd MMM, yyyy',
              initialValue: DateTime.now().toString(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              icon: const Icon(Icons.event),
              dateLabelText: 'Date',
              timeLabelText: "Hour",
              selectableDayPredicate: (date) {
                return true;
              },
              onChanged: (val) => print(val),
              validator: (val) {
                print(val);
                return null;
              },
              onSaved: (val) => print(val),
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
                    setState(() {
                      dropdownValue = newValue!;
                    });
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
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid
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
    return Column(
      children: [
        const Text(
          "Nuova domanda",
          style: TextStyle(fontSize: 30),
        ),
        _form(),
      ],
    );
  }
}
