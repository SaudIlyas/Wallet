
import 'package:isar/isar.dart';

part 'expense.g.dart';

@collection
class Expense {
  Id id = Isar.autoIncrement;
  final String title;
  final double amount;
  final DateTime dateTime;
  final String account;
  final String category;
  final String note;
  final bool expense;

  Expense(this.amount, this.dateTime, this.account, this.category, this.note, this.expense, {required this.title, });

}