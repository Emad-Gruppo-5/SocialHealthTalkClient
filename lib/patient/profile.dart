import 'package:flutter/material.dart';
import '../main.dart';
import 'modify_profile.dart';


/// This is the main application widget.
class Profile extends StatefulWidget {

  final String nome;
  final String cognome;
  final String email;
  final int num_cellulare;
  final int tipologia_chat;
  final String cod_fiscale;

  const Profile({required this.cod_fiscale, required this.nome, required this.cognome, required this.email, required this.num_cellulare, required this.tipologia_chat });

  @override
  _Profile createState() => _Profile();

}


class _Profile extends State<Profile> {
  late String nome;
  late String cognome;
  late String email;
  late int num_cellulare;
  late int tipologia_chat;
  late String cod_fiscale;

  @override
  void initState() {
    nome = widget.nome;
    cognome = widget.cognome;
    email = widget.email;
    num_cellulare = widget.num_cellulare;
    tipologia_chat = widget.tipologia_chat;
    cod_fiscale = widget.cod_fiscale;
    super.initState();
  }

  

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
            _iconButtonPush(context, Icons.logout, 'Logout', MyApp()),
          ],
        ),
        body: Column(
      children: [
        Text(
          "$nome $cognome",
          style: TextStyle(fontSize: 50),
        ),
        _card("$cod_fiscale", Icons.person),
        _card("$num_cellulare", Icons.smartphone),
        _card("$email", Icons.email),
        const Text("\nTipologia chat"),
        _checkboxListTile("Solo testo", tipologia_chat==0 ? true : false),
        _checkboxListTile("Videochiamata", tipologia_chat==1 ? true : false),
        _checkboxListTile("Chiamata vocale", tipologia_chat==2 ? true : false),
      ],
      ),
      ),
    );
  }

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


}


  // @override
  // Widget build(BuildContext context) {
  //   return Column(
  //     children: [
  //       const Text(
  //         " ",
  //         style: TextStyle(fontSize: 50),
  //       ),
  //       _card("SMLLNEXIXISI", Icons.person),
  //       _card("+39 331 313 3141", Icons.smartphone),
  //       _card("mariorossi@gmail.com", Icons.email),
  //       const Text("\nTipologia chat"),
  //       _checkboxListTile("Solo testo", false),
  //       _checkboxListTile("Videochiamata", true),
  //       _checkboxListTile("Chiamata vocale", false),
  //     ],
  //   );
  // }
