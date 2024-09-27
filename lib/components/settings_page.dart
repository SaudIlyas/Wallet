import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wallet/components/drawer.dart';
import 'package:wallet/database/expense_database.dart';
import 'package:wallet/theme/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: const Text("Settings"),),
      drawer: const MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text("Personalization", style: TextStyle(fontSize: 17),),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12)
            ),
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Dark Mode", style: TextStyle(fontWeight: FontWeight.bold),),
                CupertinoSwitch(
                    value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
                    onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme()
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text("Backup & Restore", style: TextStyle(fontSize: 17),),
          ),
          GestureDetector(
            onTap: ()async{
              try{
                await context.read<ExpenseDatabase>().createBackUp();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Backup created successfully')),
                );
              }catch(e){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
              HapticFeedback.mediumImpact();
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12)
              ),
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(25.0),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Create Backup", style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: ()async{
              try{
                await context.read<ExpenseDatabase>().restoreBackup();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Backup restored successfully')),
                );
              }catch(e){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
              HapticFeedback.mediumImpact();
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12)
              ),
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Restore Backup", style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
