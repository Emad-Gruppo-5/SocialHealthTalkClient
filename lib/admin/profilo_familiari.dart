import 'package:flutter/material.dart';
import 'package:sht/admin/profilo_dottore_modifica.dart';
import 'package:sht/admin/profilo_familiari_modifica.dart';
import 'package:sht/admin/profilo_paziente_modifica.dart';

void main() => runApp(const ProfiloFamiliare());

/// This is the main application widget.
class ProfiloFamiliare extends StatelessWidget {
  const ProfiloFamiliare({Key? key}) : super(key: key);

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
            child: Text("Profilo"),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfiloFamiliareModifica(),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfiloFamiliareModifica(),
                  ),
                );
              },
            ),
          ],
        ),
        body: const SingleChildScrollView(
          child: MyProfile(),
        ),
      ),
    );
  }
}

// This is the stateless widget that the main application instantiates.
class MyProfile extends StatelessWidget {
  const MyProfile({Key? key}) : super(key: key);

  Widget _card(String title, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
      ),
    );
  }

  Widget _checkboxListTile(String text, bool value) {
    return CheckboxListTile(
      title: Text(text),
      contentPadding: const EdgeInsets.symmetric(horizontal: 100),
      value: value,
      onChanged: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Mario Rossi",
          style: TextStyle(fontSize: 30),
        ),
        _card("SMLLNEXIXISI", Icons.person),
        _card("+39 331 313 3141", Icons.smartphone),
        _card("mariorossi@gmail.com", Icons.email),
        const Text(
          "Paziente associati",
          style: TextStyle(fontSize: 20),
        ),
        _card("Paziente 1", Icons.medical_services_outlined),
      ],
    );
  }
}
