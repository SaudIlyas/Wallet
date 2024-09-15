import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallet/components/account_items.dart';
import 'package:wallet/components/buttons.dart';
import 'package:wallet/components/category_items.dart';
import 'package:wallet/components/neu_box.dart';
import 'package:wallet/database/expense_database.dart';
import 'package:wallet/helper/helper_functions.dart';
import 'package:wallet/models/expense.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  Future<void> createNewExpense() async {
    if (_accountController.text.isEmpty ||
        _categoryController.text.isEmpty ||
        _titleController.text.isEmpty ||
        disp.isEmpty) {
      // Show an error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      Expense newExpense = Expense(
        convertStringToDouble(disp),
        DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        ),
        _accountController.text,
        _categoryController.text,
        _noteController.text,
        exp,
        title: _titleController.text,
      );

      await context.read<ExpenseDatabase>().createANewExpense(newExpense);

      // Clear text fields after saving
      _accountController.clear();
      _categoryController.clear();
      _titleController.clear();
      _noteController.clear();
      disp = "0";

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense added successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  String disp = '0';
  String result = "";
  bool exp = true;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    void getBtn(String btnVal) {
      if (btnVal == 'C') {
        disp = '';
        result = '';
      } else {
        result = int.parse(disp + btnVal).toString();
      }
      setState(() {
        disp = result;
      });
    }

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != _selectedDate) {
        setState(() {
          _selectedDate = picked;
        });
      }
    }

    Future<void> _selectTime(BuildContext context) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: _selectedTime,
      );
      if (picked != null && picked != _selectedTime) {
        setState(() {
          _selectedTime = picked;
        });
      }
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  // cancel and save buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.close_rounded),
                            SizedBox(
                              width: 4,
                            ),
                            Text("CANCEL")
                          ],
                        ),
                      ),
                      MaterialButton(
                        onPressed: () async {
                          await createNewExpense();

                          // Navigator.pop(context);
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.check_rounded),
                            SizedBox(
                              width: 4,
                            ),
                            Text("SAVE")
                          ],
                        ),
                      )
                    ],
                  ),
                  // income expense and transfer selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                            textStyle: !exp
                                ? const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 20,
                                  )
                                : const TextStyle(
                                    fontWeight: FontWeight.normal)),
                        onPressed: () {
                          setState(() {
                            exp = false;
                          });
                        },
                        child: const Text("INCOME"),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(left: BorderSide(color: Colors.black)),
                        ),
                        child: const Text(""),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            textStyle: exp
                                ? const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 20,
                                  )
                                : const TextStyle(
                                    fontWeight: FontWeight.normal)),
                        onPressed: () {
                          setState(() {
                            exp = true;
                          });
                        },
                        child: const Text("EXPENSE"),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // account and category selector
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: NeuBox(
                            child: DropdownButtonFormField<String>(
                              dropdownColor:
                              Theme.of(context).colorScheme.surface,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                icon: Icon(Icons.wallet_rounded),
                              ),
                              value: '',
                              items: AccountDropdownItems.items,
                              onChanged: (value) =>
                                  _accountController.text = value!,
                            ),
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          flex: 1,
                          child: NeuBox(
                            child: DropdownButtonFormField<String>(
                              dropdownColor:
                              Theme.of(context).colorScheme.surface,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                icon: Icon(Icons.category_rounded),
                              ),
                              value: '',
                              items: CategoryDropdownItems.items,
                              onChanged: (value) =>
                                  _categoryController.text = value!,
                              style: TextStyle(fontSize: MediaQuery.sizeOf(context).width*0.032, color: Colors.black),
                            //   dropdownMenuTheme: DropdownMenuThemeData(
                            //     textStyle: TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  // Add title Text box
                  SizedBox(
                    height: 45,
                    child: NeuBox(
                      child: TextField(
                        controller: _titleController,
                        minLines: 1,
                        maxLines: 1,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: "Add Title"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  // Add note Text box
                  SizedBox(
                    height: 85, // Custom height
                    child: NeuBox(
                      child: TextField(
                        controller: _noteController,
                        minLines: 2,
                        maxLines: 2,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: "Add Note"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  // Amount field
                  SizedBox(
                    width: double.infinity,
                    child: NeuBox(
                      child: Align(
                        alignment: const Alignment(1, 0),
                        child: Text(
                          maxLines: 1,
                          disp,
                          style: const TextStyle(
                              fontSize: 48, color: Color(0xffacacac)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  // Number Buttons
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: Buttons(text: "7", fun: getBtn)),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(child: Buttons(text: "8", fun: getBtn)),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(child: Buttons(text: "9", fun: getBtn)),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(child: Buttons(text: "4", fun: getBtn)),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(child: Buttons(text: "5", fun: getBtn)),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(child: Buttons(text: "6", fun: getBtn)),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(child: Buttons(text: "1", fun: getBtn)),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(child: Buttons(text: "2", fun: getBtn)),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(child: Buttons(text: "3", fun: getBtn)),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(child: Buttons(text: "0", fun: getBtn)),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(child: Buttons(text: "C", fun: getBtn)),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: SizedBox(
                                  height: 60,
                                  child: NeuBox(
                                      child: GestureDetector(
                                          onTap: () {
                                            result = result.substring(
                                                0, result.length - 1);
                                            setState(() {
                                              disp = result;
                                            });
                                            HapticFeedback.mediumImpact();
                                          },
                                          child: const Icon(
                                              Icons.backspace_rounded))))),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  // Date and Time Picker
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            _selectDate(context);
                            HapticFeedback.mediumImpact();
                          },
                          child: NeuBox(
                            child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Icon(Icons.calendar_today_rounded),
                                  const SizedBox(width: 5,),
                                  Text('Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',),
                                ],
                              ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            _selectTime(context);
                            HapticFeedback.mediumImpact();
                          },
                          child: NeuBox(
                            child: Row(
                              children: [
                                const Icon(Icons.access_time_filled_rounded),
                                const SizedBox(width: 5,),
                                Text('Time: ${_selectedTime.format(context)}'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
