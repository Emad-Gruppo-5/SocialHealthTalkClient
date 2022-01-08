import 'package:flutter/material.dart';
import 'package:test_emad/admin/mainAdmin.dart';
import 'package:test_emad/admin/lista_pazienti.dart';
import 'package:test_emad/admin/lista_dottori.dart';
import 'package:test_emad/admin/lista_familiari.dart';
import 'package:test_emad/admin/lista_volontari.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHome createState() => _AdminHome();
}

class _AdminHome extends State<AdminHome> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List _widgetOptions = <Widget>[
    MainAdmin(),
    ListaPazienti(),
    ListaDottori(),
    ListaFamiliari(),
    ListaVolontari()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
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
            label: "Volontari",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}
