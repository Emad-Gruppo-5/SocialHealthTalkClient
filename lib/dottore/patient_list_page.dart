import 'package:flutter/material.dart';
import 'package:test_emad/main.dart';
import 'main_dottore.dart';
import 'utils.dart';
import 'patient_list_item.dart';
import 'detail_patient.dart';
  
  

  class List_page extends StatelessWidget {
  final String token;
  final String cod_fiscale;
  List_page({
    required this.cod_fiscale,
    required this.token
  } );

  List<PatientListItem> patients = Utils.getPatientList();

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        title: const Text("Pazienti"),
        actions: [
          _iconButton(context, Icons.logout, 'Logout', LoginPage()),
        ],
      ),
      body: ListView.builder(
        itemCount: patients.length,
        itemBuilder: (BuildContext ctx, int index) {
          return _card(patients[index].name! + ' ' + patients[index].surname! , patients[index].lastAccess!, patients[index].state!, index, ctx );
        
         }
      )
    );
  }

  Widget _card(String title, String subtitle, bool state, int index, BuildContext ctx) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12.5)),
        trailing: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: state ? Colors.green : Colors.red,
          ),
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(right: 30.0),
        ),
        onTap: () {
          Navigator.push(
            ctx,
            MaterialPageRoute(
              builder: (context) => DetailPatient(cod_fiscale: cod_fiscale, token: token,),
              settings: RouteSettings(    
                arguments: patients[index],
              ),
            ),
          );
        },
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => statelessWidget),
        );
      },
    );
  }


  }