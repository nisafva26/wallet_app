import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet/class/users.dart';
import 'package:wallet/screens/addmoney.dart';
import 'package:wallet/screens/home.dart';
import 'package:wallet/screens/home2.dart';

import '../class/transactions.dart';

class SendMoney extends StatefulWidget {
  const SendMoney({Key? key}) : super(key: key);

  @override
  State<SendMoney> createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  double itemWidth = 60.0;
  int itemCount = 10;

  int selected = 6;
  List<Users> users = [
    Users(avatar: 'assets/user.png', name: 'Nasif', id: 0),
    Users(avatar: 'assets/user.png', name: 'Nasif', id: 1),
    Users(avatar: 'assets/user1.png', name: 'Alan', id: 2),
    Users(avatar: 'assets/user3.jpg', name: 'Jacob', id: 3),
    Users(avatar: 'assets/user4.jpg', name: 'helen', id: 4),
    Users(avatar: 'assets/user5.jpg', name: 'Nitya', id: 5),
    Users(avatar: 'assets/user1.png', name: 'Alan', id: 6),
    Users(avatar: 'assets/user3.jpg', name: 'Jacob', id: 7),
    Users(avatar: 'assets/user4.jpg', name: 'helen', id: 8),
    Users(avatar: 'assets/user5.jpg', name: 'Nitya', id: 9),
  ];

  final FixedExtentScrollController _scrollController =
      FixedExtentScrollController(initialItem: 6);

  bool backhome = false;
  bool isloading = false;

  @override
  final List<Widget> _children = [];

  Widget build(BuildContext context) {
    for (var user in users) {
      _children.add(
        RotatedBox(
            quarterTurns: 1,
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: user.id == selected ? 70 : 50,
                height: user.id == selected ? 70 : 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: user.id == selected ? Colors.red : Colors.grey,
                    shape: BoxShape.circle),
                child: Text(user.id.toString()))),
      );
    }

    print("children length :${_children.length}");
    print("user length :${users.length}");

    final transactionProvider = Provider.of<TransactionProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Send Money',
          style: GoogleFonts.lato(
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
       physics: NeverScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height-120,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
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
                ),
          
                const SizedBox(
                  height: 40.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select a person to send money',
                        style: GoogleFonts.lato(
                            fontSize: 20.0, fontWeight: FontWeight.w800),
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.info,
                            color: Colors.grey,
                          ),
                          Text('swipe to select')
                        ],
                      )
                    ],
                  ),
                ),
                
                //function call
          
                buildSwipePerson(),
          
                const Spacer(flex: 1,),
                
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                        
                                
                        
                                int? value = prefs.getInt('balance') ?? 0;
                        
                                //checking wallet balance
                        
                                if (int.parse(myController.text) > value) {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0))),
                                      title: const Text(
                                        "Sorry!",
                                      ),
                                      content: const Text(
                                        "You dont have enough money for this transaction",
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const AddMoney()));
                                            },
                                            child: Container(
                                              color: Colors.black,
                                              child: const Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'Add Money',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    isloading = true;
                                  });
                                  await Future.delayed(const Duration(seconds: 3),
                                      () {
                                    prefs
                                        .setInt('balance',
                                            value - int.parse(myController.text))
                                        .then((value) {
                        
                                          transactionProvider.addtolist(DateTime.now(),users[selected].name,double.parse(myController.text),true,false,users[selected].avatar,'Expense');
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0))),
                                          title: const Text(
                                            "Transaction success",
                                          ),
                                          content: Text(
                                            "Your money has been send to ${users[selected].name.toUpperCase()}",
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
                                                  style:
                                                      TextStyle(color: Colors.black),
                                                )),
                                          ],
                                        ),
                                      );
                                      setState(() {
                                        isloading = false;
                                      });
                        
                                      Future.delayed(const Duration(seconds: 3), () {
                                        setState(() {
                                          backhome = true;
                                          //isloading = false;
                                        });
                                        myController.clear();
                                      });
                                    });
                                  });
                                }
                              }
                            },
                            child: Container(
                              color: Colors.black,
                              child: Center(
                                  child: Padding(
                                      padding: const EdgeInsets.all(11.0),
                                      child: isloading == false
                                          ? Text(
                                              'Send Money',
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
                    ),
                  ),
                ),
               // const Spacer(flex: 1,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox buildSwipePerson() {
    return SizedBox(
      height: 140.0,
      child: RotatedBox(
        quarterTurns: -1,
        child: ListWheelScrollView(
          magnification: 10.0,
          onSelectedItemChanged: (x) {
            setState(() {
              selected = x;
            });
            print(selected);

            print("selected id");

            // print(users[selected].id);
          },
          controller: _scrollController,
          itemExtent: itemWidth,
          children: List.generate(
              users.length,
              (x) => RotatedBox(
                  quarterTurns: 1,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        width: x == selected ? 80 : 50,
                        height: x == selected ? 80 : 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            boxShadow: [
                              x == selected
                                  ? BoxShadow(
                                      color: Colors.grey.withOpacity(0.8),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: const Offset(
                                          0, 2), // changes position of shadow
                                    )
                                  : BoxShadow(
                                      color: Colors.white.withOpacity(0.8),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: const Offset(0, 2),
                                    )
                            ],
                            image: DecorationImage(
                              image: AssetImage(users[x].avatar),
                              fit: BoxFit.contain,
                            ),

                            // color: x == selected ? Colors.red : Colors.grey,
                            shape: BoxShape.circle),
                        // child: Image.asset(users[x].avatar)
                      ),
                      if (x == selected) Text(users[x].name)
                    ],
                  ))),
        ),
      ),
    );
  }
}
