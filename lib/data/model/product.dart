class Product {
  final int? id;
  final String name;
  final int price;
  final int quantity;
  final String cover;
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.cover,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'price': this.price,
      'quantity': this.quantity,
      'cover': this.cover,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    print('Dữ liệu vào fromJson: $json');
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'],
      cover: json['cover'],
    );
  }
}
