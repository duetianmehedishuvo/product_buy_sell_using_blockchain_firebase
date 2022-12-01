import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:product_buy_sell/notes_navigation.dart';
import 'package:product_buy_sell/provider/note_provider.dart';
import 'package:product_buy_sell/provider/zakat_provider.dart';

import 'di_container.dart' as di;

//! Test a particualar file.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBuoXOqA0x8Ehm0cDW1SI79baYTUIxdd3Q",
      appId: "1:842252732971:android:ccd63b08b13b7fe8b2b86e",
      messagingSenderId: "842252732971",
      projectId: "product-buy-sell-blockchain",
    ),
  );
  await di.init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<ZakatProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<NoteProvider>()),
    ],
    child: const Noter(),
  ));
}

class Noter extends StatelessWidget {
  const Noter({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IN SEARCH OF TRUTH',
      home: NestNotes(),
    );
  }
}
