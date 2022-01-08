import 'package:flutter/material.dart';
import 'profile.dart';

void main() => runApp(const Popup());

/// This is the main application widget.
class Popup extends StatelessWidget {
  const Popup({Key? key}) : super(key: key);

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
        body: const Center(
          child: MyPopup(),
        ),
      ),
    );
  }
}

/// This is the stateless widget that the main application instantiates.
class MyPopup extends StatelessWidget {
  const MyPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Notifica'),
          content: const Text('Hai preso la pillola?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Si'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('No'),
            ),
            IconButton(
              onPressed: () => Navigator.pop(context, 'Keyboard voice'),
              icon: const Icon(Icons.mic_none_sharp, color: Colors.blue),
            ),
          ],
        ),
      ),
      child: const Text('Mostra prova notifica'),
    );
  }
}
