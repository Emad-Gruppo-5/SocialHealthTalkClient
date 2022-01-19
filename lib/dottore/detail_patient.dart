import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_emad/dottore/new_question.dart';
import 'package:test_emad/dottore/questions_history.dart';
import 'package:test_emad/main.dart';
import 'main_dottore.dart';
import 'patient_list_item.dart';
import 'new_question.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
/// This is the main application widget.
class DetailPatient extends StatefulWidget {
  final String token;
  final String cod_fiscale;
  final String nome;
  final String cognome;
  final String email;
  final String num_cellulare;
  final String specializzazione;
  final String paz_cod_fiscale;

  DetailPatient({
    required this.cod_fiscale,
    required this.token,
    required this.nome,
    required this.cognome,
    required this.email,
    required this.num_cellulare,
    required this.specializzazione,
    required this.paz_cod_fiscale,
  });

  @override
  MyDetailPatient createState() => MyDetailPatient();
}

// This is the stateless widget that the main application instantiates.
class MyDetailPatient extends State<DetailPatient> {
  late String token;
  late String cod_fiscale;
  late String nome;
  late String cognome;
  late String email;
  late String num_cellulare;
  late String specializzazione;
  late String paz_cod_fiscale;

  @override
  void initState() {
    print("initState");
    cod_fiscale = widget.cod_fiscale;
    token = widget.token;
    nome = widget.nome;
    cognome = widget.cognome;
    email = widget.email;
    num_cellulare = widget.num_cellulare;
    specializzazione = widget.specializzazione;
    paz_cod_fiscale = widget.paz_cod_fiscale;
    super.initState();
  }

  Future<Map<String, dynamic>> getprofiledata() async {
    print("Inizio funzione");
    var uri = Uri.parse('http://192.168.1.55:5000/dati_profilo');
    print(uri);
    var message = {"role": 1, "cod_fiscale": paz_cod_fiscale};

    var body = json.encode(message);

    var dati_profilo = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: body);

    Map<String, dynamic> resp = {'paziente': json.decode(dati_profilo.body)};
    print(resp);
    return resp;
  }

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

  Widget _card(String title, IconData icon) {
    return SizedBox(
      height: 50,
      child: Card(
        child: ListTile(
          leading: Icon(icon),
          title:
              Text(title, style: const TextStyle(fontStyle: FontStyle.italic)),
        ),
      ),
    );
  }

  Widget _card2(String title, String desc) {
    return SizedBox(
      height: 50,
      child: Card(
        child: ListTile(
          leading:
              Text(desc, style: const TextStyle(fontWeight: FontWeight.bold)),
          title:
              Text(title, style: const TextStyle(fontStyle: FontStyle.italic)),
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
            _iconButton(context, Icons.logout, 'Logout', LoginPage()),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "btn1",
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => NewQuestion(
                          paz_cod_fiscale: paz_cod_fiscale,
                          nome: nome,
                          cognome: cognome,
                          email: email,
                          num_cellulare: num_cellulare,
                          specializzazione: specializzazione,
                          cod_fiscale: cod_fiscale,
                          token: token)),
                );
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.add),
            ),
            const SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              heroTag: "btn2",
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => QuestionsHistory(cod_fiscale_paziente: paz_cod_fiscale, cod_fiscale_dottore: cod_fiscale )),
                );
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.history),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: getprofiledata(),
                builder:
                    (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> data = Map.from(snapshot.data!);
                    var profilo =
                        json.decode(json.encode(data["paziente"]).toString());
                    print(profilo);
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            profilo["nome"] + ' ' + profilo["cognome"],
                            style: const TextStyle(fontSize: 40),
                          ),
                          _card(
                              profilo["cod_fiscale"] == null
                                  ? "null"
                                  : profilo["cod_fiscale"],
                              Icons.person),
                          _card(
                              profilo["num_cellulare"] == null
                                  ? "null"
                                  : profilo["num_cellulare"],
                              Icons.smartphone),
                          _card(
                              profilo["email"] == null
                                  ? "null"
                                  : profilo["email"],
                              Icons.email),
                          _card2(
                              profilo["eta"] == null ? "null" : profilo["eta"],
                              'Età:'),
                          _card2(
                              profilo["sesso"] == null
                                  ? "null"
                                  : profilo["sesso"],
                              'Sesso:'),
                          _card2(
                              profilo["titolo_studio"] == null
                                  ? "null"
                                  : profilo["titolo_studio"],
                              'Titolo di studio:'),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _textFormField(
                                Icons.notes,
                                "Note paziente",
                                profilo["note"] == null
                                    ? "null"
                                    : profilo["note"],
                                ""),
                          ),
                        ],
                      ),
                    );
                    // return Center(child: Text("NON FUNZIONA"));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
