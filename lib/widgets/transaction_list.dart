import './transaction_item.dart';
import 'package:flutter/material.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;

  const TransactionList(this.transactions, this.deleteTransaction, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: transactions.isEmpty
            ? LayoutBuilder(builder: (ctx, constraint) {
                return Column(
                  children: [
                    const Text("No transactions added yet!",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(
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
                  return TransactionItem(
                      transactions[index], deleteTransaction);
                },
              ));
  }
}
