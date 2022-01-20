import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_emad/dottore/visita_details.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// My app class to display the date range picker
class createVisita extends StatefulWidget {
  final String token;
  final String cod_fiscale;

  createVisita({required this.cod_fiscale, required this.token});

  @override
  createVisitaState createState() => createVisitaState();
}

/// State for MyApp
class createVisitaState extends State<createVisita> {
  late String cod_fiscale;
  late String token;

  @override
  void initState() {
    cod_fiscale = widget.cod_fiscale;
    token = widget.token;
    super.initState();
  }

  String _selectedDate = '';

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('it'),
        ],
        locale: const Locale('it'),
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Pianifica visita"),
              actions: [
                IconButton(
                    onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TimePickerVisita(
                                cod_fiscale: cod_fiscale,
                                token: token,
                                date: _selectedDate))),
                    icon: const Icon(Icons.add)),
              ],
            ),
            body: Stack(
              children: <Widget>[
                SfDateRangePicker(
                  onSelectionChanged: _onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.single,
                ),
              ],
            )));
  }
}
