import 'package:flutter/material.dart';
import 'main_dottore.dart';
import 'utils.dart';
import 'patient_list_item.dart';
import 'detail_patient.dart';
  
  

  class List_page extends StatelessWidget {
  
  List<PatientListItem> patients = Utils.getPatientList();

  @override
  Widget build(BuildContext context) {


/*     return Scaffold(
      appBar: AppBar(
        title: const Text("Pazienti"),
        actions: [
          _iconButton(context, Icons.logout, 'Logout', const Home()),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [ 
          Expanded(
            child: ListView.builder(
              itemCount: patients.length,
              itemBuilder: (BuildContext ctx, int index) {
                return Container(
                    margin: const EdgeInsets.all(10),
                    height: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(patients[index].name! + '  ' +  patients[index].surname!),
                        const Spacer(),
                        Text(patients[index].lastAccess!),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: patients[index].state! ? Colors.green : Colors.red,
                          ),
                          width: 7,
                          height: 7,
                        ),
                      ],
                    )
                  );
              },
            ),
          )
        ],
      )
    );
  } */

  return Scaffold(
      appBar: AppBar(
        title: const Text("Pazienti"),
        actions: [
          _iconButton(context, Icons.logout, 'Logout', const MainDottore()),
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
              builder: (context) => const DetailPatient(),
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