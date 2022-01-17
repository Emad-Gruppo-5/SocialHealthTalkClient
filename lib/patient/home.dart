import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:record/record.dart';
import '../main.dart';
import 'profile.dart';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart' as ap;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

/// This is the main application widget.
class Patient_Home extends StatelessWidget {
  final String token;
  final String cod_fiscale;
  final String nome;
  final String cognome;
  final String email;
  final String num_cellulare;
  final int tipologia_chat;

  Patient_Home({
    required this.cod_fiscale,
    required this.token,
    required this.nome,
    required this.cognome,
    required this.email,
    required this.num_cellulare,
    required this.tipologia_chat,
  });

  static const String _title = 'Social Health Talk';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(
          nome: nome,
          cognome: cognome,
          email: email,
          num_cellulare: num_cellulare,
          tipologia_chat: tipologia_chat,
          token: token,
          cod_fiscale: cod_fiscale),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  final String token;
  final String cod_fiscale;
  final String nome;
  final String cognome;
  final String email;
  final String num_cellulare;
  final int tipologia_chat;

  MyStatefulWidget({
    required this.cod_fiscale,
    required this.token,
    required this.nome,
    required this.cognome,
    required this.email,
    required this.num_cellulare,
    required this.tipologia_chat,
  });

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  // final String cod_fiscale;
  late String nome;
  late String cognome;
  late String email;
  late String num_cellulare;
  late int tipologia_chat;
  late String token;
  late String cod_fiscale;


  Duration online_duration = const Duration(seconds: 7);
  Duration alert_duration = const Duration(seconds: 20);
  late Timer timer;
  late Timer timer_alert;
  String timerText = "Start";
  late String ultimo_accesso;

  CollectionReference _notificationsReference = FirebaseFirestore.instance.collection('questions_to_answer');
  

  Widget _iconButtonPush(BuildContext context, IconData icon, String tooltip) {
    print("cod_fiscale: " + cod_fiscale);
    return IconButton(
      icon: Icon(icon),
      tooltip: tooltip,
      iconSize: 40,
      onPressed: () {
        timer.cancel();
        timer_alert.cancel();
        print("TAP UTENTE");
        FirebaseFirestore.instance
            .collection('patients')
            .doc(cod_fiscale)
            .update({'status': 'online'});

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Profile(
                  cod_fiscale: cod_fiscale,
                  nome: nome,
                  cognome: cognome,
                  email: email,
                  num_cellulare: num_cellulare,
                  tipologia_chat: tipologia_chat,
                  token: token)),
        );
      },
    );
  }

  Widget _iconButtonPop(BuildContext context, IconData icon, String tooltip) {
    return IconButton(
      icon: Icon(icon),
      tooltip: tooltip,
      iconSize: 40,
      onPressed: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyApp()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    timer = Timer(online_duration, handleTimeout);
    timer_alert = Timer(alert_duration, callback);

    FirebaseFirestore.instance
        .collection('patients')
        .doc(cod_fiscale)
        .update({'status': 'online'});
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
    print(dateFormat.format(DateTime.now()));
    return MaterialApp(
      
      home: GestureDetector(
        child: Scaffold(
          appBar: AppBar(
            leading: _iconButtonPush(
              context,
              Icons.account_circle,
              'Profilo',
            ),
            title: const Text("Promemoria giornalieri"),
            actions: [
              _iconButtonPop(context, Icons.logout, 'Logout'),
            ],
          ),
          body: StreamBuilder<QuerySnapshot>(
              stream: _notificationsReference
                      .where('cod_fiscale_paziente', isEqualTo: cod_fiscale)
                      .orderBy("data_domanda", descending: true)
                      .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                
                
                

                if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.docs.isEmpty) {
                    return Center( child: Image.asset('assets/images/promemoria.png'));
                }
                else
                // ignore: curly_braces_in_flow_control_structures
                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                    String subtitle = "";
                    Icon trailing;
                    print(data.toString());

                    return Center(
                      child: Card(
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
                              title: Text(data['testo_domanda']),
                              subtitle: Text("Inviata da: " + data["nome"] + " " + data["cognome"] + "\n" 
                                            + data["data_domanda"]),
                              onTap: () {
                                _notificationsReference
                                  .doc(document.id)
                                  .update({'letto': true})
                                  .then((value) => print("Notification Updated"))
                                  .catchError((error) =>
                                      print("Failed to update notifications: $error"));
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    String contentText = "Content of Dialog";
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return AlertDialog(
                                          title: Text(data['testo_domanda']),
                                          content: TextField(
                                            onChanged: (value) {},
                                            controller: _textFieldController,
                                            decoration: const InputDecoration(hintText: "Risposta testuale"),
                                          ),
                                          actions: <Widget>[
                                            IconButton(
                                              onPressed: () {
                                                if (_isRecording == false) {
                                                  setState(() {
                                                    _isRecording = true;
                                                  });
                                                  _start();
                                                } else {
                                                  setState(() {
                                                    _isRecording = false;
                                                  });
                                                  _stop(data);
                                                  document.reference.delete();
                                                  Navigator.pop(context, 'Cancel');
                                                }
                                                startOrStop();
                                              },
                                              icon: _icon(),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                if(_isRecording==false){
                                                  sendText(data);
                                                  document.reference.delete();
                                                  Navigator.pop(context, 'Cancel');}
                                                else {
                                                  const snackBar = SnackBar(
                                                    content: Text(
                                                        'Impossibile inviare testo mentre si sta registrando'),
                                                  );
                                                  // Find the ScaffoldMessenger in the widget tree
                                                  // and use it to show a SnackBar.
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                }

                                              },
                                              child: const Text('Invio'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                            // row,
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
        ),
        onTap: () {
          print("TAP UTENTE");
          FirebaseFirestore.instance
              .collection('patients')
              .doc(cod_fiscale)
              .update({'status': 'online'});
          timer.cancel();
          timer_alert.cancel();
          timer = Timer(online_duration, handleTimeout);
          timer_alert = Timer(alert_duration, callback);
        },
      ),
    );
  }

  Widget _card(String title, String subtitle) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }

  void handleTimeout() {
    print("TIMEOUT\nCod_fiscale: " + cod_fiscale);
    DateFormat dateFormat = DateFormat("yyyy/MM/dd HH:mm");
    ultimo_accesso = dateFormat.format(DateTime.now());
    FirebaseFirestore.instance
        .collection('patients')
        .doc(cod_fiscale)
        .update({'status': 'offline', 'ultimo_accesso': ultimo_accesso});
  }
  
  void callback() {
    print("ALERT\nCod_fiscale: " + cod_fiscale);
    // FirebaseFirestore.instance
    //     .collection('notifications')
    //     .add({
    //           'alert': true,
    //           'letto': false,
    //           'cod_fiscale': cod_fiscale,
    //           'nome': nome,
    //           'cognome': cognome,
    //           'ultimo_accesso': ultimo_accesso
    //     });
  }
  bool _isRecording = false;
  bool _isPaused = false;
  int _recordDuration = 0;
  final _audioRecorder = Record();
  Amplitude? _amplitude;
  var _textFieldController;

  @override
  void initState() {
    _isRecording = false;
    cod_fiscale = widget.cod_fiscale;
    token = widget.token;
    nome = widget.nome;
    cognome = widget.cognome;
    email = widget.email;
    num_cellulare = widget.num_cellulare;
    tipologia_chat = widget.tipologia_chat;
    super.initState();
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        if (kIsWeb) {
          String appDocPath = "/assets/record";
          await _audioRecorder.start(
            encoder: AudioEncoder.AAC, // by default
            bitRate: 128000,
          );
          bool isRecording = await _audioRecorder.isRecording();

          setState(() {
            _isRecording = isRecording;
          });
        } else {
          Directory? appDocDir = await getExternalStorageDirectory();
          String? appDocPath = appDocDir?.path;
          await _audioRecorder.start(
            path: '$appDocPath/myFile.mp3',
            encoder: AudioEncoder.AAC, // by default
            bitRate: 128000,
          );
          bool isRecording = await _audioRecorder.isRecording();

          setState(() {
            _isRecording = isRecording;
          });
        }
        final snackBar = SnackBar(
          content: const Text('Registrazione iniziata'),
        );
        // Find the ScaffoldMessenger in the widget tree
        // and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      print(e);
    }
  }

  late String path2;

  Future<void> _stop(Map data) async {
    final path = await _audioRecorder.stop();
    setState(() {
      _isRecording = false;
    });
    ap.AudioSource? audioSource;
    audioSource = ap.AudioSource.uri(Uri.parse(path!));
    print(path);
    path2 = path;
    final snackBar = SnackBar(
      content: const Text('Registrazione inviata con successo'),
    );
    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    sendFile(data);
  }

  _icon() {
    if (_isRecording == false) {
      return const Icon(Icons.mic_none_sharp, color: Colors.blue);
    } else {
      return const Icon(Icons.stop, color: Colors.blue);
    }
  }

  Stopwatch watch = Stopwatch();

  bool startStop = true;

  String elapsedTime = '';

  updateTime(Timer timer) {
    if (watch.isRunning) {
      setState(() {
        print("startstop Inside=$startStop");
        elapsedTime = transformMilliSeconds(watch.elapsedMilliseconds);
      });
    }
  }

  startOrStop() {
    if (startStop) {
      startWatch();
    } else {
      stopWatch();
    }
  }

  startWatch() {
    setState(() {
      startStop = false;
      watch.start();
      Timer timer = Timer.periodic(Duration(milliseconds: 100), updateTime);
    });
  }

  stopWatch() {
    setState(() {
      startStop = true;
      watch.stop();
      setTime();
    });
  }

  setTime() {
    var timeSoFar = watch.elapsedMilliseconds;
    setState(() {
      elapsedTime = transformMilliSeconds(timeSoFar);
    });
  }

  transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  sendFile(Map fireData) async {
    try {
      File file = File(path2);
      file.openRead();
      List<int> fileBytes = await file.readAsBytes();
      String base64String = base64Encode(fileBytes);
      final fileString = 'data:audio/mp3;base64,$base64String';
      var uri = Uri.parse('http://10.0.2.2:5000/aggiungi_domanda');

      Map<String, String> message = {
        "audio": fileString,
        "data_risposta": DateTime.now().toString(),
        "cod_fiscale_paziente": cod_fiscale,
        "data_domanda": fireData["data_domanda"],
        "testo_domanda": fireData["testo_domanda"],
        "cod_fiscale_dottore" : fireData["cod_fiscale_dottore"],
        "testo_risposta": " ",
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

    } catch (e) {
      print(e.toString());

      return null;
    }

  }

  Future<void> sendText(Map fireData) async {
    var uri = Uri.parse('http://10.0.2.2:5000/aggiungi_domanda');
    print(uri);
    int role = 1;

    Map<String, dynamic> message = {
      "testo_risposta": _textFieldController,
      "data_risposta": DateTime.now().toString(),
      "cod_fiscale_paziente": cod_fiscale,
      "data_domanda": fireData["data_domanda"],
      "testo_domanda": fireData["testo_domanda"],
      "cod_fiscale_dottore" : fireData["cod_fiscale_dottore"],
      "audio" : " "
    };
    var body = json.encode(message);
    var data;
    print("\nBODY:: " + body);

    data = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: body);

    if (data.statusCode == 200) {
      final snackBar = SnackBar(
        content: const Text('Domanda inserita con successo'),
      );
      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      print("ERRORE LATO POSTGRESQL: err: ");
      const snackBar = const SnackBar(
        content: Text('Domanda non inserita'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}