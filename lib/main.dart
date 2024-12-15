import 'package:expense/models/category_model.dart';
import 'package:expense/models/expense_model.dart';
import 'package:expense/models/incomeCategory_model.dart';
import 'package:expense/models/income_model.dart';
import 'package:expense/screens/home_screen.dart';
import 'package:expense/services/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive/hive.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);




  await Hive.initFlutter();
  Hive.registerAdapter(IncomeBoxAdapter());
  Hive.registerAdapter(ExpenseBoxAdapter());
  Hive.registerAdapter(CategoryBoxAdapter());
  Hive.registerAdapter(IncomeCategoryBoxAdapter());

  await HiveService().openBox();


  await Future.delayed(const Duration(seconds: 1));

  FlutterNativeSplash.remove();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xpense',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: HomeScreen(),
    );
  }
}
