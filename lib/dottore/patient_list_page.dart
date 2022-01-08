import 'package:flutter/material.dart';
import 'package:test_emad/main.dart';
import 'main_dottore.dart';
import 'utils.dart';
import 'patient_list_item.dart';
import 'detail_patient.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class List_page extends StatelessWidget {
  final String token;
  final String cod_fiscale;
  final String nome;
  final String cognome;
  final String email;
  final String num_cellulare;
  final String specializzazione;
  List_page({
    required this.cod_fiscale,
    required this.token,
    required this.nome,
    required this.cognome,
    required this.email,
    required this.num_cellulare,
    required this.specializzazione,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pazienti"),
        actions: [
          _iconButton(context, Icons.logout, 'Logout', LoginPage()),
        ],
      ),
      body: Center(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("patients")
                .orderBy("cognome")
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              return ListView(
                children: snapshot.data!.docs.map((patient) {
                  return Center(
                    child: ListTile(
                      title: Text(patient['nome'] + " " + patient['cognome']),
                      subtitle: Text(patient['status'] == 'online'
                          ? 'online'
                          : 'ultimo accesso: ' + patient['ultimo_accesso']),
                      trailing: Icon(
                        Icons.circle,
                        color: patient['status'] == 'online'
                            ? Colors.greenAccent
                            : Colors.redAccent,
                      ),
                      onTap: () {
                        //  print("COD cazzo:" + patient.id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailPatient(
                                    cod_fiscale: cod_fiscale,
                                    token: token,
                                    nome: nome,
                                    cognome: cognome,
                                    email: email,
                                    specializzazione: specializzazione,
                                    num_cellulare: num_cellulare,
                                    paz_cod_fiscale: patient.id,
                                  )),
                        );
                      },
                    ),
                  );
                }).toList(),
              );
            }),
      ),
    );
  }

  Widget _iconButton(BuildContext context, IconData icon, String tooltip,
      StatelessWidget statelessWidget) {
    return IconButton(
      icon: Icon(icon),
      tooltip: tooltip,
      iconSize: 40,
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => statelessWidget),
        );
      },
    );
  }
}
