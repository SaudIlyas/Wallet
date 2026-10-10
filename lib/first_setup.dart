import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wallet/components/neu_box.dart';
import 'package:wallet/database/expense_database.dart';
import 'package:wallet/home_page.dart';
import 'package:wallet/models/wallet_preferences.dart';

class FirstSetup extends StatefulWidget {
  const FirstSetup({super.key});

  @override
  State<FirstSetup> createState() => _FirstSetupState();
}

class _FirstSetupState extends State<FirstSetup> {
  final _pageController = PageController();
  final _searchController = TextEditingController();
  final _categoryController = TextEditingController();
  late WalletCurrency _currency;
  late List<String> _categories;
  late Set<String> _selectedCategories;
  String? _categoryError;
  bool _saving = false;
  bool _restoring = false;

  @override
  void initState() {
    super.initState();
    _currency = WalletPreferences.currency;
    _categories = {
      ...WalletPreferences.suggestedCategories,
      ...WalletPreferences.categories,
    }.toList();
    _selectedCategories = WalletPreferences.categories.toSet();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _nextPage() {
    FocusScope.of(context).unfocus();
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _addCategory() {
    final name = _categoryController.text.trim().replaceAll(
      RegExp(r'\s+'),
      ' ',
    );
    if (name.isEmpty) {
      setState(() => _categoryError = 'Enter a category name.');
      return;
    }
    if (_categories.any((item) => item.toLowerCase() == name.toLowerCase())) {
      setState(
        () => _categoryError = 'This category already exists in the list.',
      );
      return;
    }
    setState(() {
      _categories.insert(0, name);
      _selectedCategories.add(name);
      _categoryError = null;
      _categoryController.clear();
    });
    FocusScope.of(context).unfocus();
  }

  Future<void> _restoreBackup() async {
    if (_restoring) return;
    setState(() => _restoring = true);
    try {
      final restored = await context.read<ExpenseDatabase>().restoreBackup();
      if (!mounted || !restored) return;
      // Retain categories used by the imported expenses as setup options.
      final imported = context
          .read<ExpenseDatabase>()
          .allExpense
          .map((expense) => expense.category.trim())
          .where((category) => category.isNotEmpty);
      setState(() {
        for (final category in imported) {
          final existing = _categories.where(
            (item) => item.toLowerCase() == category.toLowerCase(),
          );
          if (existing.isEmpty) {
            _categories.add(category);
            _selectedCategories.add(category);
          } else {
            _selectedCategories.add(existing.first);
          }
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Backup restored successfully')),
      );
      _nextPage();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not restore backup: $error')),
      );
    } finally {
      if (mounted) setState(() => _restoring = false);
    }
  }

  Future<void> _finish() async {
    if (_saving) return;
    if (_categoryController.text.trim().isNotEmpty) {
      setState(
        () => _categoryError =
            'Tap Add Category or clear this field before finishing.',
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_categoryError!)));
      return;
    }
    if (_selectedCategories.isEmpty) {
      setState(() => _categoryError = 'Select or add at least one category.');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_categoryError!)));
      return;
    }
    setState(() => _saving = true);
    try {
      await WalletPreferences.saveSetup(
        _currency,
        _categories.where(_selectedCategories.contains).toList(),
      );
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()),
        (_) => false,
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not finish setup: $error')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _saving || _restoring
              ? null
              : () => Navigator.of(context).pop(),
        ),
        title: SmoothPageIndicator(
          controller: _pageController,
          count: 3,
          effect: ExpandingDotsEffect(
            activeDotColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: AbsorbPointer(
          absorbing: _saving || _restoring,
          child: PageView(
            controller: _pageController,
            onPageChanged: (_) => FocusScope.of(context).unfocus(),
            children: [
              _buildImportStep(),
              _buildCurrencyStep(),
              _buildCategoryStep(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _button(String label, VoidCallback? onPressed) {
    return SizedBox(
      width: double.infinity,
      child: NeuBox(
        child: TextButton(
          onPressed: onPressed,
          child: Text(label, style: const TextStyle(fontSize: 17)),
        ),
      ),
    );
  }

  Widget _buildImportStep() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Import backup file',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        Image.asset('assets/Images/backup_outlined.png', height: 170),
        const SizedBox(height: 24),
        const Text('You can always import your data later from Settings.'),
        const SizedBox(height: 32),
        _button(_restoring ? 'Restoring...' : 'Import Backup', _restoreBackup),
        const SizedBox(height: 24),
        _button('Continue without importing', _nextPage),
      ],
    );
  }

  Widget _buildCurrencyStep() {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = WalletPreferences.currencies
        .where(
          (currency) =>
              currency.code.toLowerCase().contains(query) ||
              currency.name.toLowerCase().contains(query),
        )
        .toList();
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Set Currency',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text('Selected: ${_currency.code} - ${_currency.name}'),
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search currency name or code',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No matching currencies'))
                : ListView.builder(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final currency = filtered[index];
                      final selected = currency.code == _currency.code;
                      return ListTile(
                        title: Text(currency.name),
                        subtitle: Text(currency.code),
                        selected: selected,
                        selectedTileColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        trailing: Icon(
                          selected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                        ),
                        onTap: () => setState(() => _currency = currency),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 12),
          _button('Set ${_currency.code}', _nextPage),
        ],
      ),
    );
  }

  Widget _buildCategoryStep() {
    return ListView(
      padding: const EdgeInsets.all(20),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        const Text(
          'Set Categories',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          'Select the categories you want (${_selectedCategories.length} selected):',
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _categoryController,
          maxLength: 40,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.done,
          onChanged: (_) => setState(() => _categoryError = null),
          onSubmitted: (_) => _addCategory(),
          decoration: InputDecoration(
            labelText: 'Add a new category',
            hintText: 'For example, Pet care',
            border: const OutlineInputBorder(),
            errorText: _categoryError,
            errorMaxLines: 2,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.icon(
            onPressed: _categoryController.text.trim().isEmpty
                ? null
                : _addCategory,
            icon: const Icon(Icons.add),
            label: const Text('Add Category'),
          ),
        ),
        const SizedBox(height: 16),
        for (final category in _categories)
          Card(
            child: CheckboxListTile(
              title: Text(category),
              value: _selectedCategories.contains(category),
              controlAffinity: ListTileControlAffinity.trailing,
              onChanged: (selected) => setState(() {
                if (selected == true) {
                  _selectedCategories.add(category);
                } else {
                  _selectedCategories.remove(category);
                }
                _categoryError = null;
              }),
            ),
          ),
        const SizedBox(height: 20),
        _button(_saving ? 'Saving...' : 'Finish', _finish),
        const SizedBox(height: 12),
      ],
    );
  }
}
