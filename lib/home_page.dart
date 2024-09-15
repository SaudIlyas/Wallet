import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:wallet/add_transaction.dart';
import 'package:wallet/components/date_range_picker.dart';
import 'package:wallet/components/drawer.dart';
import 'package:wallet/components/neu_box.dart';
import 'package:wallet/components/transaction_tile.dart';
import 'package:provider/provider.dart';
import 'package:wallet/database/expense_database.dart';
import 'package:wallet/helper/helper_functions.dart';
import 'package:wallet/models/expense.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? _selectedMonth;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = DateTime(now.year, now.month + 1, 0); // End of the current month

    // Load expenses data
    Provider.of<ExpenseDatabase>(context, listen: false).readExpenses();
  }

  double getTotalIncome(List<Expense> expenses) {
    return expenses
        .where((expense) => !expense.expense) // Assuming `expense` is `true` for expenses and `false` for income
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double getTotalExpenses(List<Expense> expenses) {
    return expenses
        .where((expense) => expense.expense) // Assuming `expense` is `true` for expenses and `false` for income
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  void openDeleteBox(Expense expense){
    showDialog(context: context, builder: (context)=> AlertDialog(
      title: const Text("Delete Expense"),
      content: const Text("Are you sure you want to delete this?"),
      actions: [
        _cancelButton(),
        _deleteExpenseButton(expense.id),
      ],
    ));
  }

  Widget _deleteExpenseButton(int id){
    return MaterialButton(
      onPressed: () async{
        Navigator.pop(context);

        await context.read<ExpenseDatabase>().deleteExpense(id);
      },
      child: const Text("DELETE"),
    );
  }

  Widget _cancelButton(){
    return MaterialButton(
      onPressed: (){
        Navigator.pop(context);
      },
      child: const Text("CANCEL"),
    );
  }

  void _showDateRangePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return DateRangePicker(
          initialStartDate: _startDate,
          initialEndDate: _endDate,
          onDateRangeSelected: (startDate, endDate) {
            setState(() {
              _startDate = startDate;
              _endDate = endDate;
            });
          },
        );
      },
    );
  }


  List<Expense> _filterExpensesByDateRange(List<Expense> expenses) {
    if (_startDate == null || _endDate == null) return expenses; // Handle case where no date is selected

    return expenses
        .where((expense) {
      final expenseDate = expense.dateTime;
      return expenseDate.isAfter(_startDate!) && expenseDate.isBefore(_endDate!);
    })
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime)); // Sort by date in descending order
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(builder: (context, value, child) {
      final reversedExpenses = _filterExpensesByDateRange(value.allExpense.reversed.toList());
      // final reversedExpenses = value.allExpense.reversed.toList();
      final totalIncome = getTotalIncome(reversedExpenses);
      final totalExpenses = getTotalExpenses(reversedExpenses);
      final cashflow = totalIncome - totalExpenses;

      return  Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        drawer: const MyDrawer(),
        body: CustomScrollView(
          slivers: [
            // SliverAppBar
            SliverAppBar(
              scrolledUnderElevation: 0,
              toolbarHeight: 90,
              expandedHeight: 130.0,
              floating: false,
              pinned: true,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                title: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(formatAmount(cashflow),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                      )),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: _showDateRangePicker, // Call the method to show the bottom sheet
                  icon: const Icon(Icons.calendar_today),
                ),
                Builder(builder: (context) {
                  return IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: const Icon(Icons.menu),
                  );
                })
              ],
            ),
            // Main content
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: NeuBox(
                              child: Column(
                                children: [
                                  const Row(
                                    children: [
                                      Icon(Icons.download_rounded),
                                      SizedBox(width: 10),
                                      Text("Income")
                                    ],
                                  ),
                                  Text(
                                    formatAmount(totalIncome),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(101, 107, 117, 1),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 1,
                            child: NeuBox(
                              child: Column(
                                children: [
                                  const Row(
                                    children: [
                                      Icon(Icons.upload_rounded),
                                      SizedBox(width: 10),
                                      Text("Expenses")
                                    ],
                                  ),
                                  Text(
                                    formatAmount(totalExpenses),
                                    style: const TextStyle(
                                      color: Color.fromRGBO(101, 107, 117, 1),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Cashflow: ${formatAmount(cashflow)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(49, 81, 106, 1),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      ListView.builder(
                        shrinkWrap: true, // Make sure ListView uses only the space needed
                        physics: const NeverScrollableScrollPhysics(), // Disable scrolling in this ListView
                        itemCount: reversedExpenses.length,
                        itemBuilder: (context, index) {
                          Expense individualExpense = reversedExpenses[index];
                          return Padding(
                            padding: const EdgeInsets.only(top: 16.0,),
                            child: GestureDetector(
                              onLongPress: (){
                                openDeleteBox(individualExpense);
                                HapticFeedback.mediumImpact();
                              },
                              child: TransactionTile(
                                account: individualExpense.account,
                                amount: formatAmount(individualExpense.amount),
                                expense: individualExpense.expense,
                                title: individualExpense.title,
                                category: individualExpense.category,
                                subtitle: individualExpense.note,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 100,)
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
        floatingActionButton: NeuBox(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddTransaction()),
              );
              HapticFeedback.mediumImpact();
            },
            child: const Icon(Icons.add, size: 35,),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    });
  }
}
