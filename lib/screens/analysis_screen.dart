
import 'package:expense/screens/allTransaction_screen.dart';
import 'package:expense/services/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  DateTime _currentDate = DateTime.now();

  void _goToPreviousMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month - 1);
      loadCategories(); // Reload categories when month changes
    });
  }

  void _goToNextMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + 1);
      loadCategories(); // Reload categories when month changes
    });
  }

  List<dynamic> categories = [];
  int totalIncome = 0;
  int totalExpense = 0;
  bool loading = true;
  Map<String, int> incomeCategoryTotals = {};
  Map<String, int> expenseCategoryTotals = {};

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    setState(() {
      loading = true;
    });

    final income = await HiveService().getIncome();
    final expense = await HiveService().getExpense();

    setState(() {
      // Filter transactions for the current month
      final filteredIncome = income.where((item) =>
          item.date.year == _currentDate.year &&
          item.date.month == _currentDate.month).toList();
      final filteredExpense = expense.where((item) =>
          item.date.year == _currentDate.year &&
          item.date.month == _currentDate.month).toList();

      // Combine filtered income and expense
      categories = [...filteredIncome, ...filteredExpense];

      // Sort categories by date in descending order
      categories.sort((a, b) => b.date.compareTo(a.date));

      // Calculate total income and expense for the current month
      totalIncome = filteredIncome.fold(0, (sum, item) => sum + item.incomeAmount);
      totalExpense = filteredExpense.fold(0, (sum, item) => sum + item.amount);

      // Calculate totals for each income and expense category
      incomeCategoryTotals = {};
      for (var item in filteredIncome) {
        incomeCategoryTotals[item.category] = (incomeCategoryTotals[item.category] ?? 0) + item.incomeAmount;
      }

      expenseCategoryTotals = {};
      for (var item in filteredExpense) {
        expenseCategoryTotals[item.category] = (expenseCategoryTotals[item.category] ?? 0) + item.amount;
      }

      loading = false;
    });
  }

  List<PieChartSectionData> getTotalIncomeExpenseSections() {
    final total = totalIncome + totalExpense;
    if (total == 0) {
      return [];
    }

    final incomePercentage = totalIncome / total * 100;
    final expensePercentage = totalExpense / total * 100;

    return [
      PieChartSectionData(
        color: Colors.green,
        value: incomePercentage,
        title: '${incomePercentage.toStringAsFixed(1)}%',
        radius: 50,
      ),
      PieChartSectionData(
        color: Colors.red,
        value: expensePercentage,
        title: '${expensePercentage.toStringAsFixed(1)}%',
        radius: 50,
      ),
    ];
  }

  List<PieChartSectionData> getCategorySections(Map<String, int> categoryTotals) {
    final total = categoryTotals.values.fold(0, (sum, value) => sum + value);
    if (total == 0) {
      return [];
    }

    return categoryTotals.entries.map((entry) {
      final percentage = (entry.value / total) * 100;
      return PieChartSectionData(
        color: Colors.primaries[categoryTotals.keys.toList().indexOf(entry.key) % Colors.primaries.length],
        value: percentage,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 50,
      );
    }).toList();
  }

  Widget buildLegend(Map<String, int> categoryTotals) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: categoryTotals.keys.map((category) {
        final color = Colors.primaries[categoryTotals.keys.toList().indexOf(category) % Colors.primaries.length];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                color: color,
              ),
              const SizedBox(width: 8),
              Text('$category: \$${categoryTotals[category]}'),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ANALYSIS",style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: _goToPreviousMonth,
                    icon: Icon(Icons.chevron_left),
                  ),
                  Spacer(),
                  Text(DateFormat.yMMMM().format(_currentDate)),
                  Spacer(),
                  IconButton(
                    onPressed: _goToNextMonth,
                    icon: Icon(Icons.chevron_right),
                  ),
                ],
              ),
              if (loading)
                Center(child: CircularProgressIndicator())
              else if (categories.isEmpty)
                Center(child: Text("No transactions for this month"))
              else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 130,
                      width: 175,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.red,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '\$$totalExpense',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Spend so far',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 130,
                      width: 175,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.green,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '\$$totalIncome',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Income',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  height: 50,
                  width: 125,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(32)),
                    color: Colors.grey[300],
                  ),
                  child: Text(
                    'Balance: \$${totalIncome - totalExpense}',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Income vs Expense',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sections: getTotalIncomeExpenseSections(),
                              centerSpaceRadius: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Income Categories',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sections: getCategorySections(incomeCategoryTotals),
                              centerSpaceRadius: 40,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        buildLegend(incomeCategoryTotals),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Expense Categories',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sections: getCategorySections(expenseCategoryTotals),
                              centerSpaceRadius: 40,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        buildLegend(expenseCategoryTotals),
                      ],
                    ),
                  ),
                ),

                Container(
  width: MediaQuery.of(context).size.width,
  child: Card(
    elevation: 4,
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Stats',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),),
          Center(child: Text('No of Transactions: ${categories.length}')), // Count of transactions
          Center(
            child: TextButton(
              onPressed: () {       
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllTransaction(year: _currentDate.year, month: _currentDate.month)),
                );
              },
              child: Text('See all'),
            ),
          ),
        ],
      ),
    ),
  ),
),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
