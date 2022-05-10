import 'package:flutter/material.dart';
import 'package:ma_lab_flutter/pair.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
  List<Pair> tipsList = [
    Pair("Unlocking the wallet", "In order to unlock the wallet, you need to enter the seed that is displayed on the LCD in this app. Then, you will see a code, that you will enter using the remote in the wallet."),
    Pair("Locking the wallet", "You can lock your wallet only if you have unlocked it. You can do this by pressing the 'Play' button ('>||') on the remote."),
    Pair("Wallet modes", "The wallet has five modes: 'Locked' (mode 0), 'Unlocked' (mode 1), 'View passwords' (mode 2), 'Add passwords' (mode 3) and 'Delete passwords' (mode 3). To access all modes you need to have the wallet unlocked."),
    Pair("Adding a password", "To add a password, switch to the 'Add password' mode (mode 3) by pressing the 'CH+' button on the remote. Now, you can start typing the password that you want to store. After you're done, press the '+' button on the remote to save it in memory. To save it in EEPROM, press 'FOL+' on the remote, while in 'Add password' mode (mode 4)."),
    Pair("Deleting a password", "To delete a password, switch to the 'Delete passwords' mode (mode 3) by pressing the 'CH-' button on the remote. Press the '-' button on the remote to delete it from memory. To delete it from EEPROM, press 'FOL+' on the remote, while in 'Add password' mode (mode 4)."),
    Pair("Scrolling passwords", "To scroll through the passwords, switch to 'View passwords' mode by pressing the 'CH' button on the remote. You can now scroll through the passwords by pressing the '>>|' or '|<<' buttons on the remote."),
    Pair("Saving passwords to EEPROM", "To save the passwords to EEPROM, press 'FOL+' on the remote, while in 'add password' mode (mode 4)."),
  ];

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
    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    Widget _floatingCollapsed() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: radius,
        ),
        margin: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
        child: const Center(
          child: Text(
            "How to use",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
        ),
      );
    }

    Widget _floatingPanel() {
      return Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(24.0)), boxShadow: [
          BoxShadow(
            blurRadius: 20.0,
            color: Colors.grey,
          ),
        ]),
        margin: const EdgeInsets.all(24.0),
        child: Center(
          child: CarouselSlider(
            options: CarouselOptions(height: MediaQuery.of(context).size.height * 0.8),
            items: tipsList.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        child: Center(
                          child: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              style: TextStyle(fontFamily: "Roboto", fontSize: 16.0, color: Theme.of(context).textTheme.bodyText1!.color),
                              children: [
                                TextSpan(text: i.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                                const TextSpan(text: "\n\n"),
                                TextSpan(text: i.value),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 2,
                          height: 15,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }).toList(),
          ),
        ),
      );
    }

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
            SlidingUpPanel(
              borderRadius: radius,
              renderPanelSheet: false,
              panel: _floatingPanel(),
              collapsed: _floatingCollapsed(),
              maxHeight: MediaQuery.of(context).size.height * 0.8,
              body: Column(
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
            ),
          ],
        ),
      ),
    );
  }
}
