import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:product_buy_sell/provider/admin_dashboard_provider.dart';
import 'package:product_buy_sell/provider/auth_provider.dart';
import 'package:product_buy_sell/provider/language_provider.dart';
import 'package:product_buy_sell/provider/localization_provider.dart';
import 'package:product_buy_sell/provider/splash_provider.dart';
import 'package:product_buy_sell/provider/theme_provider.dart';
import 'package:product_buy_sell/screens/splash/splash_screen.dart';
import 'package:product_buy_sell/util/theme/app_theme.dart';
import 'package:provider/provider.dart';

import 'di_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBuoXOqA0x8Ehm0cDW1SI79baYTUIxdd3Q",
      appId: "1:842252732971:android:ccd63b08b13b7fe8b2b86e",
      messagingSenderId: "842252732971",
      projectId: "product-buy-sell-blockchain",
    ),
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LanguageProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AdminDashboardProvider>()),

    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      title: 'SCM SYSTEM',
      theme: Provider.of<ThemeProvider>(context).darkTheme ? AppTheme.getDarkModeTheme() : AppTheme.getLightModeTheme(),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
