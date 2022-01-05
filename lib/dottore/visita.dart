import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_emad/dottore/visita_details.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


/// My app class to display the date range picker
class createVisita extends StatefulWidget {

  final String token;
  final String cod_fiscale; 

  createVisita({
    required this.cod_fiscale,
    required this.token
  } );

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
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
        // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                TimePickerVisita(cod_fiscale: cod_fiscale, token: token, date: _selectedDate)));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(

            body: Stack(
              children: <Widget>[
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Selected date: $_selectedDate'),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 80,
                  right: 0,
                  bottom: 0,
                  child: SfDateRangePicker(
                    onSelectionChanged: _onSelectionChanged,
                    selectionMode: DateRangePickerSelectionMode.single,
                    initialSelectedRange: PickerDateRange(
                        DateTime.now().subtract(const Duration(days: 4)),
                        DateTime.now().add(const Duration(days: 3))),
                  ),
                )
              ],
            )));
  }
}