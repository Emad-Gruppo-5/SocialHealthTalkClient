import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'profile.dart';

void main() => runApp(const Home());

/// This is the main application widget.
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  Widget _iconButtonPush(BuildContext context, IconData icon, String tooltip,
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

  Widget _iconButtonPop(BuildContext context, IconData icon, String tooltip) {
    return IconButton(
      icon: Icon(icon),
      tooltip: tooltip,
      iconSize: 40,
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: _iconButtonPush(
              context, Icons.account_circle, 'Profilo', const Profile()),
          title: const Text("Promemoria giornalieri"),
          actions: [
            _iconButtonPop(context, Icons.logout, 'Logout'),
          ],
        ),
        body: const Center(
          child: MyHome(),
        ),
      ),
    );
  }
}

/// This is the stateless widget that the main application instantiates.
class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  Widget _card(String title, String subtitle) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Duration seconds = const Duration(seconds: 10);
    Timer timer = Timer(seconds, handleTimeout);

    return GestureDetector(
      child: ListView(
        children: [
          _card('Hai preso la pillola?', 'Dott. Bianchi\nOre: 9:30'),
          _card('Videochiamata con Gianni Valeri', '(Parente)\nOre: 17:30'),
          _card('Qual è il tuo livello di pressione?',
              'Dott. Bianchi\nOre: 18:00'),
        ],
      ),
      onTap: () {
        timer.cancel();
        timer = Timer(seconds, handleTimeout);
      },
    );
  }

  Future<void> handleTimeout() async {
    await http.get("http://127.0.0.1:5000/timeout");
  }
}
