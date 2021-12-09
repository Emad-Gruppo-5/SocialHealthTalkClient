import 'package:flutter/material.dart';
import 'package:sht/admin/crea_nuovo_dottore.dart';
import 'package:sht/admin/profilo_dottore.dart';
import 'package:sht/admin/profilo_paziente_modifica.dart';

import 'profilo_paziente.dart';

class ListaDottori extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: Text('Lista Dottori'),
              leading: new IconButton(
                icon: Icon(Icons.arrow_back_ios_sharp),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                new IconButton(
                  icon: Icon(Icons.add, color: Colors.white, size: 40),
                  onPressed: () {
                    MaterialPageRoute(
                      builder: (context) => CreaNuovoDottore(),
                    );
                  },
                ),
              ],
            ),
            body: Center(child: ListSearch())));
  }
}

class ListSearch extends StatefulWidget {
  ListSearchState createState() => ListSearchState();
}

class ListSearchState extends State<ListSearch> {
  TextEditingController _textController = TextEditingController();

  static List<String> mainDataList = [
    "Dottore 1",
    "Dottore 2",
    "Dottore 3",
    "Dottore 4",
    "Dottore 5",
    "Dottore 6",
    "Dottore 7",
    "Dottore 8",
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
