import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_emad/admin/lista_pazienti.dart';
import 'package:test_emad/admin/lista_dottori.dart';
import 'package:test_emad/admin/lista_familiari.dart';
import 'package:test_emad/admin/lista_volontari.dart';
import 'package:test_emad/admin/stato_attivita_pazienti.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(AdminHome());
}

class AdminHome extends StatefulWidget {



  @override
  _AdminHome createState() => _AdminHome();
}

class _AdminHome extends State<AdminHome> {


  int key = 0;

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    switch (index) {
      case 1:
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListaPazienti(),
            ),
          );
        }
        break;

      case 2:
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListaDottori(),
            ),
          );
        }
        break;

      case 3:
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListaFamiliari(),
            ),
          );
        }
        break;

      case 4:
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListaVolontari(),
            ),
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context){

    int online;
    int offline;
    


    return Scaffold(
            appBar: new AppBar(),
            body: Center(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("patients")
                    .where('status', isEqualTo: 'online')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    
                    return Center(
                        child: Image.asset(
                      'assets/images/loading.gif',
                    )
                    );
                  }
                  online = snapshot.data!.docs.length;

                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("patients")
                        .where('status', isEqualTo: 'offline')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        
                        return Center(
                            child: Image.asset(
                          'assets/images/loading.gif',
                        )
                        );
                      }

                      offline = snapshot.data!.docs.length;


            // FutureBuilder(future: getstatus().then((status) => {
            //     print(status['online'].toString() + " " + status['offline'].toString()),

            //     online = int.tryParse(status['online'] ?? '0'),
            //     offline = int.tryParse(status['offline'] ?? '0'),
            //     print(status['online'].toString() + " " + status['offline'].toString()),
            //   }), builder: (context, snap){
            //   if(!snap.hasData) {
            //     return Center(
            //           child: Image.asset(
            //         'assets/images/loading.gif',
            //       )
            //       );
            //   }
              return MaterialApp(

                debugShowCheckedModeBanner: false,
                title: 'Stato attività pazienti',
                home: Scaffold(
                    appBar: new AppBar(),
                    body: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SfCircularChart(
                                  
                                  title: ChartTitle(text: "Stato Attività pazienti"),
                                  legend: Legend(
                                      isVisible: true,
                                      overflowMode: LegendItemOverflowMode.wrap),
                                  series: <CircularSeries>[
                                    PieSeries<ChartData, String>(
                                        dataSource: [
                                          ChartData('Online', online, const Color(0xff0984e3)),
                                          ChartData('Offline', offline, const Color(0xfffdcb6e)),
                                        ],
                                        xValueMapper: (ChartData data, _) => data.x,
                                        yValueMapper: (ChartData data, _) => data.y,
                                        pointColorMapper: (ChartData data, _) =>
                                            data.color,
                                        dataLabelSettings:
                                            const DataLabelSettings(isVisible: true),
                                        // Radius of pie
                                        radius: '100%')
                                  ]
                                  )
                                  ,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: ListTile(
                                  title: const Text("Numero pazienti offline: " + "40"),
                                  subtitle: const Text("Premi per controllare"),
                                  trailing: new Icon(Icons.arrow_forward_ios),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StatoAttivitaPazienti(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ]
                          )
                    ),
                    bottomNavigationBar: Theme(
                      data: Theme.of(context).copyWith(
                          // sets the background color of the `BottomNavigationBar`
                          canvasColor: Colors.blue,
                          // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                          primaryColor: Colors.white,
                          textTheme: Theme.of(context)
                              .textTheme
                              .copyWith(caption: new TextStyle(color: Colors.white))),
                      // sets the inactive color of the `BottomNavigationBar`
                      child: BottomNavigationBar(
                        type: BottomNavigationBarType.fixed,
                        selectedItemColor: Colors.white,
                        selectedLabelStyle:
                            const TextStyle(fontWeight: FontWeight.bold),
                        items: const <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            icon: Icon(Icons.home_outlined),
                            label: 'Home',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.supervised_user_circle_outlined),
                            label: 'Pazienti',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.local_hospital),
                            label: 'Dottori',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.wc_outlined),
                            label: 'Familiari',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.attribution_outlined),
                            label: 'Volontari',
                          ),
                        ],
                        currentIndex: _selectedIndex,
                        //New
                        onTap: _onItemTapped,
                        //selectedItemColor: Colors.blue,
                      ),
                    )
                    )
                    );
                    });
                }),
            ),
    );    
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);

  final String x;
  final int y;
  final Color? color;
}

Future<Map<String, String>> getstatus() async {


    var snapshot = await FirebaseFirestore.instance
      .collection('patients')
      .where('status', isEqualTo: 'online')
      .get();
    var online = snapshot.docs.length;

    snapshot = await FirebaseFirestore.instance
      .collection('patients')
      .where('status', isEqualTo: 'offline')
      .get();
    var offline = snapshot.docs.length;

    Map<String, String> status;
    if(online ==null || offline == null) status = { 'online' : '0' , 'offline' : '0'};
    else status = { 'online': online.toString() , 'offline' : offline.toString() };
    
    return status;
    
}
