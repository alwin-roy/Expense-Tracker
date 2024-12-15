import 'package:expense/models/category_model.dart';
import 'package:expense/screens/addCategory_screen.dart';
import 'package:expense/services/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryScreen extends StatefulWidget {
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final List<Map<String, String>> manualCategories = [
    {'name': 'Food and Dining', 'image': 'images/cat_food.svg'},
    {'name': 'Shopping', 'image': 'images/cat_shopping.svg'},
    {'name': 'Travelling', 'image': 'images/cat_location.svg'},
    {'name': 'Entertainment', 'image': 'images/cat_game.svg'},
    {'name': 'Medical', 'image': 'images/cat_health.svg'},
    {'name': 'Education', 'image': 'images/cat_education.svg'},
    {'name': 'Bills and Utilities', 'image': 'images/cat_bill.svg'},
    {'name': 'Investments', 'image': 'images/cat_investment.svg'},
    {'name': 'Rent', 'image': 'images/cat_rent.svg'},
    {'name': 'Tax', 'image': 'images/cat_tax.svg'},
    {'name': 'Insurance', 'image': 'images/cat_insurance.svg'},
    {'name': 'Gifts and Donation', 'image': 'images/cat_gift.svg'},
    {'name': 'Others', 'image': 'images/others.svg'},
  ];

  bool loading = true;
  List<CategoryBox> categories = [];

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    final categoriesFromDb = await HiveService().getCategory();

    List<CategoryBox> manualCategoryBoxes =
        manualCategories.map((manualCategory) {
      return CategoryBox(
          category: manualCategory['name']!,
          imageUrl: manualCategory['image']!);
    }).toList();

    manualCategoryBoxes.sort((a, b) => a.category.compareTo(b.category));
    categoriesFromDb.sort((a, b) => a.category.compareTo(b.category));

    setState(() {
      categories = [...manualCategoryBoxes, ...categoriesFromDb];
      loading = false;
    });
  }

  void addCategory(CategoryBox category) {
    setState(() {
      categories.add(category);
      categories.sort((a, b) => a.category.compareTo(b.category));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurpleAccent[700],
          child: const Icon(Icons.add),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddCategoryScreen(isIncomeCategory: false),
              ),
            );
            if (result != null && result is CategoryBox) {
              addCategory(result);
            }
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
