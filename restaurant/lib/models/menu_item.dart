//menu_item.dart
class MenuItem {
  final int id;
  final String name;
  final String category;
  final int price;

  MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      price: json['price'],
    );
  }
}