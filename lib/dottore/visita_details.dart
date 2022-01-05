import 'dart:convert';
import 'dart:math';

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
      home: CreateVisita2(date: date),
    );
  }
}

class CreateVisita2 extends StatefulWidget {
  final String date;

  const CreateVisita2({Key? key, required this.date}) : super(key: key);

  @override
  _CreateVisita2State createState() => _CreateVisita2State(date: date);
}

class _CreateVisita2State extends State<CreateVisita2> {
  TimeOfDay _time = TimeOfDay(hour: 10, minute: 15);
  final String date;

  _CreateVisita2State({required this.date});

  @protected
  @mustCallSuper
  void initState() {
    getPatient();
    newDataList.clear();
    newDataList.add('Aggiungi Paziente');
  }

  static List<String> mainDataList = [];

  Future<String> getPatient() async {
    mainDataList.clear();
    var uri = Uri.parse('http://127.0.0.1:5000/admin/attori_associati');
    print(uri);

    String cfd = await FlutterSession().get("cf");
    print(cfd + "ukff");

    int role = 1;
    Map<String, String> message = {
      "cod_fiscale": cfd,
      "role": role.toString(),
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

    var i = 0;
    while (i < json.decode(data.body).length) {
      mainDataList.add(json.decode(data.body)[i]['cod_fiscale']);
      i = i + 1;
    }

    print(mainDataList);

    setState(() {
      newDataList.addAll(mainDataList);
    });

    return data.body;
  }

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

  Future<String> creaVisitaServer() async {
    var uri = Uri.parse('http://127.0.0.1:5000/dottore/crea_visita');
    print(uri);

    String cfd = await FlutterSession().get("cf");
    print(cfd + "ukff");

    Random random = new Random();
    int id = random.nextInt(1000000);
    Map<String, String> message = {
      "id": id.toString(),
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

    if (data.statusCode == 200) {
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

  String dropdownValue2 = 'Aggiungi Paziente';

  List<String> newDataList = List.from(mainDataList);

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _selectTime,
              child: Text('Seleziona Ora'),
            ),
            const SizedBox(height: 8),
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
            ),
            DropdownButton<String>(
              value: dropdownValue2,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.blue),
              underline: Container(
                height: 2,
                color: Colors.blue,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue2 = newValue!;
                });
              },
              items: newDataList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                if (dropdownValue2 != 'Aggiungi Paziente') {
                  creaVisitaServer();
                } else {
                  final snackBar = SnackBar(
                    content: const Text('Seleziona orario della notifica'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: const Text('Salva'),
            )
          ],
        ),
      ),
    );
  }
}
