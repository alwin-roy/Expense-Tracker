import 'package:hive_flutter/adapters.dart';

part 'income_model.g.dart';

@HiveType(typeId: 1)
class IncomeBox {
  @HiveField(0)
  late int incomeAmount;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late String category;

  @HiveField(3)
  late DateTime date;

  @HiveField(4)
  late String categoryImgUrl;

  IncomeBox({required this.incomeAmount, required this.description, required this.category, required this.date, required this.categoryImgUrl});
}
