import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:product_buy_sell/provider/note_provider.dart';
import 'package:product_buy_sell/provider/zakat_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Repository
  // sl.registerLazySingleton(() => LocationRepo(sharedPreferences: sl()));

  // Provider

  sl.registerFactory(() => ZakatProvider());
  sl.registerFactory(() => NoteProvider());

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  sl.registerLazySingleton(() => firebaseFirestore);
}
