// Convert String to a Double
import 'package:intl/intl.dart';
import 'package:wallet/models/wallet_preferences.dart';

double convertStringToDouble(String string) {
  double? amount = double.tryParse(string);
  return amount ?? 0;
}

String formatAmount(double amount) {
  final code = WalletPreferences.currency.code;
  final format = NumberFormat.currency(
    locale: 'en',
    name: code,
    symbol: '$code ',
  );
  return format.format(amount);
}
