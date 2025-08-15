import 'package:hive/hive.dart';

part 'hive_shopping_cart.g.dart';

@HiveType(typeId: 1)
class CartItem extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int price;

  @HiveField(3)
  int quantity;

  @HiveField(4)
  String cover;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.cover,
  });
}
