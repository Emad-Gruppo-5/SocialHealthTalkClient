// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:sht/admin/crea_nuovo_dottore.dart';
import 'package:sht/admin/profilo_dottore.dart';
import 'package:sht/admin/profilo_paziente_modifica.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_isolate/flutter_isolate.dart';

import 'profilo_paziente.dart';

class ListaDottori extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Lista Dottori'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_sharp),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreaNuovoDottore(),
                        ));
                  },
                ),
              ],
            ),
            body: const Center(child: ListSearch())));
  }
}

class ListSearch extends StatefulWidget {
  const ListSearch({Key? key}) : super(key: key);

  ListSearchState createState() => ListSearchState();
}

class ListSearchState extends State<ListSearch> {

  @protected
  @mustCallSuper
  void initState() {
    getDoctor();
  }

  static List<String> mainDataList = [];

  Future<void> saveData(String data) async {

    var session = FlutterSession();
    await session.set('cf', data.toString());
  }

  Future<String> getDoctor() async {

    mainDataList.clear();
    var uri = Uri.parse('http://127.0.0.1:5000/admin/lista_attori');
    print(uri);

    int role = 2;
    Map<String, String> message = {
      "role": role.toString(),
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
      mainDataList.add(json.decode(data.body)[i]['cognome'] + ' ' + json.decode(data.body)[i]['nome'] + ' ' + json.decode(data.body)[i]['cod_fiscale']);
      i=i+1;
    }

    print(mainDataList);
    print("fafafa");

    setState(() {
      newDataList = List.from(mainDataList);
    });

    return data.body;
  }

  TextEditingController _textController = TextEditingController();

  // Copy Main List into New List.
  List<String> newDataList = List.from(mainDataList);


  onItemChanged(String value) {
    print(mainDataList);
    setState(() {
      newDataList = mainDataList
          .where((string) => string.toLowerCase().contains(value.toLowerCase()))
          .toList();
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
              padding: const EdgeInsets.all(12.0),
              children: newDataList.map((data) {
                return ListTile(
                  title: Text(data),
                  onTap: () {
                    saveData(data);
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfiloDottore(),
                    ),
                  );}
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}