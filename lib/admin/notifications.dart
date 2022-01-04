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
    final Stream<QuerySnapshot> _patients = FirebaseFirestore.instance
        .collection('notifications')
        .orderBy('data', descending: true)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _patients,
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

            Icon leading;
            String subtitle = "";
            Row row;
            if (data['alert']) {
              leading = const Icon(Icons.warning);
              subtitle = "Risulta offline da più di 2 ore";
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
              leading = const Icon(Icons.edit);
              subtitle = "Vuole aggiornare il suo profilo";
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
                    leading: leading,
                    title: Text(data['nome'] + " " + data['cognome']),
                    subtitle: Text(subtitle),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('ATTENZIONE!'),
                          content:
                              const Text('Vuoi rimuovere questa notifica?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, 'Si');

                                FirebaseFirestore.instance
                                    .collection('notifications')
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
                      ),
                      tooltip: "Rimuovi",
                      color: Colors.red,
                    ),
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
