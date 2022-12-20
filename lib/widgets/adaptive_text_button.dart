import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveButton extends StatelessWidget {
  final VoidCallback presentDatePicker;
  const AdaptiveButton(this.presentDatePicker, {super.key});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            onPressed: presentDatePicker,
            child: const Text(
              'Choose Date',
              style: TextStyle(fontWeight: FontWeight.bold),
            ))
        : TextButton(
            onPressed: presentDatePicker,
            child: const Text(
              'Choose Date',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
  }
}
