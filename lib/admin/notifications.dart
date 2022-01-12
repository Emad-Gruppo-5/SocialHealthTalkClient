import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

class MyNotifications extends StatelessWidget {
  List<bool> doctors = [true, false, true], familiars = [true, false, true];

  Future _showAlertDialog(BuildContext context) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text('Seleziona l\'azione da svolgere'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    const Text("Dottori"),
                    CheckboxListTile(
                        value: doctors[0],
                        onChanged: (value) => setState(() {
                              doctors[0] = value!;
                            }),
                        title: const Text("Dottore 1")),
                    CheckboxListTile(
                        value: doctors[1],
                        onChanged: (value) => setState(() {
                              doctors[1] = value!;
                            }),
                        title: const Text("Dottore 2")),
                    CheckboxListTile(
                        value: doctors[2],
                        onChanged: (value) => setState(() {
                              doctors[2] = value!;
                            }),
                        title: const Text("Dottore 3")),
                    const SizedBox(height: 10),
                    const Text("Familiari"),
                    CheckboxListTile(
                        value: familiars[0],
                        onChanged: (value) => setState(() {
                              familiars[0] = value!;
                            }),
                        title: const Text("Familiare 1")),
                    CheckboxListTile(
                        value: familiars[1],
                        onChanged: (value) => setState(() {
                              familiars[1] = value!;
                            }),
                        title: const Text("Familiare 2")),
                    CheckboxListTile(
                        value: familiars[2],
                        onChanged: (value) => setState(() {
                              familiars[2] = value!;
                            }),
                        title: const Text("Familiare 3")),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
                          .showSnackBar(const SnackBar(
                              content: Text('Email/SMS inviati')));
                    },
                    child: const Text("Invia")),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Non inviare"))
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
                        onTap: () => _showAlertDialog(context),
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
