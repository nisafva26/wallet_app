import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wallet/class/transactions.dart';
import 'package:wallet/screens/addmoney.dart';
import 'package:wallet/screens/send.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int balance = 0;
  @override
  void initState() {
    fetch();

    super.initState();
  }

  void fetch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int value = prefs.getInt('balance') ?? 0;

    setState(() {
      balance = value;
    });
    print(
      'balance :${balance}',
    );

    if (balance == 0) {
      prefs.setInt('balance', balance);
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider =
        Provider.of<TransactionProvider>(context, listen: true);

    List<Transactions> transaction = transactionProvider.transactions;

    print(transaction.length);
    // print(transaction[0]);
    return Scaffold(
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.1,
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0))),
                )),
            Positioned(
                top: 50.0.h,
                left: 25.0.w,
                child: Row(children: [
                  const CircleAvatar(
                      backgroundImage: AssetImage('assets/user.png')
                      //backgroundColor: Colors.white,
                      ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello',
                        style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                color: Colors.white, fontSize: 12.0)),
                      ),
                      const SizedBox(
                        height: 6.0,
                      ),
                      Text(
                        'Nisaf',
                        style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                color: Colors.white, fontSize: 16.0)),
                      )
                    ],
                  )
                ])),
            Positioned(
                top: 160.h,
                // left: MediaQuery.of(context).size.width / 2.4,
                child: Column(
                  children: [
                    Text(
                      'Balance',
                      style: GoogleFonts.lato(
                          fontSize: 14.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Rs $balance',
                      style: GoogleFonts.lato(
                          fontSize: 25.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(
                      height: 60.0,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AddMoney()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Add Money',
                                  style: GoogleFonts.lato(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SendMoney()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Send Money',
                                  style: GoogleFonts.lato(),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                )),
                
            Positioned(
              top: MediaQuery.of(context).size.height / 2,
              left: 1.0,
              right: 0,
              bottom: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Transactions',
                      style: GoogleFonts.lato(
                          fontSize: 19, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(
                      height: 7.0,
                    ),
                    transaction.isEmpty
                        ? Container(
                            height: 60.0,
                            width: MediaQuery.of(context).size.width - 20,
                            decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  'You havent done any transactions yet',
                                  style: GoogleFonts.lato(color: Colors.white)),
                            )),
                          )
                        : Expanded(
                            child: Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: Container(
                                child: ListView.builder(
                                  
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: transaction.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        decoration:  BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          
                                        ),
                                        child: Card(
                                          
                                          
                                          elevation: 4.0,
                                          child: ListTile(
                                            isThreeLine: true,
                                              leading: CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      transaction[index]
                                                          .image)),
                                              title: Text(transaction[index]
                                                  .name
                                                  .toString()),
                                              subtitle: Text(
                                                  'Transaction ID: ${transaction[index].id}'),
                                              trailing: transaction[index]
                                                          .add ==
                                                      true
                                                  ? Text(
                                                      '+${transaction[index]
                                                              .amount}',
                                                      style: const TextStyle(
                                                          color: Colors.green),
                                                    )
                                                  : Text(
                                                      '-${transaction[index]
                                                              .amount}',
                                                      style: const TextStyle(
                                                          color: Colors.red),
                                                    )),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 10.0,)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
