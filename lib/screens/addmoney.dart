import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet/class/transactions.dart';
import 'package:wallet/screens/home.dart';
import 'package:wallet/screens/home2.dart';

class AddMoney extends StatefulWidget {
  const AddMoney({Key? key}) : super(key: key);

  @override
  State<AddMoney> createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();

  bool backhome = false;
  bool isloading = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Add Money',
          style: GoogleFonts.lato(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 20),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: myController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      hintText: 'Enter Amount'),
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isloading = true;
                          });

                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          // await Future.delayed(Duration(seconds: 3), () {});

                          int? value = prefs.getInt('balance') ?? 0;

                          await Future.delayed(Duration(seconds: 3), () {
                            prefs
                                .setInt('balance',
                                    int.parse(myController.text) + value)
                                .then((value) {
                              transactionProvider.addtolist(DateTime.now(),'Added to Wallet',double.parse(myController.text),false,true,'assets/user.png','Income');
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0))),
                                  title: const Text(
                                    "Transaction success",
                                   
                                  ),
                                  content: const Text(
                                    "Your money has been added to wallet",
                                    
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Home2()));
                                        },
                                        child: const Text(
                                          'Back To Home',
                                          style: TextStyle(color: Colors.black),
                                        )),
                                  ],
                                ),
                              );

                              setState(() {
                                isloading = false;
                              });

                              Future.delayed(Duration(seconds: 3), () {
                                setState(() {
                                  backhome = true;
                                  
                                });
                                myController.clear();
                              });
                            });
                          });
                        }
                      },
                      child: Container(
                        color: Colors.black,
                        child: Center(
                            child: Padding(
                                padding: const EdgeInsets.all(11.0),
                                child: isloading == false
                                    ? Text(
                                        'Add Money',
                                        style: GoogleFonts.lato(
                                            color: Colors.white,
                                            fontSize: 15.0),
                                      )
                                    : const CircularProgressIndicator(
                                      strokeWidth: 1,
                                        color: Colors.white,
                                      ))),
                      )),
                  if (backhome == true)
                    const SizedBox(
                      height: 10.0,
                    ),
                  if (backhome == true)
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home2()));
                      },
                      child: Container(
                        color: Colors.black,
                        child: Center(
                            child: Padding(
                                padding: const EdgeInsets.all(11.0),
                                child: Text(
                                  'Back to Home',
                                  style: GoogleFonts.lato(
                                      color: Colors.white, fontSize: 15.0),
                                ))),
                      ),
                    ),
                ],
              )
            ]),
      ),
    );
  }
}
