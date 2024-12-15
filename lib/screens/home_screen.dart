import 'package:expense/models/expense_model.dart';
import 'package:expense/screens/addTransaction_screen.dart';
import 'package:expense/screens/allTransaction_screen.dart';
import 'package:expense/screens/analysis_screen.dart';
import 'package:expense/services/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> categories = [];
  int totalIncome = 0;
  int totalExpense = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    final income = await HiveService().getIncome();
    final expense = await HiveService().getExpense();

    // Get the current month and year
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    setState(() {
      // Filter transactions for the current month
      final currentMonthIncome = income.where((transaction) =>
          transaction.date.month == currentMonth &&
          transaction.date.year == currentYear);
      final currentMonthExpense = expense.where((transaction) =>
          transaction.date.month == currentMonth &&
          transaction.date.year == currentYear);

      // Calculate total income and expense for the current month
      totalIncome =
          currentMonthIncome.fold(0, (sum, item) => sum + item.incomeAmount);
      totalExpense =
          currentMonthExpense.fold(0, (sum, item) => sum + item.amount);

      // Calculate balance for the current month
      final balance = totalIncome - totalExpense;

      // Set categories to the latest five transactions for the current month
      categories = [...currentMonthIncome, ...currentMonthExpense];
      categories.sort((a, b) => b.date.compareTo(a.date));
      categories = categories.take(5).toList();

      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddTransactionScreen()));
        },
        child: const Icon(Icons.add),
        shape: const CircleBorder(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      bottomNavigationBar: SizedBox(
        height: 75,
        child: BottomAppBar(
          notchMargin: 5.0,
          shape: const CircularNotchedRectangle(),
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.home,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AnalysisScreen()));
                  },
                  icon: const Icon(
                    Icons.bar_chart,
                    color: Colors.white,
                  ))
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Xpense',
        style: TextStyle(fontSize: 30,
        fontWeight: FontWeight.bold,
        fontFamily: 'Oswald'),
        ),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(height: 15,),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'This month',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 130,
                          width: 175,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              color: Colors.red),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '\$$totalExpense',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold),
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
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
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Income',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        )
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
                          color: Colors.grey[300]),
                      child: Text(
                        'Balance: \$${totalIncome - totalExpense}',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 7,
                        ),
                        const Text(
                          'Recent Transactions',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        TextButton(
                            onPressed: () {
                              final currentDate =
                                  DateTime.now(); // Get the current date
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllTransaction(
                                      year: currentDate.year,
                                      month: currentDate.month),
                                ),
                              );
                            },
                            child: const Text(
                              'See all',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    
                    categories.isEmpty
                        ? const Center(child: Text('No transactions'))
                        :
                    Container(
                      height: 500,
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            
                              final transaction = categories[index];
                              final isExpense = transaction is ExpenseBox;
                              final amount = isExpense
                                  ? transaction.amount
                                  : transaction.incomeAmount;
                              final date = DateFormat('dd-MM-yy')
                                  .format(transaction.date);
                              final categoryImage = transaction.categoryImgUrl;
                              final category = transaction.category;
                              final description = transaction.description;

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Dismissible(
                                  key: UniqueKey(),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) async {
                                    // Implement delete functionality here

                                    await HiveService()
                                        .deleteTransaction(index, !isExpense);
                                    // Reload the data after deletion
                                    await loadCategories();
                                    print('Item dismissed');
                                  },
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    color: Colors.red,
                                    child: const Icon(Icons.delete,
                                        color: Colors.white),
                                  ),
                                  child: Card(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    color: isExpense
                                        ? Colors.red[900]
                                        : Colors.green[900],
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        child: SvgPicture.asset(
                                          categoryImage,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      title: Row(
                                        children: [
                                          Text(
                                            description,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          const Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16.0),
                                            child: Text(
                                              '\$$amount',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Text(
                                        date,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            
                          }),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
