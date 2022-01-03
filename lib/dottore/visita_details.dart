import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;


void main() => runApp(TimePickerVisita(date: "2121"));

class TimePickerVisita extends StatelessWidget {
  final String date;

  const TimePickerVisita({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seleziona orario',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(date: date),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String date;

  const MyHomePage({Key? key, required this.date}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState(date: date);
}

class _MyHomePageState extends State<MyHomePage> {
  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);
  final String date;

  _MyHomePageState({required this.date});

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
    print(date);
  }

  Future<String> creaPazienteServer() async {
    var uri = Uri.parse('http://127.0.0.1:5000/dottore/crea_visita');
    print(uri);

    String cfd = await FlutterSession().get("cf");
    print(cfd + "ukff");

    int role = 1;
    Map<String, String> message = {
      "cfdottore": cfd,
      "ora": _time.format(context),
      "data": date,
      "notifica": dropdownValue,
      "cfpaziente": "admin"
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

    if (data.statusCode == 200){
      creaPazienteServer();
      final snackBar = SnackBar(
        content: const Text('Visita inserita con successo'),
      );
      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      const snackBar = const SnackBar(
        content: Text('Visita non inserita'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return data.body;
  }

  String dropdownValue = 'Aggiungi notifica';

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _selectTime,
              child: Text('SELECT TIME'),
            ),
            SizedBox(height: 8),
            Text(
              'Ora selezionata: ${_time.format(context)}',
            ),
            DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.blue),
              underline: Container(
                height: 2,
                color: Colors.blue,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: <String>[
                'Aggiungi notifica',
                '5 minuti prima',
                '10 minuti prima',
                '30 minuti prima'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
