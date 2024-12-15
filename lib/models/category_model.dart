
import 'package:hive_flutter/adapters.dart';

part 'category_model.g.dart';

@HiveType(typeId: 2)
class CategoryBox {
  @HiveField(0)
  late String category;

  @HiveField(1)
  late String imageUrl;

  CategoryBox({required this.category, required this.imageUrl});
}
