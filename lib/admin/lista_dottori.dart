import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_emad/admin/crea_nuovo_dottore.dart';
import 'package:test_emad/admin/profilo_dottore.dart';
import 'package:test_emad/admin/profilo_paziente_modifica.dart';
import 'package:http/http.dart' as http;
import 'profilo_paziente.dart';

class ListaDottori extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              title: Text('Lista Dottori'),
              actions: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    MaterialPageRoute(
                      builder: (context) => CreaNuovoDottore(),
                    );
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

  Future<String> getActors() async {
    mainDataList.clear();
    var uri = Uri.parse('http://127.0.0.1:5000/lista_attori');
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
      if(json.decode(data.body)[i]['cognome'].toString().compareTo('admin') != 0)
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
  List<String> newDataList = List.from(mainDataList);

  onItemChanged(String value) {
    setState(() {
      newDataList = List.from(mainDataList
                    .where((element) => element["nome"]!
                                        .toLowerCase()
                                        .contains(value.toLowerCase()) 
                                        ||
                                        element["cognome"]!
                                        .toLowerCase()
                                        .contains(value.toLowerCase()) ));
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
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new TextField(
                  controller: _textController,
                  decoration: InputDecoration(
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
                return ListTile(
                  title: Text(data),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfiloDottore(),
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
