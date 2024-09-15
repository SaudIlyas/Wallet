import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:wallet/models/expense.dart';
import 'package:path_provider/path_provider.dart';

class ExpenseDatabase extends ChangeNotifier{

  static late Isar isar;

  List<Expense> _allExpenses = [];

  // initialize db

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ExpenseSchema], directory: dir.path);
  }

  // get all expenses

  List<Expense> get allExpense => _allExpenses;

  //Create - add a new expense

  Future<void> createANewExpense(Expense newExpense) async {
    await isar.writeTxn(() => isar.expenses.put(newExpense));

    await readExpenses();
  }

  //Read - get all expenses

  Future<void> readExpenses() async {
    //get
    List<Expense> fetchedExpenses = await isar.expenses.where().findAll();
    //update list
    _allExpenses.clear();
    _allExpenses.addAll(fetchedExpenses);
    print('Expenses fetched: $fetchedExpenses');
    //update UI
    notifyListeners();
  }

  //Update - edit an existing expense

  Future<void> updateExpense(int id, Expense updatedExpense) async {
    updatedExpense.id = id;

    await isar.writeTxn(() => isar.expenses.put(updatedExpense));

    await readExpenses();
  }

  //Delete - remove an existing expense

  Future<void> deleteExpense(int id) async {
    await isar.writeTxn(() => isar.expenses.delete(id));

    await readExpenses();
  }
}