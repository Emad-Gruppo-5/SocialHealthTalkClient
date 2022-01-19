import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:audioplayer/audioplayer.dart';


class QuestionsHistory extends StatefulWidget {
  
  final String cod_fiscale_paziente;
  final String cod_fiscale_dottore;  
  QuestionsHistory({required this.cod_fiscale_paziente, required this.cod_fiscale_dottore});

  @override
  _QuestionsHistory createState() => _QuestionsHistory();
}

class _QuestionsHistory extends State<QuestionsHistory> {
  late String cod_fiscale_paziente;
  late String cod_fiscale_dottore;  
  
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  // late TextEditingController _data_domande = new TextEditingController(text: dateFormat.format(DateTime.now()));
  late TextEditingController _data_domande = TextEditingController(text: dateFormat.format(DateTime.now()));
  @override
  void initState() {
    cod_fiscale_paziente = widget.cod_fiscale_paziente;
    cod_fiscale_dottore = widget.cod_fiscale_dottore;  
    super.initState();
  }

  CollectionReference _opened_questions = FirebaseFirestore.instance.collection('questions_to_answer');
  bool _isRecording = false;
  FirebaseStorage storage = FirebaseStorage.instance;
  
  AudioPlayer audioPlayer = AudioPlayer();

  _icon() {
    if (_isRecording == false) {
      return const Icon(Icons.play_circle, color: Colors.blue);
    } else {
      return const Icon(Icons.stop_circle, color: Colors.blue);
    }
  }


  Future<List<Map<String, dynamic>>> getListaDomande(String dateFormat) async {
    List<Map<String, dynamic>> _closed_questions = [];
    var uri = Uri.parse('http://192.168.1.55:5000/lista_domande');

    print(uri);

    Map<String, dynamic> message = {
      "data_query": dateFormat,
      "cod_fiscale_paziente": cod_fiscale_paziente,
      "cod_fiscale_dottore": cod_fiscale_dottore
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

    if(data.statusCode==200){
      for (int i=0; i < json.decode(data.body).length; i++) {
        _closed_questions.add({

          'id_domanda': json.decode(data.body)[i]['id_domanda'],
          'testo_domanda': json.decode(data.body)[i]['testo_domanda'],
          'testo_risposta': json.decode(data.body)[i]['testo_risposta'],
          'audio_risposta': json.decode(data.body)[i]['audio_risposta'],
          'data_risposta': json.decode(data.body)[i]['data_risposta'],
          
        });
      }
    }
    else{
      print("VUOTO");
    }
     
    return _closed_questions;
  }


  Widget getSubtitle(bool flag){
    Row row;
    if(flag){
      row = new Row(
        children: [
          const Icon(Icons.volume_up_outlined, color: Colors.blue),
          Text(" Risposta audio")
        ],
      );
    }
    else{
      row = new Row(
        children: [
          const Icon(Icons.keyboard_alt_outlined, color: Colors.blue),
          Text(" Risposta testuale")
        ],
      );
    }
    return row;
  }


  Widget _textFormField(IconData icon, String labelText, String validator,
      TextEditingController _con) {
    return TextFormField(
      controller: _con,
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




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [const Locale('it')],
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_sharp),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Storico domande'),
        ),
        body: SingleChildScrollView(
              child: Column(
          children: <Widget>[
            Form(
              child: Column(children: [
                  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DateTimePicker(
                    controller: _data_domande,
                    type: DateTimePickerType.date,
                    dateMask: 'd MMM, yyyy',
                    locale: const Locale("it", "IT"),
                    // initialDate: DateTime.now(),
                    firstDate: DateTime(2010),
                    lastDate: DateTime(2100),
                    icon: const Icon(Icons.event),
                    dateLabelText: 'Data',
                    selectableDayPredicate: (date) {
                      _textFormField(
                          Icons.help_center_rounded,
                          "Inserisci data",
                          "Ricordati di inserire la data",
                          _data_domande);
                      return true;
                    },
                    onChanged: (val) {
                      print(val);
                      _textFormField(
                          Icons.help_center_rounded,
                          "Inserisci data",
                          "Ricordati di inserire la data",
                          _data_domande);
                    },
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // getListaDomande(_data_domande.text);
                        });
                        
                      },
                      child: const Text('Cerca'),
                    ),
                  ),
                ),
              ],
              ),
            ),
            ExpansionTile(
              leading: const Icon(Icons.question_answer),
              title: const Text('Domande aperte'),
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: _opened_questions
                          .where('cod_fiscale_paziente', isEqualTo: cod_fiscale_paziente)
                          .where('cod_fiscale_dottore', isEqualTo: cod_fiscale_dottore)
                          .where('data_domanda', isGreaterThan: _data_domande.text + " 00:00")
                          .where('data_domanda', isLessThan: _data_domande.text + " 23:59")
                          .orderBy('data_domanda', descending: true)
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
                        return const Center(child: Text("Non ci sono domande aperte per il giorno selezionato"));
                    }
                    else
                    return ListView(
                      shrinkWrap: true,
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
                                        child: const Icon(Icons.circle ,
                                            color: Colors.blue),
                                        visible: data['letto'],
                                      ),
                                    ],
                                  ),
                                  title: Text(data['testo_domanda']),
                                  subtitle: Text("Data: " + data["data_domanda"]),
                                ),
                                // row,
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                  )
              ],
            ),

            ExpansionTile(
               leading: const Icon(
                Icons.auto_stories_sharp,
              ),
              title: const Text('Domande chiuse'),
              children: <Widget>[
                FutureBuilder(
                  future: getListaDomande(_data_domande.text),
                  builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot){
                    
                    if ( snapshot.hasData && !snapshot.data!.isEmpty) {
                      
                      List<Map<String, dynamic>> lista = List.from(snapshot.data!);
                      

                      return ListView(
                        shrinkWrap: true,
                        children: lista.map((data){
                          return Center(
                                child: Card(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        title: Text(data['testo_domanda'] ),
                                        subtitle: json.encode(data["audio_risposta"]).compareTo("null")==0 ? getSubtitle(false)  : getSubtitle(true),
                                        onTap: () => showDialog<void>(
                                                context: context,
                                                builder: (BuildContext context) {
                                                   
                                                  
                                                  return SimpleDialog(
                                                    title: Text(data['testo_domanda'] ),
                                                    children: <Widget>[
                                                      Center(
                                                          child:  json.encode(data["audio_risposta"]).compareTo("null")==0 ? 
                                                                                Text(data["testo_risposta"]) : 
                                                                                IconButton(
                                                                                    onPressed: () {
                                                                                      audioPlayer.play(data["audio_risposta"]);
                                                                                    },
                                                                                    icon: _icon(),
                                                                                  ),
                                                          
                                                      )
                                                      
                                                    ],
                                                  );
                                                }
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                        }).toList(),
                      );
                    }
                    else{
                      return const Center(child: Text("Non ci sono domande chiuse per il giorno selezionato"));
                    }
                })
              ],
            ),
          ],
          ),
        ),
      ),
    );
  }
}
