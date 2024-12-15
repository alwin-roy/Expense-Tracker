import 'package:expense/models/incomeCategory_model.dart';
import 'package:expense/screens/addCategory_screen.dart';
import 'package:expense/services/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IncomeCategoryScreen extends StatefulWidget {
  @override
  State<IncomeCategoryScreen> createState() => _IncomeCategoryScreenState();
}

class _IncomeCategoryScreenState extends State<IncomeCategoryScreen> {
  final List<Map<String, String>> manualCategories = [
    {'name': 'Salary', 'image': 'images/inc_credit.svg'},
    {'name': 'Sold Items', 'image': 'images/inc_sold.svg'},
    {'name': 'Coupons', 'image': 'images/inc_coupon.svg'},
    {'name': 'Others', 'image': 'images/others.svg'},
    
  ];

  bool loading = true;
  List<IncomeCategoryBox> categories = [];

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    final categoriesFromDb = await HiveService().getIncomeCategory();

    // Convert manually added categories to CategoryBox instances
    List<IncomeCategoryBox> manualCategoryBoxes =
        manualCategories.map((manualCategory) {
      return IncomeCategoryBox(
          category: manualCategory['name']!,
          imageUrl: manualCategory['image']!);
    }).toList();

    // Sort both lists separately
    manualCategoryBoxes.sort((a, b) => a.category.compareTo(b.category));
    categoriesFromDb.sort((a, b) => a.category.compareTo(b.category));

    setState(() {
      categories = [...manualCategoryBoxes, ...categoriesFromDb];
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurpleAccent[700],
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddCategoryScreen(isIncomeCategory: true)));
          }),
      appBar: AppBar(title: const Text('Select Category')),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 3 / 4,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                                onTap: () {
                    final selectedCategory = {
                    'category': category.category,
                    'imageUrl': category.imageUrl
                    };

                    Navigator.pop(context, selectedCategory);
                    },
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ClipOval(
                              child: SvgPicture.asset(
                                category.imageUrl!,
                                fit: BoxFit.contain,
                                width: double.infinity,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            category.category!,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
