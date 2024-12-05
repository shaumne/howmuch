import 'package:cloud_firestore/cloud_firestore.dart';

class MarketModel {
  final String id;
  final String name;
  final String logo;
  final String status;
  final int? discount;
  final String address;
  final double rating;
  final String distance;
  final String website;
  final List<String> categories;
  final DateTime lastUpdated;

  MarketModel({
    required this.id,
    required this.name,
    required this.logo,
    required this.status,
    this.discount,
    required this.address,
    required this.rating,
    required this.distance,
    required this.website,
    required this.categories,
    required this.lastUpdated,
  });

  factory MarketModel.fromJson(Map<String, dynamic> json) {
    return MarketModel(
      id: json['id'] as String,
      name: json['name'] as String,
      logo: json['logo'] as String,
      status: json['status'] as String,
      discount: json['discount'] as int?,
      address: json['address'] as String,
      rating: (json['rating'] as num).toDouble(),
      distance: json['distance'] as String,
      website: json['website'] as String,
      categories: List<String>.from(json['categories'] as List),
      lastUpdated: (json['lastUpdated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'status': status,
      'discount': discount,
      'address': address,
      'rating': rating,
      'distance': distance,
      'website': website,
      'categories': categories,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }
}
