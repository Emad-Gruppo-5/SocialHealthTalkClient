import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sht/admin/profilo_dottore_modifica.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session/flutter_session.dart';

void main() => runApp(const ProfiloDottore());

/// This is the main application widget.
class ProfiloDottore extends StatelessWidget {
  const ProfiloDottore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_sharp),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Center(
            child: Text("Profilo"),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfiloDottoreModifica(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfiloDottoreModifica(),
                  ),
                );
              },
            ),
          ],
        ),

        body: const SingleChildScrollView(
          child: MyProf(),
        ),
      ),
    );
  }
}


class MyProf extends StatefulWidget {
  const MyProf({Key? key}) : super(key: key);

  MyProfile createState() => MyProfile();
}

// This is the stateless widget that the main application instantiates.
class MyProfile extends State<MyProf> {

  var data;
  var patient;
  Map<String, dynamic> p = <String, dynamic>{};

  @override
  @protected
  @mustCallSuper
  void initState() {
    getDoctor();
    getPatient();
  }

  Future<String> getDoctor() async {

    String data2 = await FlutterSession().get("cf");

    print(data2);
    var uri = Uri.parse('http://127.0.0.1:5000/admin/dati_profilo');
    print(uri);

    Map<String, String> message = {
      "cod_fiscale": data2.toString().lastChars(6),
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

  Future<String> getPatient() async {

    String data2 = await FlutterSession().get("cf");

    var uri = Uri.parse('http://127.0.0.1:5000/admin/attori_associati');
    print(uri);

    Map<String, String> message = {
      "cod_fiscale": data2.toString().lastChars(6),
      "role": 2.toString(),
    };
    var body = json.encode(message);
    print("\nBODY:: " + body);
    patient = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: body);
    print('Response status: ${patient.statusCode}');
    print('Response body: ' + patient.body);

    setState(() {
      patient=patient;
    });
    print(2);

    return patient.body;
  }

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
        Text(
          json.decode(data.body)['cognome'] + " " + json.decode(data.body)['nome'],
          style: TextStyle(fontSize: 30),
        ),
        _card(json.decode(data.body)['cod_fiscale'], Icons.person),
        _card(json.decode(data.body)['num_cellulare'], Icons.smartphone),
        _card(json.decode(data.body)['email'], Icons.email),
        _card("Cardiologo", Icons.description),
        const Text(
          "Paziente associati",
          style: TextStyle(fontSize: 20),
        ),
        _card(json.decode(patient.body)[0], Icons.medical_services_outlined),
      ],
    );
  }
}

class ScreenArguments {
final String data;

ScreenArguments(this.data);
}

extension E on String {
  String lastChars(int n) => substring(length - n);
}