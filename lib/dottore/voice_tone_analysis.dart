import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;

class VoiceToneAnalysis extends StatelessWidget {
  const VoiceToneAnalysis(this._codFiscalePaziente, this._codFiscaleDottore,
      {Key? key})
      : super(key: key);

  final String _codFiscalePaziente, _codFiscaleDottore;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
      supportedLocales: const [Locale('it')],
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            tooltip: "Indietro",
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text("Analisi del tono di voce"),
          actions: [
            IconButton(
                onPressed: () =>
                    Navigator.popUntil(context, ModalRoute.withName('/')),
                icon: const Icon(Icons.logout))
          ],
        ),
        body: MyVoiceToneAnalysis(_codFiscalePaziente, _codFiscaleDottore),
      ),
    );
  }
}

class MyVoiceToneAnalysis extends StatefulWidget {
  const MyVoiceToneAnalysis(this._codFiscalePaziente, this._codFiscaleDottore,
      {Key? key})
      : super(key: key);

  final String _codFiscalePaziente, _codFiscaleDottore;

  @override
  _MyVoiceToneAnalysis createState() =>
      _MyVoiceToneAnalysis(_codFiscalePaziente, _codFiscaleDottore);
}

class _MyVoiceToneAnalysis extends State<MyVoiceToneAnalysis> {
  _MyVoiceToneAnalysis(this._codFiscalePaziente, this._codFiscaleDottore);

  final String _codFiscalePaziente, _codFiscaleDottore;

  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  late TextEditingController _date;

  @override
  void initState() {
    super.initState();

    _date = TextEditingController(text: dateFormat.format(DateTime.now()));
  }

  Widget _textFormField(IconData icon, String labelText, String validator,
      TextEditingController _controller) {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        icon: Icon(icon),
        labelText: labelText,
      ),
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validator;
        }
        return null;
      },
    );
  }

  Widget _dateTimePicker() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DateTimePicker(
        controller: _date,
        type: DateTimePickerType.date,
        dateMask: 'd MMM, yyyy',
        locale: const Locale("it", "IT"),
        firstDate: DateTime(2010),
        lastDate: DateTime(2100),
        icon: const Icon(Icons.event),
        dateLabelText: 'Data',
        selectableDayPredicate: (date) {
          _textFormField(Icons.help_center_rounded, "Inserisci data",
              "Ricordati di inserire la data", _date);
          return true;
        },
        onChanged: (val) {
          print(val);
          _textFormField(Icons.help_center_rounded, "Inserisci data",
              "Ricordati di inserire la data", _date);
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getAnalisi(String date) async {
    List<Map<String, dynamic>> _analysis = [];
    var uri = Uri.parse('http://127.0.0.1:5000/getAnalisi');

    print(uri);

    Map<String, dynamic> message = {
      "data": date,
      "cod_fiscale_paziente": _codFiscalePaziente,
      "cod_fiscale_dottore": _codFiscaleDottore
    };
    var body = json.encode(message);
    print("\nBODY: " + body);
    var data = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: body);
    print('Response status: ${data.statusCode}');
    print('Response body: ' + data.body);

    if (data.statusCode == 200) {
      for (int i = 0; i < json.decode(data.body).length; i++) {
        _analysis.add({
          'testo_domanda': json.decode(data.body)[i]['testo_domanda'],
          'data_domanda': json.decode(data.body)[i]['data_domanda'],
          'data_risposta': json.decode(data.body)[i]['data_risposta'],
          'humor': json.decode(data.body)[i]['humor']
        });
      }
    } else {
      print("VUOTO");
    }

    return _analysis;
  }

  Widget _expansionTile(
      String question, String question_date, String answer_date, var humor) {
    String humorJson = utf8.decode(base64.decode(humor));
    humorJson = humorJson.replaceAll("'", "\"");
    print(humorJson);
    Map<String, dynamic> jsonObject = jsonDecode(humorJson);
    return ExpansionTile(
      title: Text(question),
      subtitle: Text(
          "Data domanda: " + question_date + "\nData risposta: " + answer_date),
      children: <Widget>[
        ListTile(
          title: const Text("Analisi"),
          subtitle: Text("arrabbiato: " +
              jsonObject['angry'].toString() +
              ", paura: " +
              jsonObject['fear'].toString() +
              ", felice: " +
              jsonObject['happy'].toString() +
              ", neutral: " +
              jsonObject['neutral'].toString() +
              ", triste: " +
              jsonObject['sad'].toString()),
          isThreeLine: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _dateTimePicker(),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  getAnalisi(_date.text);
                });
              },
              child: const Text('Cerca'),
            ),
          ),
        ),
        FutureBuilder(
            future: getAnalisi(_date.text),
            builder:
                (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                List<Map<String, dynamic>> list = List.from(snapshot.data!);

                return ListView(
                  shrinkWrap: true,
                  children: list.map((data) {
                    return _expansionTile(
                        data['testo_domanda'],
                        data['data_domanda'],
                        data['data_risposta'],
                        data['humor']);
                  }).toList(),
                );
              } else {
                return const Center(
                    child: Text(
                  "Nessuna analisi per il giorno selezionato",
                  style: TextStyle(fontSize: 20),
                ));
              }
            }),
      ],
    );
  }
}
