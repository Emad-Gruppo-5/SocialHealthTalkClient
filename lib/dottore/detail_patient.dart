import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_emad/dottore/new_question.dart';
import 'main_dottore.dart';
import 'patient_list_item.dart';
import 'new_question.dart';


/// This is the main application widget.
class DetailPatient extends StatelessWidget {
  
  final String token;
  final String cod_fiscale;


  DetailPatient({
    required this.cod_fiscale,
    required this.token
  } );
  

  Widget _iconButton(BuildContext context, IconData icon, String tooltip,
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

  @override
  Widget build(BuildContext context) {
    final patient = ModalRoute.of(context)!.settings.arguments as PatientListItem;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading:
              _iconButton(context, Icons.arrow_back, 'Indietro', MainDottore(cod_fiscale: cod_fiscale, token: token)),
          title: const Center(
            child: Text("Profilo"),
          ),     
          actions: [
            _iconButton(context, Icons.logout, 'Logout', MainDottore(cod_fiscale: cod_fiscale, token: token)),
          ],
        ),
        body: Center(
          child: MyDetailPatient(patient: patient),
        ),
        floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              fullscreenDialog: true,
              builder: (context) => NewQuestion(cod_fiscale: cod_fiscale, token: token)
            ),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        ),
       ),
    );
  }
}

// This is the stateless widget that the main application instantiates.
class MyDetailPatient extends StatelessWidget {
  final PatientListItem patient; 
  const MyDetailPatient({Key? key, required this.patient}) : super(key: key);
  
  Widget _card(String title, IconData icon) {
    return SizedBox(
      height: 50,
      child: Card(
        child: ListTile(
          leading: Icon(icon),
          title: Text(title, style: const TextStyle(fontStyle: FontStyle.italic)),
        ),
      ),
    );
  }
  Widget _card2(String title, String desc) {
    return SizedBox(
      height: 50,
      child: Card(
        child: ListTile(
          leading: Text(desc, style: const TextStyle(fontWeight: FontWeight.bold)),
          title: Text(title, style: const TextStyle(fontStyle: FontStyle.italic)),
        ),
      ),
    );
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
        if (value == null || value.isEmpty) {
          return validator;
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
         Text(
          patient.name!+ ' ' + patient.surname!,
          style: const TextStyle(fontSize: 40),
        ),
        _card(patient.codFiscale!, Icons.person),
        _card(patient.numCell!, Icons.smartphone),
        _card(patient.email!, Icons.email),
        _card2(patient.eta!.toString(), 'Età:'),
        _card2(patient.sesso!, 'Sesso:'),
        _card2(patient.titoloStudio!, 'Titolo di studio:'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _textFormField(Icons.notes, "Note paziente",
                  patient.note!, ""),
        ),

      ],
    );
  }
}
