import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet/database/expense_database.dart';
import 'package:wallet/first_setup.dart';
import 'package:wallet/home_page.dart';
import 'package:wallet/theme/theme_provider.dart';
import 'package:wallet/welcome_screen.dart';



  void main() async {
    WidgetsFlutterBinding.ensureInitialized();

    await ExpenseDatabase.initialize();

      runApp(
        // ChangeNotifierProvider(create: (context) => ThemeProvider(), child: const MyApp(),)
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => ThemeProvider(),),
            ChangeNotifierProvider(create: (context) => ExpenseDatabase(),),
          ],
          child: const MyApp(),
        )
      );
  }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  bool firstTime = true;

  @override
  void initState() {
    super.initState();
    // Call your function here
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      firstTime = prefs.getBool('firstTime') ?? true;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallet',
      // theme: ThemeData(
      //   // This is the theme of your application.
      //   //
      //   // TRY THIS: Try running your application with "flutter run". You'll see
      //   // the application has a purple toolbar. Then, without quitting the app,
      //   // try changing the seedColor in the colorScheme below to Colors.green
      //   // and then invoke "hot reload" (save your changes or press the "hot
      //   // reload" button in a Flutter-supported IDE, or press "r" if you used
      //   // the command line to start the app).
      //   //
      //   // Notice that the counter didn't reset back to zero; the application
      //   // state is not lost during the reload. To reset the state, use hot
      //   // restart instead.
      //   //
      //   // This works for code too, not just values: Most code changes can be
      //   // tested with just a hot reload.
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      //   useMaterial3: true,
      // ),
      home: const WelcomeScreen(),
      // home: firstTime ? const WelcomeScreen() : const HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData ,
    );
  }
}
