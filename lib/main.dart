import 'package:flutter/material.dart';

void main() {
  runApp(const PasswordManagerCompanion());
}

class PasswordManagerCompanion extends StatelessWidget {
  const PasswordManagerCompanion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Password manager companion',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const PasswordGenerator(),
    );
  }
}

class PasswordGenerator extends StatefulWidget {
  const PasswordGenerator({Key? key}) : super(key: key);

  @override
  State<PasswordGenerator> createState() => _PasswordGeneratorState();
}

class _PasswordGeneratorState extends State<PasswordGenerator> {
  String password = "";

  void generatePasswordFromSeed(int seed) {
    int sum = 0;
    for (int i = 0; i < seed.toString().length; i++) {
      sum += int.parse(seed.toString()[i]);
    }
    sum = sum * sum + seed * sum;
    sum = sum % 100000 + seed;
    sum = sum % 100000;
    setState(() {
      password = sum.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Positioned(
              right: 10,
              top: 10 + MediaQuery.of(context).padding.top,
              child: IconButton(
                  icon: const Icon(Icons.info),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Password generator"),
                        content: const Text("This app generates your password based on the seed shown on the display. The seed is the number you enter in the text field. The password will appear under the text field, and you must enter it in the password manager."),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: "Seed",
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (value.isNotEmpty && value.length > 5) {
                        if (int.tryParse(value) != null) {
                          generatePasswordFromSeed(int.parse(value));
                        } else {
                          final snackBar = SnackBar(
                            content: const Text('The seed is always a number. Please enter only numbers.'),
                            action: SnackBarAction(
                              label: 'Ok',
                              onPressed: () {},
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    },
                  ),
                ),
                Text(
                  password,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
