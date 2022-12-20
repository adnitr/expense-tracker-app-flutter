import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './models/transaction.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          errorColor: Colors.red,
          fontFamily: 'Quicksand',
          appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold))),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class AppbarTop extends StatelessWidget implements PreferredSizeWidget {
  final Function startAddNewTransaction;
  const AppbarTop(this.startAddNewTransaction, {super.key});

  Widget _buildCupertinoNavBar(BuildContext context) {
    return CupertinoNavigationBar(
      middle: const Text("Expense Tracker"),
      trailing: Row(children: [
        GestureDetector(
          child: const Icon(CupertinoIcons.add),
          onTap: () => startAddNewTransaction(context),
        )
      ]),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        "Expense Tracker",
      ),
      actions: [
        IconButton(
            onPressed: () => startAddNewTransaction(context),
            icon: const Icon(Icons.add))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? _buildCupertinoNavBar(context)
        : _buildAppBar(context);
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    Transaction(
        id: 't1', title: 'New Shoes', amount: 49.99, date: DateTime.now()),
    Transaction(
        id: 't2', title: 'Udemy Course', amount: 10.99, date: DateTime.now()),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
        id: const Uuid().v1(),
        title: txTitle,
        amount: txAmount,
        date: chosenDate);

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  void _startAddNewTransaction(ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: NewTransaction(_addNewTransaction),
          );
        });
  }

  List<Widget> _buildLandscapeContent(MediaQueryData mediaQuery, var appBar) {
    return [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text(
          "Show Chart",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            })
      ]),
      _showChart
          ? Container(
              width: double.infinity,
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransactions),
            )
          : Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  1,
              child: TransactionList(_userTransactions, _deleteTransaction)),
    ];
  }

  List<Widget> _buildPortraitContent(MediaQueryData mediaQuery, var appBar) {
    return [
      Container(
        width: double.infinity,
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransactions),
      ),
      Container(
          height: (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
              0.7,
          child: TransactionList(_userTransactions, _deleteTransaction))
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppbarTop(_startAddNewTransaction);

    final pageBody = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isLandscape) ..._buildLandscapeContent(mediaQuery, appBar),
          if (!isLandscape) ..._buildPortraitContent(mediaQuery, appBar)
        ],
      ),
    ));

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar as ObstructingPreferredSizeWidget,
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
