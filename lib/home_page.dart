import 'package:flutter/material.dart';
import 'package:wallet/add_transaction.dart';
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

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(builder: (context, value, child) {
      final reversedExpenses = value.allExpense.reversed.toList();
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
                const SizedBox(
                  width: 140,
                  child: NeuBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.calendar_today_rounded),
                        Text("September")
                      ],
                    ),
                  ),
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
                                      color: Color.fromRGBO(7, 202, 222, 1),
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
                        style: TextStyle(
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
                            child: TransactionTile(
                              account: individualExpense.account,
                              amount: formatAmount(individualExpense.amount),
                              expense: individualExpense.expense,
                              title: individualExpense.title,
                              category: individualExpense.category,
                              subtitle: individualExpense.note,
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
            },
            child: const Icon(Icons.add),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    });
  }
}
