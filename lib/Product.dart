import 'dart:convert';

class Product {
  final int id;
  final String name;
  int qty;
  final int price;
  final String type;
  final String category;
  final String image;
  Product({
    required this.id,
    required this.name,
    required this.qty,
    required this.price,
    required this.type,
    required this.category,
    required this.image,
  });

  Product copyWith({
    int? id,
    String? name,
    int? qty,
    int? price,
    String? type,
    String? category,
    String? image,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      qty: qty ?? this.qty,
      price: price ?? this.price,
      type: type ?? this.type,
      category: category ?? this.category,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'qty': qty,
      'price': price,
      'type': type,
      'category': category,
      'image': image,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'].toInt() as int,
      name: map['name'] as String,
      qty: map['qty'].toInt() as int,
      price: map['price'].toInt() as int,
      type: map['type'] as String,
      category: map['category'] as String,
      image: map['image'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Product(id: $id, name: $name, qty: $qty, price: $price, type: $type, category: $category, image: $image)';
  }

  @override
  bool operator ==(covariant Product other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.qty == qty &&
        other.price == price &&
        other.type == type &&
        other.category == category &&
        other.image == image;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        qty.hashCode ^
        price.hashCode ^
        type.hashCode ^
        category.hashCode ^
        image.hashCode;
  }
}
