import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Notifications extends StatelessWidget {
  Notifications({Key? key}) : super(key: key);

  static const String _title = 'Notifiche';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
            tooltip: "Indietro",
          ),
          title: const Text(_title),
          actions: [
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: () => showDialog<String>(
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
                        }).catchError((error) => print(
                                "Failed to delete notifications: $error"));
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
        body: const MyNotifications(),
      ),
    );
  }
}

class MyNotifications extends StatelessWidget {
  const MyNotifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _notificationsStream = FirebaseFirestore
        .instance
        .collection('notifications')
        .orderBy('data', descending: true)
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
          return const Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;

            String subtitle = "";
            Icon trailing;
            Row row;
            if (data['alert']) {
              subtitle = "Risulta offline da più di 2 ore";
              trailing = const Icon(Icons.warning, color: Colors.red);
              row = Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text('Dottori'),
                    onPressed: () {/* ... */},
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    child: const Text('Familiari'),
                    onPressed: () {/* ... */},
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    child: const Text('Volontari'),
                    onPressed: () {/* ... */},
                  ),
                  const SizedBox(width: 8),
                ],
              );
            } else {
              subtitle = "Vuole aggiornare il suo profilo";
              trailing = const Icon(Icons.edit);
              row = Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text('Aggiorna'),
                    onPressed: () {/* ... */},
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    child: const Text('Non aggiornare'),
                    onPressed: () {/* ... */},
                  ),
                  const SizedBox(width: 8),
                ],
              );
            }

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
                          visible: data['letto'],
                        ),
                      ],
                    ),
                    title: Text(data['nome'] + " " + data['cognome']),
                    subtitle: Text(subtitle),
                    trailing: trailing,
                    /*onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('ATTENZIONE!'),
                          content:
                              const Text('Vuoi rimuovere questa notifica?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, 'Si');

                                _notificationsReference
                                    .doc(document.id)
                                    .delete()
                                    .then(
                                      (value) => print("Notification Deleted"),
                                    )
                                    .catchError(
                                      (error) => print(
                                          "Failed to delete notification: $error"),
                                    );
                              },
                              child: const Text('Si'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'No'),
                              child: const Text('No'),
                            ),
                          ],
                        ),
                      ),*/
                    onTap: () => _notificationsReference
                        .doc(document.id)
                        .update({'letto': !data['letto']})
                        .then((value) => print("Notification Updated"))
                        .catchError((error) =>
                            print("Failed to update notifications: $error")),
                  ),
                  row,
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
