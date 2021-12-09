import 'package:flutter/material.dart';

class StatoAttivitaPazienti extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stato attività pazienti',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: new AppBar(
          title: Text('Stato attività pazienti'),
          leading: new IconButton(
            icon: Icon(Icons.arrow_back_ios_sharp),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ),
        body: BodyLayout(),
      ),
    );
  }
}

class BodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }
}

Widget _myListView(BuildContext context) {
  return ListView(
    children: <Widget>[
      ListTile(
        title: Text('Paziente 1'),
        subtitle: Text('offline da x minuti'),
        trailing: new Icon(Icons.circle, color: Colors.redAccent,),
      ),
      ListTile(
        title: Text('Paziente 2'),
        subtitle: Text('offline da x minuti'),
        trailing: new Icon(Icons.circle, color: Colors.redAccent,),
      ),
      ListTile(
        title: Text('Paziente 3'),
        subtitle: Text('offline da x minuti'),
        trailing: new Icon(Icons.circle, color: Colors.redAccent,),
      ),

    ],
  );
}