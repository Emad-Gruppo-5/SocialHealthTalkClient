import 'package:flutter/material.dart' hide Key;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:crypt/crypt.dart';
import 'package:test_emad/patient/home.dart';
import 'package:test_emad/admin/adminHome.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: FirebaseOptions(
      apiKey: "AIzaSyAIqKriphksQVYJ4okGp_RGecy8kZCALcA",
      appId: "1:208691712490:android:d4eaafadf9ba1e990b2293",
      messagingSenderId: "208691712490-35elfljftgqj1v9gi9c3otgab8s7lfae.apps.googleusercontent.com",
      projectId: "firestore-example-7e888",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

    // String token;
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: "Social Health Talk",
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            routes: {
              '/' : (context) => LoginPage(),
            },
        );
    }
}

class LoginPage extends StatelessWidget {


    TextEditingController _cod_fiscaleC = TextEditingController();
    TextEditingController _passwordC = TextEditingController();

    Future<String> login(cod_fiscale, password) async {
      
      final digest = Crypt.sha256(password).toString();
      var uri = Uri.parse('http://127.0.0.1:5000/login');
      print(uri);

      int role;
      print("\nECCOMI IN getUser. COD_FISCALE: "+ cod_fiscale +" PASSWORD: "  + digest);

      Map<String, String> message = {"cod_fiscale": cod_fiscale, "password":password};
      var body = json.encode(message);
      print("\nBODY:: " + body);
      final data = await http.post(uri, headers: <String, String>{ 'Content-Type':'application/json; charset=UTF-8'}, body: body);
      print('Response status: ${data.statusCode}');
      print('Response body: ${data.body}');
      return data.body;
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        colors: [
                            Colors.lightBlue.shade200,
                            Colors.lightBlue.shade100,
                            Colors.lightBlue.shade200
                        ]
                    )
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: < Widget > [
                        SizedBox(height: 40, ),
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: < Widget > [
                                    // Text("Login", style: TextStyle(color: Colors.white, fontSize: 40),),
                                    // SizedBox(height: 10,)
                                    Center(child: Image.asset('assets/images/SHT.png'))
                                ],
                            ),
                        ),
                        SizedBox(height: 20),
                        Expanded(
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                                ),
                                child: SingleChildScrollView(
                                    child: Padding(
                                        padding: EdgeInsets.all(30),
                                        child: Column(
                                            children: < Widget > [
                                                SizedBox(height: 30, ),
                                                Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(10),
                                                        boxShadow: [BoxShadow(
                                                            color: Color.fromRGBO(109, 193, 255, .3),
                                                            blurRadius: 20,
                                                            offset: Offset(0, 10)
                                                        )]
                                                    ),
                                                    child: Column(
                                                        children: < Widget > [
                                                            Container(
                                                                padding: EdgeInsets.all(10),
                                                                decoration: BoxDecoration(
                                                                    border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                                                                ),
                                                                child: TextField(
                                                                    controller: _cod_fiscaleC,
                                                                    decoration: InputDecoration(
                                                                        hintText: "Codice fiscale",
                                                                        hintStyle: TextStyle(color: Colors.grey),
                                                                        border: InputBorder.none
                                                                    ),
                                                                ),
                                                            ),
                                                            Container(
                                                                padding: EdgeInsets.all(10),
                                                                decoration: BoxDecoration(
                                                                    border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                                                                ),
                                                                child: TextField(
                                                                    controller: _passwordC,
                                                                    obscureText: true,
                                                                    decoration: InputDecoration(
                                                                        hintText: "Password",
                                                                        hintStyle: TextStyle(color: Colors.grey),
                                                                        border: InputBorder.none
                                                                    ),
                                                                ),
                                                            ),
                                                        ],
                                                    ),
                                                ),
                                                SizedBox(height: 40, ),
                                                Container(
                                                    height: 50,
                                                    margin: EdgeInsets.symmetric(horizontal: 50),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(90),
                                                        color: Colors.lightBlue.shade700
                                                    ),
                                                    child: ElevatedButton(onPressed: () {
                                                            var cod_fiscale = _cod_fiscaleC.text;
                                                            var password = _passwordC.text;
                                                            
                                                            login(cod_fiscale, password).then((data) {
                                                              int role = json.decode(data)['role'];
                                                              String token = json.decode(data)['token'];
                                                              String nome = json.decode(data)['nome'];
                                                              String cognome = json.decode(data)['cognome'];
                                                              String email = json.decode(data)['email'];
                                                              int num_cellulare = json.decode(data)['num_cellulare'];
                                                              int tipologia_chat = json.decode(data)['tipologia_chat'];
                                                              switch (role) {
                                                                case 1: //PAZIENTE
                                                                  Navigator.push(
                                                                         context,
                                                                         MaterialPageRoute(
                                                                           builder: (context) => Patient_Home(
                                                                             cod_fiscale: cod_fiscale,
                                                                             nome: nome, 
                                                                             cognome: cognome,
                                                                             email: email, 
                                                                             num_cellulare: num_cellulare,
                                                                             tipologia_chat: tipologia_chat,
                                                                             token: token
                                                                            )
                                                                           ),
                                                                         
                                                                         );
                                                                  break;
                                                                case 2: //DOTTORE
                                                                  if(cod_fiscale == 'admin'){
                                                                      Navigator.push(context,
                                                                         MaterialPageRoute(
                                                                            builder: (context) => AdminHome()));
                                                                  }
                                                                  else{
                                                                    // Navigator.push(context,
                                                                    //      MaterialPageRoute(
                                                                    //         builder: (context) => Familiare(token: token)));
                                                                  }
                                                                  
                                                                  break;
                                                                case 3: //VOLONTARIO
                                                                  // Navigator.push(context,
                                                                  //        MaterialPageRoute(
                                                                  //           builder: (context) => Familiare(token: token)));
                                                                  break;
                                                                case 4: //FAMILIARE
                                                                  // Navigator.push(context,
                                                                  //        MaterialPageRoute(
                                                                  //           builder: (context) => Familiare(token: token)));
                                                                  break;
                                                                default:
                                                              }
                                                            });
                                                            
                                                            
                                                            // Navigator.of(context).pushNamed("familiarePage");

                                                        }, child: Center(
                                                            child: Text("Accedi", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), )

                                                        ),
                                                        style: ElevatedButton.styleFrom(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(90)
                                                            ),
                                                            primary: Colors.lightBlue.shade900
                                                        ),

                                                    )
                                                ),
                                                SizedBox(height: 20, ),
                                                const Divider(
                                                        height: 20,
                                                        thickness: 1,
                                                        indent: 10,
                                                        endIndent: 30
                                                    ),
                                                    // SizedBox(height: 20, ),
                                                    // Text("Non sei ancora registrato? ", style: TextStyle(color: Colors.black87), ),
                                                    // SizedBox(height: 20, ),
                                                    // Container(
                                                    //     height: 50,
                                                    //     margin: EdgeInsets.symmetric(horizontal: 50),
                                                    //     decoration: BoxDecoration(
                                                    //         borderRadius: BorderRadius.circular(50),
                                                    //         color: Colors.lightBlue.shade900
                                                    //     ),
                                                    //     child: Center(
                                                    //         child: Text("Registrati", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), ),
                                                    //     )
                                                    // )
                                            ],
                                        ),
                                    ),
                                ),
                            ),
                        )
                    ],
                ),
            ),
        );
    }
}