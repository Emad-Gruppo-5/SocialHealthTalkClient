
import 'package:flutter/material.dart';
import 'package:test_emad/dottore/profile.dart';
import 'package:test_emad/dottore/patient_list_page.dart';
import 'package:test_emad/dottore/visita.dart';



/// This is the main application widget.
class MainDottore extends StatelessWidget {
  
  final String token;
  final String cod_fiscale;

  MainDottore({
    required this.cod_fiscale,
    required this.token
  });


  static const String _title = 'Social Health Talk';

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: _title,
      home: MyStatefulWidget(token: token, cod_fiscale: cod_fiscale),
    );
  }


}


/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {

  final String token;
  final String cod_fiscale;

  MyStatefulWidget({
    required this.cod_fiscale,
    required this.token
  });

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  late String token;
  late String cod_fiscale;
  late List<Widget> _widgetOptions;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  void initState() {
    cod_fiscale = widget.cod_fiscale;
    token = widget.token;
    _widgetOptions = <Widget>[
    List_page(cod_fiscale: cod_fiscale , token: token),
    createVisita(cod_fiscale: cod_fiscale , token: token),
    Profile( cod_fiscale: cod_fiscale , token: token),
    ];
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Pianifica Visita',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profilo',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }


}
