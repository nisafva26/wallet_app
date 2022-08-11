import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Transactions {
  String id;
  String name;
  double amount;
  bool send;
  bool add;
  String image;
  String chartname;

  Transactions(
      {required this.id,
      required this.name,
      required this.amount,
      required this.send,
      required this.add,
      required this.image,
      required this.chartname});
}

class Chartsync {
  String name;
  double amount;

  Chartsync({required this.name, required this.amount});
}

class TransactionProvider extends ChangeNotifier {
  final List<Transactions> _transactions = [];

  List<Transactions> get transactions {
    return [..._transactions];
  }

  final List<Chartsync> _chart = [Chartsync(name: 'Income', amount: 0),
  Chartsync(name: 'Expense', amount: 0)];

  List<Chartsync> get chart {
    return [..._chart];
  }

  void addtolist(DateTime id, String name, double amount, bool send, bool add,
      String image, String chartname) {
    _transactions.insert(
        0,
        Transactions(
            id: id.toString(),
            name: name,
            amount: amount,
            send: send,
            add: add,
            image: image,
            chartname: chartname));

    // ignore: iterable_contains_unrelated_type
    if (_chart.any((element) => element.name=='Income'||element.name=='Expense')) {

      print("containes ${chartname}");
      double income = _chart[0].amount;
      double expense = _chart[1].amount;

      if (chartname == "Income") {
        income = income + amount;
        _chart[0].amount = income;
      }else{
        expense = expense + amount;
        _chart[1].amount = expense;
      }
    } 

    notifyListeners();
  }
}
