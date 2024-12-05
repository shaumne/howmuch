class ProductModel {
  final String barcode;
  final String name;
  final String description;
  final String category;
  final Map<String, double> prices; // Market adı: fiyat
  final String? imageUrl;
  final DateTime? lastUpdated;

  ProductModel({
    required this.barcode,
    required this.name,
    required this.description,
    required this.category,
    required this.prices,
    this.imageUrl,
    this.lastUpdated,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      barcode: json['barcode'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      prices: Map<String, double>.from(json['prices']),
      imageUrl: json['imageUrl'],
      lastUpdated: json['lastUpdated']?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode,
      'name': name,
      'description': description,
      'category': category,
      'prices': prices,
      'imageUrl': imageUrl,
      'lastUpdated': lastUpdated,
    };
  }
}
