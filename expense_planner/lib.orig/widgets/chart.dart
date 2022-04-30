import 'package:flutter/material.dart';

import '../models/dayTransactionsTotal.dart';
import '../models/transaction.dart';
import '../widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  final Map<int, String> days = const {
    0: 'M',
    1: 'T',
    2: 'W',
    3: 'T',
    4: 'F',
    5: 'S',
    6: 'S',
  };
  double get totalAmount =>
      groupedTransactionValues.fold(0.0, (sum, item) => sum + item.amount);

  Chart({this.recentTransactions});

  List<DayTransactionsTotal> get groupedTransactionValues {
    return List.generate(7, (index) {
      final dayAmount = recentTransactions
          .where((tx) => tx.date.weekday == index)
          .fold(0.0, (sum, element) {
        return sum + element.amount;
      });

      return DayTransactionsTotal(day: days[index], amount: dayAmount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: groupedTransactionValues
              .map(
                (day) => Flexible(
                  fit: FlexFit.tight,
                  child: ChartBar(
                    label: day.day,
                    spendingAmount: day.amount,
                    spendingPercentage:
                        totalAmount == 0.0 ? 0.0 : day.amount / totalAmount,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
