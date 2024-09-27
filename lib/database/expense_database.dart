import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:wallet/models/expense.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';


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

  //Backup - create a backup of the database

  Future<void> createBackUp() async {
    final status = await Permission.storage.request();


    if(status.isGranted){
      final backupDirectory = await getBackupDirectory();

      if (backupDirectory == null) {
        // Handle the case when the user cancels the directory selection.
        return;
      }

      // final File backUpFile = File('${backUpDir.path}/backup_db.isar');
      final File backUpFile = File('${backupDirectory.path}/backup_db.isar');
      if (await backUpFile.exists()) {
        // if already we have another backup file, delete it here.
        await backUpFile.delete();
      }

      try {
        await isar.copyToFile('${backupDirectory.path}/backup_db.isar');
      } catch (e) {
        print("TRYING TO CREATE BACKUP: $e");
        print("Isar Directory: ${isar.isOpen}");
      }
    }else{
      print("Permission not granted");
      await Permission.manageExternalStorage.request();
      await Permission.storage.request();
    }
  }

  //Restore - restore a backup

  Future<void> restoreBackup() async {
    final dbDirectory = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dbDirectory.path, 'default.isar');

    final backupFile = await getBackupFile();

    if (backupFile == null) {
      // Handle the case when the user cancels the file selection
      print('Backup file selection cancelled');
      return;
    }

    if (await backupFile.exists()) {
      // Close the database before making changes
      await isar.close();

      try {
        // Overwrite the current database file with the backup file
        await backupFile.copy(dbPath);
        print('Backup restored successfully');
      } catch (e) {
        print('Error restoring backup: $e');
      } finally {
        // Reopen the database
        isar = await Isar.open([ExpenseSchema], directory: dbDirectory.path);
      }
    } else {
      print('Selected backup file does not exist');
    }
  }

  Future<Directory?> getBackupDirectory() async {
    final result = await FilePicker.platform.getDirectoryPath();

    if (result == null) {
      // User canceled the directory selection.
      return null;
    }

    return Directory(result);
  }

  Future<File?> getBackupFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        print('No file selected');
        return null;
      }

      return File(result.files.single.path!);
    } catch (e) {
      print('Error selecting file: $e');
      return null;
    }
  }

}