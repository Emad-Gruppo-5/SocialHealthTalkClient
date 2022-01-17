import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
  
  DateFormat dateFormat = DateFormat("yyyy/MM/dd HH:mm");
  // late TextEditingController _data_domande = new TextEditingController(text: dateFormat.format(DateTime.now()));
  TextEditingController _data_domande = TextEditingController();
  @override
  void initState() {
    cod_fiscale_paziente = widget.cod_fiscale_paziente;
    cod_fiscale_dottore = widget.cod_fiscale_dottore; 
    getListaDomande(dateFormat.format(DateTime.now())); 
    super.initState();
  }

  CollectionReference _opened_questions = FirebaseFirestore.instance.collection('questions_to_answer');
  


  Future<List<Map<String, dynamic>>> getListaDomande(String dateFormat) async {
    List<Map<String, dynamic>> _closed_questions = [];
    var uri = Uri.parse('http://127.0.0.1:5000/lista_domande');
    print(uri);

    Map<String, dynamic> message = {
      "data_query": _data_domande,
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

    for (int i=0; i < json.decode(data.body).length; i++) {
      _closed_questions.add({

        'id_domanda': json.decode(data.body)[i]['id_domanda'],
        'testo_domanda': json.decode(data.body)[i]['testo_domanda'],
        'testo_risposta': json.decode(data.body)[i]['testo_risposta'],
        'audio_risposta': json.decode(data.body)[i]['audio_risposta'],
        'data_risposta': json.decode(data.body)[i]['data_risposta'],
        
      });
    }

    return _closed_questions;
  }


  Widget getSubtitle(bool flag, ){
    Row row;
    if(flag){
      row = new Row(
        children: [
          const Icon(Icons.volume_up_outlined, color: Colors.blue),
          Text("Risposta audio")
        ],
      );
    }
    else{
      row = new Row(
        children: [
          const Icon(Icons.keyboard_alt_outlined, color: Colors.blue),
          Text("Risposta testuale")
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
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(Duration(days: 0)),
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
                        getListaDomande(_data_domande.text);
                      },
                      child: const Text('Salva'),
                    ),
                  ),
                ),
              ],
              ),
            ),
            // ExpansionTile(
            //   leading: const Icon(Icons.question_answer),
            //   title: const Text('Domande aperte'),
            //   children: [
            //     StreamBuilder<QuerySnapshot>(
            //       stream: _opened_questions
            //               .where('cod_fiscale_paziente', isEqualTo: cod_fiscale_paziente)
            //               .where('cod_fiscale_dottore', isEqualTo: cod_fiscale_dottore)
            //               .where("data_domanda", isEqualTo: _data_domande.text)
            //               .orderBy("data_domanda", descending: true)
            //               .snapshots(),
            //       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    
            //         if (snapshot.hasError) {
            //           print(snapshot.error);
            //           return const Text('Something went wrong');
            //         }

            //         if (snapshot.connectionState == ConnectionState.waiting) {
            //           return Center(child: CircularProgressIndicator());
            //         }
            //         if (snapshot.data!.docs.isEmpty) {
            //             return Center( child: Image.asset('assets/images/promemoria.png'));
            //         }
            //         else
            //         return ListView(
            //           children: snapshot.data!.docs.map((DocumentSnapshot document) {
            //             Map<String, dynamic> data =
            //             document.data()! as Map<String, dynamic>;
            //             String subtitle = "";
            //             Icon trailing;
            //             print(data.toString());

            //             return Center(
            //               child: Card(
            //                 child: Column(
            //                   mainAxisSize: MainAxisSize.min,
            //                   children: <Widget>[
            //                     ListTile(
            //                       leading: Column(
            //                         mainAxisAlignment: MainAxisAlignment.center,
            //                         children: <Widget>[
            //                           Visibility(
            //                             child: const Icon(Icons.remove_red_eye_outlined ,
            //                                 color: Colors.blue),
            //                             visible: data['letto'],
            //                           ),
            //                         ],
            //                       ),
            //                       title: Text(data['testo_domanda']),
            //                       subtitle: Text("Data: " + data["data_domanda"]),
            //                     ),
            //                     // row,
            //                   ],
            //                 ),
            //               ),
            //             );
            //           }).toList(),
            //         );
            //       },
            //       )
            //   ],
            // ),

            // ExpansionTile(
            //    leading: const Icon(
            //     Icons.close,
            //     color: Colors.red,
            //   ),
            //   title: const Text('Domande chiuse'),
            //   children: <Widget>[
            //     FutureBuilder(
            //       future: getListaDomande(_data_domande.text),
            //       builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot){
                    
            //         if (snapshot.hasData) {

            //           List<Map<String, dynamic>> lista = List.from(snapshot.data!);


            //           return ListView(
            //             children: lista.map((data){
            //               return Center(
            //                     child: Card(
            //                       child: Column(
            //                         mainAxisSize: MainAxisSize.min,
            //                         children: <Widget>[
            //                           ListTile(
            //                             title: Text(data['testo_domanda'] ),
            //                             subtitle: (data["audio"]==null && data["testo_risposta"]!=null) ? getSubtitle(false)  : getSubtitle(true),
            //                             // QUI BISOGNA CAPIRE COME RIPRODURRE L'AUDIO DELLA RISPOSTA
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   );
            //             }).toList(),
            //           );
            //         }
            //         else{
            //           return const Center(child: CircularProgressIndicator());
            //         }
            //     })
            //   ],
            // ),
          ],
          ),
        ),
      ),
    );
  }
}
