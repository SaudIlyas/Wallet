import 'package:flutter/material.dart';
import 'package:wallet/components/settings_page.dart';
import 'package:wallet/database/expense_database.dart';
import 'package:provider/provider.dart';
import 'package:wallet/home_page.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          DrawerHeader(
            child: Center(
              child: Icon(
                Icons.wallet_rounded,
                size: 40,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 25),
            child: ListTile(
              title: const Text("H O M E"),
              leading: const Icon(Icons.home_rounded),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 0),
            child: ListTile(
              title: const Text("S E T T I N G S"),
              leading: const Icon(Icons.settings),
              onTap: (){
                Navigator.pop(context);

                Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
              },
            ),
          ),

        ],
      ),
    );
  }
}
