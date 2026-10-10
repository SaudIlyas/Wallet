import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:wallet/database/expense_database.dart';
import 'package:wallet/models/expense.dart';

class BackupPicker extends FilePicker {
  String? destination;
  FilePickerResult? selection;
  bool failSave = false;

  @override
  Future<String?> saveFile({
    String? dialogTitle,
    String? fileName,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Uint8List? bytes,
    bool lockParentWindow = false,
  }) async {
    if (failSave) throw const FileSystemException('Save failed');
    return destination;
  }

  @override
  Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    bool allowCompression = true,
    int compressionQuality = 30,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
    bool lockParentWindow = false,
    bool readSequential = false,
  }) async => selection;

  void select(File file) {
    selection = FilePickerResult([
      PlatformFile(
        name: 'backup.isar',
        path: file.path,
        size: file.lengthSync(),
      ),
    ]);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory directory;
  late ExpenseDatabase database;
  late BackupPicker picker;

  setUpAll(() async {
    final configFile = File('.dart_tool/package_config.json').absolute;
    final config = jsonDecode(await configFile.readAsString()) as Map;
    final package = (config['packages'] as List).cast<Map>().singleWhere(
      (entry) => entry['name'] == 'isar_community_flutter_libs',
    );
    final root = configFile.uri.resolve('${package['rootUri']}/');
    final library = Platform.isWindows
        ? 'windows/libisar.dll'
        : Platform.isMacOS
        ? 'macos/libisar.dylib'
        : 'linux/libisar.so';
    await Isar.initializeIsarCore(
      libraries: {Abi.current(): root.resolve(library).toFilePath()},
    );
  });

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('wallet_backup_test_');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (_) async => directory.path,
        );
    picker = BackupPicker();
    FilePicker.platform = picker;
    ExpenseDatabase.isar = await Isar.open(
      [ExpenseSchema],
      directory: directory.path,
      inspector: false,
    );
    database = ExpenseDatabase();
    await database.createANewExpense(
      Expense(
        42,
        DateTime(2026, 1, 1),
        'Cash',
        'Food',
        'Original',
        true,
        title: 'Original expense',
      ),
    );
  });

  tearDown(() async {
    await ExpenseDatabase.isar.close();
    database.dispose();
    await directory.delete(recursive: true);
  });

  test('backup round trip preserves IDs and refreshes expenses', () async {
    final originalId = database.allExpense.single.id;
    final backup = File('${directory.path}/export.isar');
    picker.destination = backup.path;
    expect(await database.createBackUp(), isTrue);
    expect(await backup.length(), greaterThan(0));
    await database.deleteExpense(originalId);
    picker.select(backup);
    expect(await database.restoreBackup(), isTrue);
    expect(database.allExpense.single.id, originalId);
    expect(database.allExpense.single.title, 'Original expense');
  });

  test('cancelling either picker leaves data unchanged', () async {
    expect(await database.createBackUp(), isFalse);
    expect(await database.restoreBackup(), isFalse);
    expect(database.allExpense.single.title, 'Original expense');
  });

  test('invalid backup does not replace existing expenses', () async {
    final invalid = File('${directory.path}/invalid.isar');
    await invalid.writeAsString('This is not an Isar database.');
    picker.select(invalid);
    await expectLater(database.restoreBackup(), throwsA(anything));
    expect(ExpenseDatabase.isar.isOpen, isTrue);
    await database.readExpenses();
    expect(database.allExpense.single.title, 'Original expense');
  });

  test('save failures propagate and allow a subsequent retry', () async {
    picker.failSave = true;
    await expectLater(
      database.createBackUp(),
      throwsA(isA<FileSystemException>()),
    );
    picker.failSave = false;
    expect(await database.createBackUp(), isFalse);
    expect(database.allExpense.single.title, 'Original expense');
  });
}
