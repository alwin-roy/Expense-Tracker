import 'package:hive_flutter/adapters.dart';

part 'incomeCategory_model.g.dart';

@HiveType(typeId: 3)
class IncomeCategoryBox {
  @HiveField(0)
  late String category;

  @HiveField(1)
  late String imageUrl;

  IncomeCategoryBox({required this.category, required this.imageUrl});
}
