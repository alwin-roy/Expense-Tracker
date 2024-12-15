import 'package:expense/models/expense_model.dart';
import 'package:expense/models/income_model.dart';
import 'package:expense/services/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AllTransaction extends StatefulWidget {
  final int year;
  final int month;

  const AllTransaction({Key? key, required this.year, required this.month}) : super(key: key);

  @override
  _AllTransactionState createState() => _AllTransactionState();
}

class _AllTransactionState extends State<AllTransaction> {
  List<dynamic> categories = [];
  List<dynamic> filteredCategories = [];
  bool loading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    final income = await HiveService().getIncome();
    final expense = await HiveService().getExpense();

    setState(() {
      // Filter categories to include only transactions from the specified month and year
      categories = [...income, ...expense].where((transaction) {
        if (transaction is IncomeBox) {
          return transaction.date.month == widget.month && transaction.date.year == widget.year;
        } else if (transaction is ExpenseBox) {
          return transaction.date.month == widget.month && transaction.date.year == widget.year;
        }
        return false; // Return false for other types of transactions
      }).toList();
      filteredCategories = List.from(categories);

      // Sort categories by date in descending order
      categories.sort((a, b) => b.date.compareTo(a.date));

      loading = false;
    });
  }

  void filterCategories(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        filteredCategories = List.from(categories);
      } else {
        filteredCategories = categories
            .where((category) =>
                category.category.toLowerCase().startsWith(searchText.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'All Transactions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: searchController,
                      onChanged: filterCategories,
                      decoration: InputDecoration(
                        hintText: 'Search category',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.width * categories.length,
                      child: ListView.builder(
                        itemCount: filteredCategories.length,
                        itemBuilder: (context, index) {
                          final transaction = filteredCategories[index];
                          final isExpense = transaction is ExpenseBox;
                          final amount = isExpense ? transaction.amount : transaction.incomeAmount;
                          final date = DateFormat('dd-MM-yy').format(transaction.date);
                          final categoryImage = transaction.categoryImgUrl;
                          final category = transaction.category;
                          final description = transaction.description;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) async{

                                await HiveService().deleteTransaction(transaction.key, !isExpense);
                                  // Reload the data after deletion
                                  await loadCategories();

                                // Implement delete functionality here
                                print('Item dismissed');
                              },
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                color: Colors.red,
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                                color: isExpense ? Colors.red[900] : Colors.green[900],
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
                                      Text(description),
                                      Spacer(),
                                      Text(
                                        '\$$amount',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(date),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
