import 'package:flutter/material.dart';
import 'package:wallet/models/wallet_preferences.dart';

class CategoryDropdownItems {
  static List<DropdownMenuItem<String>> get items => [
    const DropdownMenuItem(value: '', child: Text('Category')),
    for (final category in WalletPreferences.categories)
      DropdownMenuItem(
        value: category,
        child: Text(category, overflow: TextOverflow.ellipsis),
      ),
  ];
}
