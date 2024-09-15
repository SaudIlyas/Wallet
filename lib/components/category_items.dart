import 'package:flutter/material.dart';

class CategoryDropdownItems {
  static const List<DropdownMenuItem<String>> items = [
    DropdownMenuItem(
      value: '',
      child: Text('Category'),
    ),
    DropdownMenuItem(
      value: 'Food & Drink',
      child: Text('Food & Drink'),
    ),
    DropdownMenuItem(
      value: 'Transport',
      child: Text('Transport'),
    ),
    DropdownMenuItem(
      value: 'Bills & Fees',
      child: Text('Bills & Fees'),
    ),
    DropdownMenuItem(
      value: 'Entertainment',
      child: Text('Entertainment'),
    ),
    DropdownMenuItem(
      value: 'Groceries',
      child: Text('Groceries'),
    ),
    DropdownMenuItem(
      value: 'Shopping',
      child: Text('Shopping'),
    ),
    DropdownMenuItem(
      value: 'Gifts',
      child: Text('Gifts'),
    ),
    DropdownMenuItem(
      value: 'Health',
      child: Text('Health'),
    ),
    DropdownMenuItem(
      value: 'Investments',
      child: Text('Investments'),
    ),
    DropdownMenuItem(
      value: 'Loans',
      child: Text('Loans'),
    ),
    // Add more items if needed
  ];
}