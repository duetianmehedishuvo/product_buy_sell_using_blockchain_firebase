
import 'package:get_it/get_it.dart';
import 'package:product_buy_sell/data/repository/admin_dashboard_repo.dart';
import 'package:product_buy_sell/data/repository/auth_repo.dart';
import 'package:product_buy_sell/data/repository/language_repo.dart';
import 'package:product_buy_sell/data/repository/splash_repo.dart';
import 'package:product_buy_sell/provider/admin_dashboard_provider.dart';
import 'package:product_buy_sell/provider/auth_provider.dart';
import 'package:product_buy_sell/provider/language_provider.dart';
import 'package:product_buy_sell/provider/localization_provider.dart';
import 'package:product_buy_sell/provider/splash_provider.dart';
import 'package:product_buy_sell/provider/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


final sl = GetIt.instance;

Future<void> init() async {
  // Core

  // Repository
  sl.registerLazySingleton(() => LanguageRepo());
  sl.registerLazySingleton(() => AuthRepo(sharedPreferences: sl()));
  sl.registerLazySingleton(() => SplashRepo());
  sl.registerLazySingleton(() => AdminDashboardRepo());

  // Provider
  sl.registerFactory(() => ThemeProvider(sharedPreferences: sl(),splashRepo: sl()));
  sl.registerFactory(() => LocalizationProvider(sharedPreferences: sl()));
  sl.registerFactory(() => LanguageProvider(languageRepo: sl()));
  sl.registerFactory(() => AuthProvider(authRepo: sl()));
  sl.registerFactory(() => SplashProvider(splashRepo: sl()));
  sl.registerFactory(() => AdminDashboardProvider(adminDashboardRepo: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
