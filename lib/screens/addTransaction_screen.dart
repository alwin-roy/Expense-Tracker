import 'dart:math';

import 'package:expense/models/expense_model.dart';
import 'package:expense/models/income_model.dart';
import 'package:expense/screens/category_screen.dart';
import 'package:expense/screens/home_screen.dart';
import 'package:expense/screens/income_Category_screen.dart';
import 'package:expense/services/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController _expenseAmountController =
      TextEditingController();
  final TextEditingController _expensedescriptiontController =
      TextEditingController();

  final TextEditingController _incomeAmountController = TextEditingController();
  final TextEditingController _incomeDescriptionController =
      TextEditingController();

  DateTime? _pickedExpenseDate;
  DateTime? _pickedIncomeDate;

  bool loading = false;

  String _expenseCategory = '';
  String _expenseImageUrl = '';
  String _incomeCategory = '';
  String _incomeImageUrl = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild the widget when the tab changes
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double tabWidth = (MediaQuery.of(context).size.width - 32) / 2;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Transaction",style: TextStyle(
          fontSize: 20
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  left: _tabController.index == 0 ? 0 : tabWidth + 17,
                  child: Container(
                    height: 45,
                    width: tabWidth,
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent[700],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: Colors.deepPurpleAccent[700],
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    tabs: const [
                      Tab(text: 'Expense'),
                      Tab(text: 'Income'),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Expense tab
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'Add New Expense',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                              'Enter the details of your expense to help you track your spending'),
                          const SizedBox(height: 20),
                          const Text(
                            'Enter Amount',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _expenseAmountController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.currency_rupee),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Description',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _expensedescriptiontController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Category',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 65,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.white),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 5),
                                ClipOval(
                                  child: SvgPicture.asset(
                                    _expenseImageUrl.isEmpty
                                        ? 'images/placeholder.svg'
                                        : _expenseImageUrl,
                                    width: 36,
                                    height: 36,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Text(
                                    _expenseCategory.isEmpty
                                        ? 'Select Category'
                                        : _expenseCategory,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CategoryScreen(),
                                      ),
                                    );

                                    if (result != null) {
                                      setState(() {
                                        _expenseCategory = result['category'];
                                        _expenseImageUrl =
                                            result['imageUrl'];
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.navigate_next),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Date',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: TextEditingController(
                              text: _pickedExpenseDate != null
                                  ? DateFormat('MMMM d, y')
                                      .format(_pickedExpenseDate!)
                                  : '',
                            ),
                            decoration: InputDecoration(
                              hintText: DateFormat('MMMM d, y')
                                  .format(DateTime.now()),
                              filled: true,
                              suffixIcon: const Icon(Icons.calendar_today),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            readOnly: true,
                            onTap: () async {
                              _pickedExpenseDate = await _selectDate();
                              setState(() {});
                            },
                          ),
                          const SizedBox(height: 30),
                          loading
                              ? const CircularProgressIndicator()
                              : Container(
                                  height: 65,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurpleAccent[700],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: TextButton(
                                    onPressed: () async {
                                      if (_expenseAmountController.text == "" ||
                                          _expensedescriptiontController.text ==
                                              "" ||
                                          _expenseCategory == "" ||
                                          _expenseImageUrl == "") {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                padding: EdgeInsets.all(9.0),
                                                backgroundColor: Colors.red,
                                                content: Text(
                                                    'All fields are required !',
                                                    style: TextStyle(color: Colors.white),)));
                                      }
                                      
                                      else if (!_isNumeric(_expenseAmountController.text)){
                                         ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                padding: EdgeInsets.all(9.0),
                                                backgroundColor: Colors.red,
                                                content: Text(
                                                    'The amount should be a number !',
                                                    style: TextStyle(color: Colors.white),)));
                                      }
                                      
                                       else {
                                        setState(() {
                                          loading = true;
                                        });
                                        ExpenseBox expense = ExpenseBox(
                                            amount: int.parse(
                                                _expenseAmountController.text),
                                            description:
                                                _expensedescriptiontController
                                                    .text,
                                            category: _expenseCategory,
                                            date: _pickedExpenseDate ??
                                                DateTime.now(),
                                            categoryImgUrl:
                                                _expenseImageUrl);
                                        await HiveService().addExpense(expense);

                                        print(
                                            'data added successfully (expense)');
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const HomeScreen()));
                                      }
                                      setState(() {
                                        loading = false;
                                      });
                                    },
                                    child: const Text(
                                      'Add expense',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),

                  // Income tab --------------------------------------------------

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'Add New Income',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                              'Enter the details of your income to help you track your earnings'),
                          const SizedBox(height: 20),
                          const Text(
                            'Enter Amount',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _incomeAmountController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.currency_rupee),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Description',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _incomeDescriptionController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Category',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 65,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.white),
                              
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 5),
                                ClipOval(
                                  child: SvgPicture.asset(
                                    _incomeImageUrl.isEmpty
                                        ? 'images/placeholder.svg'
                                        : _incomeImageUrl,
                                    width: 36,
                                    height: 36,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Text(
                                    _incomeCategory.isEmpty
                                        ? 'Select Category'
                                        : _incomeCategory,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            IncomeCategoryScreen(),
                                      ),
                                    );

                                    if (result != null) {
                                      setState(() {
                                        _incomeCategory = result['category'];
                                        _incomeImageUrl =
                                            result['imageUrl'];
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.navigate_next),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Date',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: TextEditingController(
                              text: _pickedIncomeDate != null
                                  ? DateFormat('MMMM d, y')
                                      .format(_pickedIncomeDate!)
                                  : '',
                            ),
                            decoration: InputDecoration(
                              hintText: DateFormat('MMMM d, y')
                                  .format(DateTime.now()),
                              filled: true,
                              suffixIcon: const Icon(Icons.calendar_today),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            readOnly: true,
                            onTap: () async {
                              _pickedIncomeDate = await _selectDate();
                              setState(() {});
                            },
                          ),
                          const SizedBox(height: 30),
                          loading
                              ? const CircularProgressIndicator()
                              : Container(
                                  height: 65,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurpleAccent[700],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: TextButton(
                                    onPressed: () async {
                                      if (_incomeAmountController.text == "" ||
                                          _incomeDescriptionController.text ==
                                              "" ||
                                          _incomeCategory == "" ||
                                          _incomeImageUrl == "") {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                padding: EdgeInsets.all(9.0),
                                                backgroundColor: Colors.red,
                                                content: Text(
                                                    'All fields are required !',
                                                    style: TextStyle(
                                                      color: Colors.white
                                                    ),)));
                                      } 
                                      
                                      else if (!_isNumeric(_incomeAmountController.text)) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    behavior: SnackBarBehavior.floating,
    padding: EdgeInsets.all(9.0),
    backgroundColor: Colors.red,
    content: Text(
      'The amount should be a number !',
      style: TextStyle(color: Colors.white),
    ),
  ));
}

                                      
                                      
                                      else {
                                        setState(() {
                                          loading = true;
                                        });
                                        IncomeBox income = IncomeBox(
                                            incomeAmount: int.parse(
                                                _incomeAmountController.text),
                                            description:
                                                _incomeDescriptionController
                                                    .text,
                                            category: _incomeCategory,
                                            date: _pickedIncomeDate ??
                                                DateTime.now(),
                                            categoryImgUrl:
                                                _incomeImageUrl);
                                        await HiveService().addIncome(income);

                                        print(
                                            'data added successfully (income)');
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const HomeScreen()));
                                      }
                                      setState(() {
                                        loading = false;
                                      });
                                    },
                                    child: const Text(
                                      'Add income',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _selectDate() async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
  }

  bool _isNumeric(String str) {
  final numericRegex = RegExp(r'^\d+$');
  return numericRegex.hasMatch(str);
}
}
