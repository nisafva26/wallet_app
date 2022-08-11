import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../class/transactions.dart';

class Analytics extends StatefulWidget {

  
  const Analytics({Key? key}) : super(key: key);

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  
  @override
  Widget build(BuildContext context) {
    final transactionProvider =
        Provider.of<TransactionProvider>(context, listen: true);

    List<Transactions> transaction = transactionProvider.transactions;

    List<Chartsync> chart = transactionProvider.chart;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Analytics',style: GoogleFonts.lato(color: Colors.black),),
      ),
      body: Column(children: [
        Hero(
            tag: 'chart',
            child: SfCircularChart(
                
                legend: Legend(isVisible: true),
                series: <CircularSeries>[
                  // Renders doughnut chart
                  PieSeries<Chartsync, String>(
                      dataSource: chart,
                      //pointColorMapper: (Transactions data, _) => data.color,
                      xValueMapper: (chart, _) => chart.name.toString(),
                      yValueMapper: (chart, _) => chart.amount,
                      dataLabelSettings: const DataLabelSettings(
                          // Renders the data label
                          isVisible: true))
                ]),
          )
      ]),
    );
  }
}
