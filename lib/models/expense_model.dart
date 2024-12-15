import 'package:hive_flutter/adapters.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 0)
class ExpenseBox {
  @HiveField(0)
  late int amount;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late String category;

  @HiveField(3)
  late DateTime date;

  @HiveField(4)
  late String categoryImgUrl;

  ExpenseBox(
      {required this.amount,
      required this.description,
      required this.category,
      required this.date,
      required this.categoryImgUrl});
}
