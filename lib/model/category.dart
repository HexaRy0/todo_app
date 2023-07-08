import 'package:isar/isar.dart';

part 'category.g.dart';

@Collection()
class CategoryData {
  Id id = Isar.autoIncrement;

  String catId;
  String name;
  int order;
  int icon;
  int color;

  CategoryData({
    required this.catId,
    required this.name,
    required this.order,
    required this.icon,
    required this.color,
  });

  @override
  String toString() {
    return 'CategoryData(catId: $catId, name: $name, order: $order, icon: $icon, color: $color)';
  }
}
