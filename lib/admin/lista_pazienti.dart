import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_emad/admin/adminHome.dart';
import 'package:test_emad/admin/crea_nuovo_paziente.dart';
import 'package:test_emad/admin/profilo_paziente_modifica.dart';
import 'package:http/http.dart' as http;

import 'profilo_paziente.dart';

class ListaPazienti extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lista pazienti'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminHome(),
                ),
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreaPaziente(),
                    ));
              },
            ),
          ],
        ),
        body: Center(child: ListSearch()));
  }
}

class ListSearch extends StatefulWidget {
  ListSearchState createState() => ListSearchState();
}

class ListSearchState extends State<ListSearch> {
  TextEditingController _textController = TextEditingController();

  @protected
  @mustCallSuper
  void initState() {
    getPatient();
  }

  static List<Map<String, String>> mainDataList = [];

  Future<String> getPatient() async {
    mainDataList.clear();
    var uri = Uri.parse('http://127.0.0.1:5000/lista_attori');
    print(uri);

    int role = 1;
    Map<String, int> message = {
      "role": role,
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

    var i = 0;
    while (i < json.decode(data.body).length) {
      mainDataList.add({
        'cognome': json.decode(data.body)[i]['cognome'],
        'nome': json.decode(data.body)[i]['nome'],
        'cod_fiscale': json.decode(data.body)[i]['cod_fiscale']
      });
      i++;
    }

    print(mainDataList);

    setState(() {
      newDataList = List.from(mainDataList);
    });

    return data.body;
  }

  // Copy Main List into New List.
  List<Map<String, String>> newDataList = List.from(mainDataList);

  onItemChanged(String value) {
    setState(() {
      // newDataList = mainDataList
      //     .where((map) => map[""].toLowerCase().contains(value.toLowerCase()))
      //     .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'Cerca',
                  ),
                  onChanged: onItemChanged,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(12.0),
              children: newDataList.map((data) {
                print("STAMPA: " + data["cognome"]!);
                return ListTile(
                    title: Text(data["cognome"]! + ' ' + data["nome"]!),
                    onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfiloPaziente(data["cod_fiscale"]!),
                            ),
                          ),
                        });
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
