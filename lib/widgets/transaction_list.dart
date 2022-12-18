import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;

  TransactionList(this.transactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: transactions.isEmpty
            ? LayoutBuilder(builder: (ctx, constraint) {
                return Column(
                  children: [
                    Text("No transactions added yet!",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: constraint.maxHeight * 0.6,
                      child: Image.asset("assets/images/waiting.png",
                          fit: BoxFit.cover),
                    )
                  ],
                );
              })
            : ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (ctx, index) {
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: Padding(
                            padding: EdgeInsets.all(6),
                            child: FittedBox(
                                child:
                                    Text('\$${transactions[index].amount}'))),
                      ),
                      title: Text(
                        transactions[index].title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Text(
                          DateFormat.yMMMd().format(transactions[index].date)),
                      trailing: MediaQuery.of(context).size.width > 450
                          ? TextButton.icon(
                              onPressed: () =>
                                  deleteTransaction(transactions[index].id),
                              icon: Icon(
                                Icons.delete,
                                color: Theme.of(context).errorColor,
                              ),
                              label: Text(
                                "Delete",
                                style: TextStyle(
                                    color: Theme.of(context).errorColor),
                              ),
                            )
                          : IconButton(
                              onPressed: () =>
                                  deleteTransaction(transactions[index].id),
                              icon: Icon(Icons.delete),
                              color: Theme.of(context).errorColor,
                            ),
                    ),
                  );
                },
              ));
  }
}
