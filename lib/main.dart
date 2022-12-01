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
          apiKey: 'AIzaSyC5CJz2XFXdE8d-i3aSpjxx5Tevn7BOxo8',
          appId: '1:690874350216:android:c39c2d9c936b22fa977d3d',
          messagingSenderId: '690874350216',
          projectId: 'in-search-of-truth-4390d'));
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
