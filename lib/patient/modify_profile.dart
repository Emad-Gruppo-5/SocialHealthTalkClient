import 'package:flutter/material.dart';
import '../main.dart';

/// This is the main application widget.
class ModifyProfile extends StatelessWidget {
  const ModifyProfile({Key? key}) : super(key: key);

  Widget _iconButtonPush(BuildContext context, IconData icon, String tooltip,
      StatelessWidget statelessWidget) {
    return IconButton(
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: _iconButtonPop(context, Icons.arrow_back, 'Indietro'),
          title: const Center(
            child: Text("Modifica dati"),
          ),
          actions: [
            _iconButtonPush(context, Icons.logout, 'Logout', const MyApp()),
          ],
        ),
        body: const Center(child: MyModifyProfile()),
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
  List<bool> isChecked = [false, true, false];

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
            child: _textFormField(Icons.smartphone, "Numero di cellulare",
                "+39 331 313 3141", "Inserisci numero di cellulare"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _textFormField(Icons.email, "E-mail", "mariorossi@gmail.com",
                "Inserisci e-mail"),
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
          "Mario Rossi",
          style: TextStyle(fontSize: 50),
        ),
        _form(),
        const Text("\nTipologia chat"),
        _checkboxListTile("Solo testo", 0),
        _checkboxListTile("Videochiamata", 1),
        _checkboxListTile("Chiamata vocale", 2),
      ],
    );
  }
}
