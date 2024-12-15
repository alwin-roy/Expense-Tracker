import 'package:expense/models/category_model.dart';
import 'package:expense/models/expense_model.dart';
import 'package:expense/models/incomeCategory_model.dart';
import 'package:expense/models/income_model.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  Box<IncomeBox>? _incomeBox;
  Box<ExpenseBox>? _expenseBox;
  Box<CategoryBox>? _categoryBox;
  Box<IncomeCategoryBox>? _incomeCategoryBox;

  Future<void> openBox() async {
    _incomeBox = await Hive.openBox<IncomeBox>('income');
    _expenseBox = await Hive.openBox<ExpenseBox>('expense');
    _categoryBox = await Hive.openBox<CategoryBox>('category');
    _incomeCategoryBox =
        await Hive.openBox<IncomeCategoryBox>('incomeCategory');
  }

  Future<void> closeBox() async {
    await _incomeBox!.close();
    await _expenseBox!.close();
    await _categoryBox!.close();
    await _incomeCategoryBox!.close();
  }

  // category box

  Future<void> addCategory(CategoryBox category) async {
    if (_categoryBox == null) {
      await openBox();
    }

    await _categoryBox!.add(category);
  }

  Future<List<CategoryBox>> getCategory() async {
    if (_categoryBox == null) {
      await openBox();
    }
    return _categoryBox!.values.toList();
  }

  // income category box

  Future<void> addIncomeCategory(IncomeCategoryBox category) async {
    if (_incomeCategoryBox == null) {
      await openBox();
    }

    await _incomeCategoryBox!.add(category);
  }

  Future<List<IncomeCategoryBox>> getIncomeCategory() async {
    if (_categoryBox == null) {
      await openBox();
    }
    return _incomeCategoryBox!.values.toList();
  }

  // expense box

  Future<void> addExpense(ExpenseBox expense) async {
    if (_expenseBox == null) {
      await openBox();
    }
    await _expenseBox!.add(expense);
  }

  Future<List<ExpenseBox>> getExpense() async {
    if (_expenseBox == null) {
      await openBox();
    }
    return _expenseBox!.values.toList();
  }

  // income box

  Future<void> addIncome(IncomeBox income) async {
    if (_incomeBox == null) {
      await openBox();
    }
    await _incomeBox!.add(income);
  }

  Future<List<IncomeBox>> getIncome() async {
    if (_incomeBox == null) {
      await openBox();
    }
    return _incomeBox!.values.toList();
  }

  // delete transaction

  Future<void> deleteTransaction(dynamic key, bool isIncome) async {
  if (_incomeBox == null || _expenseBox == null) {
    await openBox();
  }
  if (isIncome) {
    if (_incomeBox != null) {
      await _incomeBox!.deleteAt(key);
    }
  } else {
    if (_expenseBox != null) {
      await _expenseBox!.deleteAt(key);
    }
  }
}


  Future<void> clearIncome() async {
    if (_incomeBox == null) {
      await openBox();
    }

    await _incomeBox!.clear();
  }

  Future<void> clearExpense() async {
    if (_expenseBox == null) {
      await openBox();
    }
    await _expenseBox!.clear();
  }
}
