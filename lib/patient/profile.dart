import 'package:flutter/material.dart';
import '../main.dart';
import 'modify_profile.dart';

/// This is the main application widget.
class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

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
          leading: _iconButtonPop(context, Icons.arrow_back, 'Indietro'),
          title: const Center(
            child: Text("Profilo"),
          ),
          actions: [
            _iconButtonPush(
                context, Icons.edit, 'Modifica', const ModifyProfile()),
            _iconButtonPush(context, Icons.logout, 'Logout', const MyApp()),
          ],
        ),
        body: const Center(
          child: MyProfile(),
        ),
      ),
    );
  }
}

// This is the stateless widget that the main application instantiates.
class MyProfile extends StatelessWidget {
  const MyProfile({Key? key}) : super(key: key);

  Widget _card(String title, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
      ),
    );
  }

  Widget _checkboxListTile(String text, bool value) {
    return CheckboxListTile(
      title: Text(text),
      contentPadding: const EdgeInsets.symmetric(horizontal: 100),
      value: value,
      onChanged: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Mario Rossi",
          style: TextStyle(fontSize: 50),
        ),
        _card("SMLLNEXIXISI", Icons.person),
        _card("+39 331 313 3141", Icons.smartphone),
        _card("mariorossi@gmail.com", Icons.email),
        const Text("\nTipologia chat"),
        _checkboxListTile("Solo testo", false),
        _checkboxListTile("Videochiamata", true),
        _checkboxListTile("Chiamata vocale", false),
      ],
    );
  }
}
