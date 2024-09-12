import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/home_page.dart';
import 'package:wallet/theme/theme_provider.dart';



  void main() async {
    WidgetsFlutterBinding.ensureInitialized();

    try {
      if (kIsWeb) {
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyBTFoCJdPIH-mT3m5AMEVSpaNdf1gf1Nyo",
            authDomain: "wallet-87a1b.firebaseapp.com",
            projectId: "wallet-87a1b",
            storageBucket: "wallet-87a1b.appspot.com",
            messagingSenderId: "54221728808",
            appId: "1:54221728808:web:caf7dab43c2176e1f9591d",
            measurementId: "G-FKP29BM72M",
          ),
        );
      } else {
        await Firebase.initializeApp(); // For Android/iOS
      }
      runApp(ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const MyApp(),
      ));
    } catch (e) {
      print('Error initializing Firebase: $e');
      runApp(ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const MyApp(),
      ));
    }
  }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
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
      home: const HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData ,
    );
  }
}
