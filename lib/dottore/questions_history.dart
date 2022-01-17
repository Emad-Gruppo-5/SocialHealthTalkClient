import 'package:flutter/material.dart';

class QuestionsHistory extends StatelessWidget {
  const QuestionsHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Storico domande'),
        ),
        body: const SingleChildScrollView(
          child: MyQuestionsHistory(),
        ),
      ),
    );
  }
}

class MyQuestionsHistory extends StatefulWidget {
  const MyQuestionsHistory({Key? key}) : super(key: key);

  @override
  State<MyQuestionsHistory> createState() => _MyQuestionsHistory();
}

class _MyQuestionsHistory extends State<MyQuestionsHistory> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ExpansionTile(
          leading: const Icon(Icons.question_answer),
          title: const Text('Domande aperte'),
          children: <Widget>[
            ListTile(
              title: const Text('Domanda 1'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('ATTENZIONE!'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: const <Widget>[
                              Text('Vuoi rimuovere la domanda?'),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Si'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            ListTile(
              title: const Text('Domanda 2'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('ATTENZIONE!'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: const <Widget>[
                              Text('Vuoi rimuovere la domanda?'),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Si'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            ListTile(
              title: const Text('Domanda 3'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('ATTENZIONE!'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: const <Widget>[
                              Text('Vuoi rimuovere la domanda?'),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Si'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        ExpansionTile(
          leading: const Icon(
            Icons.close,
            color: Colors.red,
          ),
          title: const Text('Domande chiuse'),
          children: <Widget>[
            ListTile(
              title: const Text('Domanda 1'),
              onTap: () {
                showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        title: const Text('Risposta'),
                        children: <Widget>[
                          SimpleDialogOption(
                            child: Column(
                              children: const [
                                Text('Risposta 1'),
                              ],
                            ),
                          ),
                        ],
                      );
                    });
              },
            ),
            ListTile(
              title: const Text('Domanda 2'),
              onTap: () {
                showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return const SimpleDialog(
                        title: Text('Risposta'),
                        children: <Widget>[
                          SimpleDialogOption(
                            child: Text('Risposta 2'),
                          ),
                        ],
                      );
                    });
              },
            ),
            ListTile(
              title: const Text('Domanda 3'),
              onTap: () {
                showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return const SimpleDialog(
                        title: Text('Risposta'),
                        children: <Widget>[
                          SimpleDialogOption(
                            child: Text('Risposta 3'),
                          ),
                        ],
                      );
                    });
              },
            ),
          ],
        ),
      ],
    );
  }
}
