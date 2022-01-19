import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_emad/admin/crea_nuovo_dottore.dart';
import 'package:test_emad/admin/profilo_dottore.dart';
import 'package:test_emad/admin/profilo_paziente_modifica.dart';
import 'package:http/http.dart' as http;
import 'profilo_paziente.dart';

class listaDottoriSeach extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_sharp),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Associa un Dottore'),
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios_sharp),
              onPressed: () {
                Navigator.pop(context);
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
    getActors();
  }

  static List<Map<String, String>> mainDataList = [];

  Future<void> getActors() async {
    mainDataList.clear();
    var uri = Uri.parse('http://192.168.1.55:5000/lista_attori');
    print(uri);

    int role = 2;
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
      if (json
              .decode(data.body)[i]['cod_fiscale']
              .toString()
              .compareTo('admin') !=
          0) {
        mainDataList.add({
          'cognome': json.decode(data.body)[i]['cognome'],
          'nome': json.decode(data.body)[i]['nome'],
          'cod_fiscale': json.decode(data.body)[i]['cod_fiscale']
        });
      }
      i++;
    }

    print(mainDataList);

    setState(() {
      newDataList = List.from(mainDataList);
    });
  }

  // Copy Main List into New List.
  List<Map<String, String>> newDataList = List.from(mainDataList);

  onItemChanged(String value) {
    setState(() {
      newDataList = List.from(mainDataList.where((element) =>
          element["nome"]!.toLowerCase().contains(value.toLowerCase()) ||
          element["cognome"]!.toLowerCase().contains(value.toLowerCase())));
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
                          Navigator.pop(context, data['cod_fiscale']),
                        });
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
