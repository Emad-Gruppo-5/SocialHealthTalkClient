import 'dart:convert';
import 'package:audioplayer/audioplayer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_emad/costanti.dart';
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class Notifications extends StatelessWidget {
  const Notifications({Key? key}) : super(key: key);

  static const String _title = 'Notifiche';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
            tooltip: "Indietro",
          ),
          title: const Text(_title),
          actions: [
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: () => showDialog<void>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('ATTENZIONE!'),
                  content: const Text('Vuoi rimuovere tutte le notifiche?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, 'Si');

                        FirebaseFirestore.instance
                            .collection('notifications')
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.forEach((doc) {
                            doc.reference.delete();
                          });

                          print("Notifications Deleted");

                          ScaffoldMessenger.of(_scaffoldKey.currentContext!)
                              .showSnackBar(const SnackBar(
                                  content: Text('Notifiche rimosse')));
                        }).catchError((error) {
                          print("Failed to delete notifications: $error");
                          ScaffoldMessenger.of(_scaffoldKey.currentContext!)
                              .showSnackBar(const SnackBar(
                                  content: Text(
                                      'Impossibile rimuovere le notifiche')));
                        });
                      },
                      child: const Text('Si'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'No'),
                      child: const Text('No'),
                    ),
                  ],
                ),
              ),
              tooltip: "Rimuovi tutto",
            ),
          ],
        ),
        body: SingleChildScrollView(child: MyNotifications()),
      ),
    );
  }
}

Future<void> sendEmail(List<Map<String, String>> addresses) async {
  var uri = Uri.parse('http://' + urlServer + ':5000/alert');
  print(uri);

  print(addresses);
  await http.post(uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: json.encode(addresses));
}

Future<String> getActors(String cod_fiscale) async {
  List<Map<String, dynamic>> mainDataList = [];
  var uri = Uri.parse('http://' + urlServer + ':5000/attori_associati');
  print(uri);

  Map<String, dynamic> message = {"role": 1, "cod_fiscale": cod_fiscale};
  var body = json.encode(message);
  print("\nBODY:: " + body);
  var data = await http.post(uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: body);
  print('Response status: ${data.statusCode}');
  print('Response body: ' + data.body);
  return data.body;
}

class MyNotifications extends StatelessWidget {
  List<Map<String, dynamic>> actors = [];

  Future _showAlertDialog(BuildContext context) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text('Invia l\'alert a:'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: actors.map((data) {
                    return CheckboxListTile(
                      value: data["value"],
                      onChanged: (value) => setState(() {
                        data["value"] = value;
                      }),
                      title: Text(data["categoria"] +
                          ": " +
                          data["nome"] +
                          " " +
                          data["cognome"]),
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => {
                          actors.clear(),
                          Navigator.pop(context),
                        },
                    child: const Text("Non inviare")),
                TextButton(
                    onPressed: () {
                      List<Map<String, String>> addresses = [];

                      for (int i = 0; i < actors.length; i++)
                        if (actors[i]["value"])
                          addresses.add({"email": actors[i]["email"]});

                      print(addresses);
                      // RACCOLTA EMAIL e poi INVIO EMAILS
                      sendEmail(addresses).then((val) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(_scaffoldKey.currentContext!)
                            .showSnackBar(const SnackBar(
                                content: Text('Email/SMS inviati')));
                        actors.clear();
                      });
                    },
                    child: const Text("Invia")),
              ],
            );
          });
        });
  }

  Widget _alerts() {
    final Stream<QuerySnapshot> _notificationsStream = FirebaseFirestore
        .instance
        .collection('notifications')
        .where('alert', isEqualTo: true)
        .snapshots();
    CollectionReference _notificationsReference =
        FirebaseFirestore.instance.collection('notifications');

    return StreamBuilder<QuerySnapshot>(
        stream: _notificationsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Text("Nessuna notifica");
          } else {
            return ListView(
              shrinkWrap: true,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Visibility(
                              child: const Icon(Icons.circle,
                                  color: Colors.blue, size: 15),
                              visible: !data['letto'],
                            ),
                          ],
                        ),
                        title: Text(data['nome'] + " " + data['cognome']),
                        subtitle:
                            Text("Ultimo accesso: " + data['ultimo_accesso']),
                        trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('ATTENZIONE!'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: const <Widget>[
                                          Text('Vuoi rimuovere l\'alert?'),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Si'),
                                        onPressed: () {
                                          _notificationsReference
                                              .doc(document.id)
                                              .delete();
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(
                                                  _scaffoldKey.currentContext!)
                                              .showSnackBar(const SnackBar(
                                                  content:
                                                      Text('Alert rimossa')));
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('No'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                }),
                            color: Colors.red),
                        onTap: () => {
                          getActors(data['cod_fiscale']).then((value) {
                            for (int i = 0;
                                i < json.decode(value)["dottori"].length;
                                i++) {
                              actors.add({
                                'cognome': json.decode(value)["dottori"][i]
                                    ['cognome'],
                                'nome': json.decode(value)["dottori"][i]
                                    ['nome'],
                                'cod_fiscale': json.decode(value)["dottori"][i]
                                    ['cod_fiscale'],
                                'email': json.decode(value)["dottori"][i]
                                    ['email'],
                                'num_cellulare': json.decode(value)["dottori"]
                                    [i]['num_cellulare'],
                                'value': false,
                                'categoria': 'D'
                              });
                            }

                            for (int i = 0;
                                i < json.decode(value)["familiari"].length;
                                i++) {
                              actors.add({
                                'cognome': json.decode(value)["familiari"][i]
                                    ['cognome'],
                                'nome': json.decode(value)["familiari"][i]
                                    ['nome'],
                                'cod_fiscale': json.decode(value)["familiari"]
                                    [i]['cod_fiscale'],
                                'email': json.decode(value)["familiari"][i]
                                    ['email'],
                                'num_cellulare': json.decode(value)["familiari"]
                                    [i]['num_cellulare'],
                                'value': false,
                                'categoria': 'F'
                              });
                            }
                            _showAlertDialog(context);
                          })
                        },
                        onLongPress: () => _notificationsReference
                            .doc(document.id)
                            .update({'letto': !data['letto']})
                            .then((value) => print("Notification Updated"))
                            .catchError((error) => print(
                                "Failed to update notifications: $error")),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }
        });
  }

  Widget _updates() {
    final Stream<QuerySnapshot> _notificationsStream = FirebaseFirestore
        .instance
        .collection('notifications')
        .where('alert', isEqualTo: false)
        .snapshots();
    CollectionReference _notificationsReference =
        FirebaseFirestore.instance.collection('notifications');

    return StreamBuilder<QuerySnapshot>(
        stream: _notificationsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Text("Nessuna notifica");
          } else {
            return ListView(
              shrinkWrap: true,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Visibility(
                              child: const Icon(Icons.circle,
                                  color: Colors.blue, size: 15),
                              visible: !data['letto'],
                            ),
                          ],
                        ),
                        title: Text(data['nome'] + " " + data['cognome']),
                        subtitle: const Text("Vuole aggiornare il suo profilo"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('ATTENZIONE!'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: const <Widget>[
                                      Text(
                                          'Vuoi rimuovere la notifica per la modifica del profilo?'),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Si'),
                                    onPressed: () {
                                      _notificationsReference
                                          .doc(document.id)
                                          .delete();
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(
                                              _scaffoldKey.currentContext!)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Notifica per la modifica del profilo rimossa')));
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('No'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                          color: Colors.red,
                        ),
                        onTap: () => showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return SimpleDialog(
                                title: const Text(
                                    'Selezione l\'azione da svolgere:'),
                                children: <Widget>[
                                  SimpleDialogOption(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                              _scaffoldKey.currentContext!)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text('Dati aggiornati')));
                                    },
                                    child: const Text('Aggiorna i dati'),
                                  ),
                                  SimpleDialogOption(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                              _scaffoldKey.currentContext!)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text('Dati non aggiornati')));
                                    },
                                    child: const Text('Non aggiornare i dati'),
                                  ),
                                ],
                              );
                            }),
                        onLongPress: () => _notificationsReference
                            .doc(document.id)
                            .update({'letto': !data['letto']})
                            .then((value) => print("Notification Read"))
                            .catchError((error) =>
                                print("Failed to read notifications: $error")),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }
        });
  }

  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ExpansionTile(
          leading: const Icon(Icons.warning, color: Colors.red),
          title: const Text('Alerts'),
          children: <Widget>[
            _alerts(),
          ],
        ),
        ExpansionTile(
          leading: const Icon(Icons.edit, color: Colors.yellow),
          title: const Text('Modifica profilo'),
          children: <Widget>[
            _updates(),
          ],
        ),
      ],
    );
  }
}
