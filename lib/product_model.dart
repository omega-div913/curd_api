class Product {
  final int? id;
  final String name;
  final String price;

  Product({this.id, required this.name, required this.price});

  // JSON data-va Object-ah matha
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'].toString(),
      price: json['price'].toString(),
    );
  }
}