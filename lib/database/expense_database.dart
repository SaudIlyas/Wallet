import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:isar_community/isar.dart';
import 'package:wallet/models/expense.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ExpenseDatabase extends ChangeNotifier {
  static late Isar isar;

  bool _backupInProgress = false;

  final List<Expense> _allExpenses = [];

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

  // Returns false when the user cancels. Errors are passed to the caller.
  Future<bool> createBackUp() async {
    _beginBackupOperation();
    Directory? temporaryDirectory;
    try {
      final temporaryRoot = await getTemporaryDirectory();
      temporaryDirectory = await temporaryRoot.createTemp('wallet_backup_');
      final snapshot = File(p.join(temporaryDirectory.path, 'backup.isar'));
      await isar.copyToFile(snapshot.path);
      final bytes = await snapshot.readAsBytes();
      final destination = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Wallet backup',
        fileName: 'wallet_backup_${DateTime.now().millisecondsSinceEpoch}.isar',
        type: FileType.any,
        bytes: bytes,
      );
      if (destination == null) return false;

      // Mobile pickers write the supplied bytes through the document provider.
      // Desktop pickers only return the selected filesystem path.
      if (!Platform.isAndroid && !Platform.isIOS) {
        await File(destination).writeAsBytes(bytes, flush: true);
      }
      return true;
    } finally {
      await _cleanTemporaryDirectory(temporaryDirectory);
      _backupInProgress = false;
    }
  }

  Future<bool> restoreBackup() async {
    _beginBackupOperation();
    Directory? temporaryDirectory;
    Isar? backupDatabase;
    try {
      final backupFile = await getBackupFile();
      if (backupFile == null) return false;
      await _validateBackupHeader(backupFile);

      final temporaryRoot = await getTemporaryDirectory();
      temporaryDirectory = await temporaryRoot.createTemp('wallet_restore_');
      final validationName =
          'wallet_restore_${DateTime.now().microsecondsSinceEpoch}';
      await backupFile.copy(
        p.join(temporaryDirectory.path, '$validationName.isar'),
      );

      // Open and validate a disposable copy, never the user's original backup.
      backupDatabase = await Isar.open(
        [ExpenseSchema],
        directory: temporaryDirectory.path,
        name: validationName,
        inspector: false,
      );
      final restoredExpenses = await backupDatabase.expenses.where().findAll();
      await backupDatabase.close();
      backupDatabase = null;

      // Wallet stores its database content in the Expense collection. Replace
      // it atomically: Isar rolls back both operations if either one fails.
      // The live database remains open throughout, and expense IDs are retained.
      await isar.writeTxn(() async {
        await isar.expenses.clear();
        await isar.expenses.putAll(restoredExpenses);
      });
      await readExpenses();
      return true;
    } finally {
      try {
        if (backupDatabase != null && backupDatabase.isOpen) {
          await backupDatabase.close();
        }
      } finally {
        await _cleanTemporaryDirectory(temporaryDirectory);
        _backupInProgress = false;
      }
    }
  }

  void _beginBackupOperation() {
    if (_backupInProgress) {
      throw StateError('A backup or restore is already in progress.');
    }
    _backupInProgress = true;
  }

  Future<void> _validateBackupHeader(File file) async {
    // MDBX can initialize short/non-database files as empty databases. Reject
    // them before opening. Its 56-bit magic is stable across Isar 3 versions;
    // Isar itself checks the separate format-version byte and database pages.
    if (!await file.exists() || await file.length() < 1536) {
      throw const FormatException(
        'The selected file is not a valid Isar backup.',
      );
    }
    final handle = await file.open();
    try {
      final header = await handle.read(64);
      const signature = [0x11, 0x4c, 0xef, 0xbd, 0x9d, 0x65, 0x59];
      for (
        var offset = 0;
        offset <= header.length - signature.length;
        offset++
      ) {
        var matches = true;
        for (var i = 0; i < signature.length; i++) {
          if (header[offset + i] != signature[i]) matches = false;
        }
        if (matches) return;
      }
      throw const FormatException(
        'The selected file is not a valid Isar backup.',
      );
    } finally {
      await handle.close();
    }
  }

  Future<void> _cleanTemporaryDirectory(Directory? directory) async {
    if (directory == null) return;
    try {
      if (await directory.exists()) await directory.delete(recursive: true);
    } on FileSystemException catch (error) {
      // A cleanup failure must not turn a completed backup into a false failure.
      debugPrint('Could not remove temporary backup files: $error');
    }
  }

  Future<File?> getBackupFile() async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Select a Wallet backup (.isar)',
      allowMultiple: false,
      type: FileType.any,
    );
    if (result == null || result.files.isEmpty) return null;
    final selected = result.files.single;
    if (p.extension(selected.name).toLowerCase() != '.isar') {
      throw const FormatException('Please select a Wallet .isar backup file.');
    }
    final path = selected.path;
    if (path == null || path.isEmpty) {
      throw const FileSystemException('The selected backup cannot be opened.');
    }
    return File(path);
  }
}
