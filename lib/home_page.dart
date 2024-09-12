import 'package:flutter/material.dart';
import 'package:wallet/add_transaction.dart';
import 'package:wallet/components/drawer.dart';
import 'package:wallet/components/neu_box.dart';
import 'package:wallet/components/transaction_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: const MyDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              scrolledUnderElevation: 0,
              toolbarHeight: 90,
              expandedHeight: 130.0,
              floating: false,
              pinned: true,
              automaticallyImplyLeading: false,
              flexibleSpace: const FlexibleSpaceBar(
                  title: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text("PKR 770.00",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0,
                        )),
                  ),
                  ),
              actions: [
                const SizedBox(width: 140,child: NeuBox(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Icon(Icons.calendar_today_rounded),Text("September")],))),
                Builder(builder: (context) {
                  return IconButton(onPressed: () => Scaffold.of(context).openDrawer(),
                        icon: const Icon(Icons.menu));
                })
              ],
            ),
          ];
        },
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 20),
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
                              Row(
                                children: [Icon(Icons.download_rounded), SizedBox(width: 10,), Text("Income")],
                              ),
                              Text("PKR 1000", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.greenAccent),)
                            ],
                          ),
                        ),
                      ),
                    SizedBox(width: 20,),
                    Expanded(
                        flex: 1,
                        child: NeuBox(
                          child: Column(
                            children: [
                              Row(
                                children: [Icon(Icons.upload_rounded), SizedBox(width: 10,), Text("Expenses")],
                              ),
                              Text("PKR 230", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 10,),
                Text("Cashflow: +770 PKR", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),),
                SizedBox(height: 10,),
                Divider(),
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: TransactionTile(account: "Cash", amount: "230", expense: true, title: "Food", category: "Food & Drinks", subtitle: "Food",),
                ),
              ],
            ),
          ),
        )
      ),
      floatingActionButton: NeuBox(child: GestureDetector(onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => const AddTransaction())); } ,child: Icon(Icons.add))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Future _displayBottomSheet(BuildContext context) {
  //   return showModalBottomSheet(context: context, builder: (context) => Column(
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           TextButton(onPressed: (){},child: const Text("Income"),),
  //           Container(decoration: const BoxDecoration(
  //             border: Border(left: BorderSide(color: Colors.black)),
  //           ),child: const Text(""),),
  //           TextButton(onPressed: (){},child: const Text("Expense"),),
  //           Container(decoration: const BoxDecoration(
  //             border: Border(left: BorderSide(color: Colors.black)),
  //           ),child: const Text(""),),
  //           TextButton(onPressed: (){},child: const Text("Transfer"),),
  //         ],
  //       ),
  //
  //     ],
  //   ));
  // }
}
