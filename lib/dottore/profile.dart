import 'dart:convert';

import 'package:flutter/material.dart';
import 'main_dottore.dart';
import 'modify_profile.dart';
import 'package:http/http.dart' as http;


/// This is the main application widget.
class Profile extends StatelessWidget {
  
  final String token;
  final String cod_fiscale;

  Profile({
    required this.cod_fiscale,
    required this.token
  });

  Widget _iconButton(BuildContext context, IconData icon, String tooltip,
      StatelessWidget statelessWidget) {
    IconButton iconButton;

    if (tooltip != "Modifica") {
      iconButton = IconButton(
        icon: Icon(icon),
        tooltip: tooltip,
        iconSize: 40,
        onPressed: () {
          Navigator.pop(context);
        },
      );
    } else {
      iconButton = IconButton(
        icon: Icon(icon),
        tooltip: tooltip,
        iconSize: 40,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => statelessWidget),
          );
        },
      );
    }

    return iconButton;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: _iconButton(context, Icons.edit, 'Modifica', ModifyProfile(token: token, cod_fiscale: cod_fiscale)),
          title: const Center(
            child: Text("Profilo"),
          ),
          actions: [
            _iconButton(context, Icons.logout, 'Logout', MainDottore(cod_fiscale: cod_fiscale, token: token,)),
          ],
        ),
        body: Center(
          child: MyProfile(token: token, cod_fiscale: cod_fiscale),
        ),
      ),
    );
  }
}

class MyProfile extends StatefulWidget {
  
  final String token;
  final String cod_fiscale;
  
  MyProfile({required this.token, required this.cod_fiscale});

  MyProfileState createState() => MyProfileState();
}

// This is the stateless widget that the main application instantiates.
class MyProfileState extends State<MyProfile> {


  late String token;
  late String cod_fiscale;
  var data;

  @override
  @protected
  @mustCallSuper
  void initState() {
    token = widget.token;
    cod_fiscale = widget.cod_fiscale;
    getDoctor();
  }

  Future<String> getDoctor() async {

    
    print(cod_fiscale + "ukff");

    var uri = Uri.parse('http://127.0.0.1:5000/admin/dati_profilo');
    print(uri);

    Map<String, String> message = {
      "cod_fiscale": cod_fiscale.toString().lastChars(6),
      "role": 2.toString(),
    };
    var body = json.encode(message);
    print("\nBODY:: " + body);
    data = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: body);
    print('Response status: ${data.statusCode}');
    print('Response body: ' + data.body);

    setState(() {
      data = data;
    });

    return data.body;
  }

  Widget _card(String title, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    if (data!=null) {
      return Column(
        children: [
          Text(
            json.decode(data.body)['cognome'] + " " + json.decode(data.body)['nome'],
            style: const TextStyle(fontSize: 50),
          ),
          _card(json.decode(data.body)['cod_fiscale'], Icons.person),
          _card(json.decode(data.body)['num_cellulare'], Icons.smartphone),
          _card(json.decode(data.body)['email'], Icons.email),
          _card("Cardiologo", Icons.medical_services), //TODO
        ],
      );
    }else {
      return Text("loading...");
    }
  }
}

extension E on String {
  String lastChars(int n) => substring(length - n);
}