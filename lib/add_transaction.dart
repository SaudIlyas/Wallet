import 'package:flutter/material.dart';
import 'package:wallet/components/buttons.dart';
import 'package:wallet/components/neu_box.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  String disp = '0';
  String result = "";

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
                        onPressed: () {},
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
                        onPressed: () {},
                        child: const Text("INCOME"),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(left: BorderSide(color: Colors.black)),
                        ),
                        child: const Text(""),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text("EXPENSE"),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(left: BorderSide(color: Colors.black)),
                        ),
                        child: const Text(""),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text("TRANSFER"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  // account and category selector
                  const Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: NeuBox(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.wallet_rounded),
                              SizedBox(
                                width: 5,
                              ),
                              Text("Account")
                            ],
                          ))),
                      SizedBox(width: 20,),
                      Expanded(
                          flex: 1,
                          child: NeuBox(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.category_rounded),
                              SizedBox(
                                width: 5,
                              ),
                              Text("Category")
                            ],
                          )))
                    ],
                  ),
                  const SizedBox(height: 17,),
                  // Add note Text box
                  const SizedBox(
                    height: 134, // Custom height
                    child: NeuBox(
                      child: TextField(
                        minLines: 4,
                        maxLines: 4,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: "Add Note"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 17,),
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
                  const SizedBox(height: 17,),
                  // Number Buttons
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: Buttons(text: "7", fun: getBtn)),
                          const SizedBox(width: 20,),
                          Expanded(child: Buttons(text: "8", fun: getBtn)),
                          const SizedBox(width: 20,),
                          Expanded(child: Buttons(text: "9", fun: getBtn)),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          Expanded(child: Buttons(text: "4", fun: getBtn)),
                          const SizedBox(width: 20,),
                          Expanded(child: Buttons(text: "5", fun: getBtn)),
                          const SizedBox(width: 20,),
                          Expanded(child: Buttons(text: "6", fun: getBtn)),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          Expanded(child: Buttons(text: "1", fun: getBtn)),
                          const SizedBox(width: 20,),
                          Expanded(child: Buttons(text: "2", fun: getBtn)),
                          const SizedBox(width: 20,),
                          Expanded(child: Buttons(text: "3", fun: getBtn)),
                        ],
                      ),
                      const SizedBox(height: 10,),
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
                                          },
                                          child: const Icon(
                                              Icons.backspace_rounded))))),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
