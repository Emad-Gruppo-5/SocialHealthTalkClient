// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';

void main() => runApp(const ProfiloFamiliareModifica());

/// This is the main application widget.
class ProfiloFamiliareModifica extends StatelessWidget {
  const ProfiloFamiliareModifica({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: Icon(Icons.arrow_back_ios_sharp),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          title: const Center(
            child: Text("Modifica dati"),
          ),
        ),
        body: const SingleChildScrollView(child: MyModifyProfile()),
      ),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyModifyProfile extends StatefulWidget {
  const MyModifyProfile({Key? key}) : super(key: key);

  @override
  State<MyModifyProfile> createState() => _MyModifyProfile();
}

// This is the stateless widget that the main application instantiates.
class _MyModifyProfile extends State<MyModifyProfile> {
  List<bool> isChecked = [false, true, false];
  List<Person> persons1 = [];

  @override
  void initState() {
    //adding item to list, you can add using json from network
    persons1.add(Person(id:"1", name:"Paziente 1", phone:"1111111111"));
    persons1.add(Person(id:"2", name:"Paziente 2", phone:"22222222222"));
    persons1.add(Person(id:"3", name:"Paziente 3", phone:"33333333333"));

    super.initState();
  }

  Widget _textFormField(
      IconData icon, String labelText, String initialValue, String validator) {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(icon),
        labelText: labelText,
      ),
      initialValue: initialValue,
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validator;
        }
        return null;
      },
    );
  }

  Widget _form() {
    final _formKey = GlobalKey<FormState>();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _textFormField(Icons.smartphone, "Numero di cellulare",
                "+39 331 313 3141", "Inserisci numero di cellulare"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _textFormField(Icons.email, "E-mail", "mariorossi@gmail.com",
                "Inserisci e-mail"),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              "Pazienti associati",
              style: TextStyle(fontSize: 15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: persons1.map((personone){
                return Container(
                  child: Card(
                    child:ListTile(
                      title: Text(personone.name),
                      subtitle: Text(personone.phone),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue
                        ),
                        child: Icon(Icons.delete),
                        onPressed: (){
                          //delete action for this button
                          persons1.removeWhere((element){
                            return element.id == personone.id;
                          }); //go through the loop and match content to delete from list
                          setState(() {
                            //refresh UI after deleting element from list
                          });
                        },
                      ),
                    ),
                  ),

                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:ElevatedButton(
              onPressed: () {
                //TODO
              },
              child: const Text('Aggiungi paziente'),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid
                  }
                },
                child: const Text('Salva'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkboxListTile(String text, int index) {
    return CheckboxListTile(
      title: Text(text),
      contentPadding: const EdgeInsets.symmetric(horizontal: 100),
      value: isChecked[index],
      onChanged: (bool? value) {
        setState(() {
          isChecked[index] = value!;
        });
      },
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
        _form(),
      ],
    );
  }
}

class Person{ //modal class for Person object
  String id, name, phone;
  Person({required this.id, required this.name, required this.phone});
}