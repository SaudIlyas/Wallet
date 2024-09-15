import 'package:flutter/material.dart';

class AccountDropdownItems {
  static const List<DropdownMenuItem<String>> items = [
    DropdownMenuItem(
      value: '',
      child: Text('Account'),
    ),
    DropdownMenuItem(
      value: 'Cash',
      child: Text('Cash'),
    ),
    DropdownMenuItem(
      value: 'Card',
      child: Text('Card'),
    ),
    // Add more items if needed
  ];
}