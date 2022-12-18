import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransaction;
  NewTransaction(this.addTransaction, {super.key});
  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  bool _selected = false;
  late DateTime _selectedDate;

  void _submitData() {
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || !_selected) {
      return;
    }

    widget.addTransaction(enteredTitle, enteredAmount, _selectedDate);

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
        setState(() {
          _selected = true;
          _selectedDate = pickedDate;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Card(
            elevation: 5,
            child: Container(
              padding: EdgeInsets.only(
                  left: 10,
                  top: 10,
                  right: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Title'),
                    controller: titleController,
                    onSubmitted: (_) => _submitData(),
                    // onChanged: (value) {
                    //   TitleInput = value;
                    // },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Amount'),
                    controller: amountController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    onSubmitted: (_) => _submitData(),
                    // onChanged: (val) {
                    //   AmountInput = val;
                    // },
                  ),
                  Container(
                    height: 70,
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(!_selected
                                ? 'No Date Chosen!'
                                : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}')),
                        TextButton(
                          onPressed: _presentDatePicker,
                          child: Text(
                            'Choose Date',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _submitData,
                    child: Text('Add Transaction'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                  )
                ],
              ),
            )));
  }
}
