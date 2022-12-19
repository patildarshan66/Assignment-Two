class CategoryModel {
  CategoryModel({
    required this.name,
    required this.price,
    required this.instock,
    required this.quantity,
    this.isBestSeller = false,
  });

  final String name;
  final int price;
  final bool instock;
  final int quantity;
  bool isBestSeller;

  factory CategoryModel.fromMap(Map<String, dynamic> json) => CategoryModel(
    name: json["name"] ?? '',
    price: json["price"] ?? 0,
    instock: json["instock"] ?? false,
    isBestSeller: json["isBestSeller"] ?? false,
    quantity: json["quantity"] ?? 0,
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "price": price,
    "instock": instock,
    "quantity": quantity,
    "isBestSeller": isBestSeller,
  };
}
