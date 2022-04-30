import 'package:flutter/material.dart';

class DayTransactionsTotal {
  final String day;
  final double amount;

  DayTransactionsTotal({@required this.day, @required this.amount});

  @override
  String toString() {
    return "day: ${day}, amount: ${amount}";
  }
}
