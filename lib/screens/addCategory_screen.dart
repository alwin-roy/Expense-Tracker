import 'package:expense/models/category_img.dart';
import 'package:expense/models/category_model.dart';
import 'package:expense/models/incomeCategory_model.dart';
import 'package:expense/screens/category_screen.dart';
import 'package:expense/screens/income_Category_screen.dart';
import 'package:expense/services/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddCategoryScreen extends StatefulWidget {
  final bool isIncomeCategory;

  AddCategoryScreen({required this.isIncomeCategory});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final List<Category> categories = [
    Category(
      name: 'Food',
      items: [
        'images/food1.svg',
        'images/food2.svg',
        'images/food3.svg',
        'images/food4.svg',
        'images/food5.svg',
        'images/food6.svg',
        'images/food7.svg',
        'images/food8.svg',
        'images/food9.svg',
        'images/food10.svg',
        'images/food11.svg',
        'images/food12.svg',
        'images/food13.svg',
      ],
    ),
    Category(
      name: 'Travel',
      items: [
        'images/travel1.svg',
        'images/travel2.svg',
        'images/travel3.svg',
        'images/travel4.svg',
        'images/travel5.svg',
        'images/travel6.svg',
        'images/travel7.svg',
        'images/travel8.svg',
        'images/travel9.svg',
        'images/travel10.svg',
        // Add more image paths
      ],
    ),
    Category(
      name: 'Shopping',
      items: [
        'images/shopping1.svg',
        'images/shopping2.svg',
        'images/shopping3.svg',
        'images/shopping4.svg',
        'images/shopping5.svg',
        'images/shopping6.svg',
        'images/shopping7.svg',
      ],
    ),
    Category(
      name: 'Family',
      items: [
        'images/family1.svg',
        'images/family2.svg',
        'images/family3.svg',
        'images/family4.svg',
      ],
    ),
    Category(
      name: 'Entertainment',
      items: [
        'images/ent1.svg',
        'images/ent2.svg',
        'images/ent3.svg',
        'images/ent4.svg',
      ],
    ),
    Category(
      name: 'Business',
      items: [
        'images/business1.svg',
        'images/business2.svg',
        'images/business3.svg',
        'images/business4.svg',
      ],
    ),
    Category(
      name: 'Finance',
      items: [
        'images/finance1.svg',
        'images/finance2.svg',
        'images/finance3.svg',
        'images/finance4.svg',
        'images/finance5.svg',
      ],
    ),
    Category(
      name: 'Utilities',
      items: [
        'images/utilities2.svg',
        'images/utilities3.svg',
        'images/utilities4.svg',
        'images/utilities5.svg',
        'images/utilities6.svg',
        'images/utilities7.svg',
        'images/utilities8.svg',
      ],
    ),
    Category(
      name: 'Medical',
      items: [
        'images/medical1.svg',
        'images/medical2.svg',
        'images/medical3.svg',
        'images/medical4.svg',
      ],
    ),
    Category(
      name: 'Micellaneous',
      items: [
        'images/mis1.svg',
        'images/mis2.svg',
        'images/mis3.svg',
        'images/mis4.svg',
        'images/mis5.svg',
        'images/mis6.svg',
        'images/mis7.svg',
        'images/mis8.svg',
        'images/mis9.svg',
        'images/mis10.svg',
      ],
    ),
  ];

  String? selectedImagePath;
  TextEditingController categoryNameController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            Row(
              children: [
                ClipOval(
                  child: selectedImagePath != null
                      ? SvgPicture.asset(
                          selectedImagePath!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.contain,
                        )
                      : SvgPicture.asset(
                          'images/placeholder.svg',
                          height: 100,
                          width: 100,
                        ),
                ),
                const SizedBox(
                  width: 50,
                ),
                Expanded(
                  child: TextField(
                    controller: categoryNameController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Category name',
                      hintStyle: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            for (var category in categories) ...[
              Text(
                category.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: category.items.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedImagePath = category.items[index];
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipOval(
                          child: SvgPicture.asset(
                            category.items[index],
                            height: selectedImagePath == category.items[index]
                                ? 100
                                : 50,
                            width: selectedImagePath == category.items[index]
                                ? 100
                                : 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (selectedImagePath == category.items[index])
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.5),
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: loading
          ? const CircularProgressIndicator()
          : FloatingActionButton(
              backgroundColor: Colors.deepPurpleAccent[700],
              child: Icon(Icons.save),
              onPressed: selectedImagePath != null
                  ? () async {
                      if (selectedImagePath == null ||
                          categoryNameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            padding: EdgeInsets.all(8),
                            backgroundColor: Colors.red,
                            content: Text('Please fill all the fields'),
                          ),
                        );
                      } else {
                        setState(() {
                          loading = true;
                        });

                        if (widget.isIncomeCategory) {
                          IncomeCategoryBox incCat = IncomeCategoryBox(
                            category: categoryNameController.text,
                            imageUrl: selectedImagePath!,
                          );

                          await HiveService().addIncomeCategory(incCat);
                          Navigator.pop(context, incCat);
                        } else {
                          CategoryBox cat = CategoryBox(
                            category: categoryNameController.text,
                            imageUrl: selectedImagePath!,
                          );

                          await HiveService().addCategory(cat);
                          Navigator.pop(context, cat);
                        }

                        setState(() {
                          loading = false;
                        });
                      }
                    }
                  : null,
            ),
    );
  }
}
