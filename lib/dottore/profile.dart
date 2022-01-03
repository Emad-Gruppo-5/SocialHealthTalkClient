import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'main_dottore.dart';
import 'modify_profile.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const Profile());

/// This is the main application widget.
class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

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
          leading: _iconButton(context, Icons.edit, 'Modifica', const ModifyProfile()),
          title: const Center(
            child: Text("Profilo"),
          ),
          actions: [
            _iconButton(context, Icons.logout, 'Logout', const MainDottore()),
          ],
        ),
        body: Center(
          child: MyProfile(),
        ),
      ),
    );
  }
}

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  MyProfileState createState() => MyProfileState();
}

// This is the stateless widget that the main application instantiates.
class MyProfileState extends State<MyProfile> {

  var data;

  @override
  @protected
  @mustCallSuper
  void initState() {
    getDoctor();
  }

  Future<String> getDoctor() async {

    String data2 = await FlutterSession().get("cf");
    print(data2 + "ukff");

    var uri = Uri.parse('http://127.0.0.1:5000/admin/dati_profilo');
    print(uri);

    Map<String, String> message = {
      "cod_fiscale": data2.toString().lastChars(6),
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
          _card("Cardiologo", Icons.medical_services),
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