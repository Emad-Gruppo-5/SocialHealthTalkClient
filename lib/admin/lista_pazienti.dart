import 'package:flutter/material.dart';
import 'package:sht/admin/crea_nuovo_paziente.dart';
import 'package:sht/admin/profilo_paziente_modifica.dart';

import 'profilo_paziente.dart';

class ListaPazienti extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              title: Text('Lista pazienti'),
              leading: new IconButton(
                icon: Icon(Icons.arrow_back_ios_sharp),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                new IconButton(
                  icon: Icon(Icons.add, color: Colors.white, size: 36),
                  onPressed: () {
                    MaterialPageRoute(
                      builder: (context) => CreaNuovoPaziente(),
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

  static List<String> mainDataList = [
    "Paziente 1",
    "Paziente 2",
    "Paziente 3",
    "Paziente 4",
    "Paziente 5",
    "Paziente 6",
    "Paziente 7",
    "Paziente 8",
  ];

  // Copy Main List into New List.
  List<String> newDataList = List.from(mainDataList);

  onItemChanged(String value) {
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
                      builder: (context) => ProfiloPaziente(),
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
