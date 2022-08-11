import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wallet/screens/analytics.dart';
import 'package:wallet/screens/send.dart';

import '../class/transactions.dart';
import 'addmoney.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Home2 extends StatefulWidget {
  const Home2({Key? key}) : super(key: key);

  @override
  State<Home2> createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  late int balance = 0;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    fetch();
    _tooltipBehavior = TooltipBehavior(enable: true);

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
    final mediaQueryData = MediaQuery.of(context);

    final size = mediaQueryData.size;
    final transactionProvider =
        Provider.of<TransactionProvider>(context, listen: true);

    List<Transactions> transaction = transactionProvider.transactions;

    List<Chartsync> chart = transactionProvider.chart;
    return Scaffold(
      body: Column(children: [
        Container(
          height: MediaQuery.of(context).size.height / 2.2,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.2,
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0))),
                ),
              ),
              Positioned(
                  top: size.height * .05,
                  left: size.width*.025,
                  child: Row(children: [
                    const CircleAvatar(
                        backgroundImage: AssetImage('assets/user.png')
                        //backgroundColor: Colors.white,
                        ),
                    const SizedBox(
                      width: 15.0,
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
                  top: size.height*.17,
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
                        'Rs ${balance}',
                        style: GoogleFonts.lato(
                            fontSize: 25.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(
                        height: 40.0,
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
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
            child: ListView(
              children: buildtransactionlist(transaction, chart),
            ),
          ),
        )
      ]),
    );
  }

  List<Widget> buildtransactionlist(
      List<Transactions> transaction, List<Chartsync> chart) {
    List<Widget> list = [];

    if (transaction.isNotEmpty) {
      /* list.add(Text(
        'Analytics',
        style: GoogleFonts.lato(fontSize: 19, fontWeight: FontWeight.w800),
      ),);
      */

      list.add(Card(
          elevation: 5.0,
          child: Hero(
            tag: 'chart',
            child: GestureDetector(
              onTap: () {
                //Navigator.push(context, MaterialPageRoute(builder: ((context) => const Analytics())));
              },
              child: SfCircularChart(
                  tooltipBehavior: _tooltipBehavior,
                  title: ChartTitle(
                      text: 'Analytics',
                      textStyle: const TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.w700)),
                  legend: Legend(isVisible: true),
                  series: <CircularSeries>[
                    // Renders doughnut chart
                    PieSeries<Chartsync, String>(
                        dataSource: chart,
                        //pointColorMapper: (Transactions data, _) => data.color,
                        xValueMapper: (chart, _) => chart.name.toString(),
                        yValueMapper: (chart, _) => chart.amount,
                        enableTooltip: true,
                        dataLabelSettings: const DataLabelSettings(
                            // Renders the data label
                            isVisible: true))
                  ]),
            ),
          )));
    }

    list.add(
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Text(
          'Your Transactions',
          style: GoogleFonts.lato(fontSize: 19, fontWeight: FontWeight.w800),
        ),
      ),
    );

    list.add(
      const SizedBox(
        height: 10.0,
      ),
    );

    if (transaction.isEmpty) {
      list.add(Container(
        height: 60.0,
        width: MediaQuery.of(context).size.width - 20,
        decoration: BoxDecoration(
            color: Colors.black54, borderRadius: BorderRadius.circular(10.0)),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('You havent done any transactions yet',
              style: GoogleFonts.lato(color: Colors.white)),
        )),
      ));
    } else {
      for (int i = 0; i < transaction.length; i++) {
        list.add(Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Card(
            elevation: 4.0,
            child: ListTile(
                isThreeLine: true,
                leading: CircleAvatar(
                    backgroundImage: AssetImage(transaction[i].image)),
                title: Text(
                  transaction[i].name.toString(),
                  style: GoogleFonts.lato(
                      fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Transaction ID: ${transaction[i].id}',
                  style: GoogleFonts.lato(
                    fontSize: 13.0,
                  ),
                ),
                trailing: transaction[i].add == true
                    ? Text(
                        '+${transaction[i].amount}',
                        style: const TextStyle(color: Colors.green),
                      )
                    : Text(
                        '-${transaction[i].amount}',
                        style: const TextStyle(color: Colors.red),
                      )),
          ),
        ));
      }
    }

    return list;
  }
}
