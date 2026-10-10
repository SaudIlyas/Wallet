import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WalletCurrency {
  const WalletCurrency(this.code, this.name);
  final String code;
  final String name;
}

class WalletPreferences {
  static const currencies = [
    WalletCurrency('PKR', 'Pakistani Rupee'),
    WalletCurrency('USD', 'US Dollar'),
    WalletCurrency('EUR', 'Euro'),
    WalletCurrency('GBP', 'British Pound'),
    WalletCurrency('CAD', 'Canadian Dollar'),
    WalletCurrency('AUD', 'Australian Dollar'),
    WalletCurrency('NZD', 'New Zealand Dollar'),
    WalletCurrency('AED', 'UAE Dirham'),
    WalletCurrency('SAR', 'Saudi Riyal'),
    WalletCurrency('QAR', 'Qatari Riyal'),
    WalletCurrency('KWD', 'Kuwaiti Dinar'),
    WalletCurrency('BHD', 'Bahraini Dinar'),
    WalletCurrency('OMR', 'Omani Rial'),
    WalletCurrency('INR', 'Indian Rupee'),
    WalletCurrency('BDT', 'Bangladeshi Taka'),
    WalletCurrency('LKR', 'Sri Lankan Rupee'),
    WalletCurrency('NPR', 'Nepalese Rupee'),
    WalletCurrency('CNY', 'Chinese Yuan'),
    WalletCurrency('JPY', 'Japanese Yen'),
    WalletCurrency('KRW', 'South Korean Won'),
    WalletCurrency('SGD', 'Singapore Dollar'),
    WalletCurrency('HKD', 'Hong Kong Dollar'),
    WalletCurrency('MYR', 'Malaysian Ringgit'),
    WalletCurrency('IDR', 'Indonesian Rupiah'),
    WalletCurrency('PHP', 'Philippine Peso'),
    WalletCurrency('THB', 'Thai Baht'),
    WalletCurrency('VND', 'Vietnamese Dong'),
    WalletCurrency('TRY', 'Turkish Lira'),
    WalletCurrency('CHF', 'Swiss Franc'),
    WalletCurrency('SEK', 'Swedish Krona'),
    WalletCurrency('NOK', 'Norwegian Krone'),
    WalletCurrency('DKK', 'Danish Krone'),
    WalletCurrency('PLN', 'Polish Zloty'),
    WalletCurrency('ZAR', 'South African Rand'),
    WalletCurrency('EGP', 'Egyptian Pound'),
    WalletCurrency('NGN', 'Nigerian Naira'),
    WalletCurrency('KES', 'Kenyan Shilling'),
    WalletCurrency('BRL', 'Brazilian Real'),
    WalletCurrency('MXN', 'Mexican Peso'),
  ];

  static const defaultCategories = [
    'Food & Drink',
    'Transport',
    'Bills & Fees',
    'Entertainment',
    'Groceries',
    'Shopping',
    'Gifts',
    'Health',
    'Investments',
    'Loans',
  ];
  static const suggestedCategories = [
    ...defaultCategories,
    'Sports',
    'Music',
    'Technology',
    'Travel',
  ];
  static WalletCurrency currency = currencies.first;
  static List<String> categories = List.unmodifiable(defaultCategories);

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('walletPreferences');
    if (saved == null) return;
    try {
      final data = jsonDecode(saved) as Map<String, dynamic>;
      currency = currencies.firstWhere(
        (item) => item.code == data['currency'],
        orElse: () => currencies.first,
      );
      final savedCategories = (data['categories'] as List)
          .cast<String>()
          .where((item) => item.trim().isNotEmpty)
          .toSet()
          .toList();
      if (savedCategories.isNotEmpty)
        categories = List.unmodifiable(savedCategories);
    } on FormatException {
      // Retain defaults for malformed preferences.
    } on TypeError {
      // Retain defaults for preferences with an unexpected structure.
    }
  }

  static Future<void> saveSetup(
    WalletCurrency selectedCurrency,
    List<String> selectedCategories,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = await prefs.setString(
      'walletPreferences',
      jsonEncode({
        'currency': selectedCurrency.code,
        'categories': selectedCategories,
      }),
    );
    if (!saved)
      throw StateError('Could not save your preferences. Please retry.');
    if (!await prefs.setBool('firstTime', false)) {
      throw StateError('Could not finish setup. Please retry.');
    }
    currency = selectedCurrency;
    categories = List.unmodifiable(selectedCategories);
  }
}
