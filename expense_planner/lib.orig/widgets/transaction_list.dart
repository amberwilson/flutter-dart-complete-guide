import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteHandler;

  const TransactionList({Key key, this.transactions, this.deleteHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: transactions.isEmpty
          ? Column(children: [
              Text('No transactions added yet!',
                  style: Theme.of(context).textTheme.bodyText1),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 200,
                child:
                    Image.asset('assets/images/waiting.png', fit: BoxFit.cover),
              )
            ])
          : ListView.builder(
              itemBuilder: (ctx, index) {
                final tx = transactions[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Padding(
                        padding: EdgeInsets.all(3),
                        child: FittedBox(
                          child: Text(
                            '\$${tx.amount.toStringAsFixed(2)}',
                          ),
                        ),
                      ),
                    ),
                    title: Text(tx.title),
                    subtitle: Text(
                      DateFormat.yMd().format(tx.date),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteHandler(tx.id);
                      },
                    ),
                  ),
                );
              },
              itemCount: transactions.length,
            ),
    );
  }
}
