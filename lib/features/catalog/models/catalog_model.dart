import 'package:cloud_firestore/cloud_firestore.dart';

class CatalogModel {
  final String id;
  final String marketId;
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final bool isApproved;
  final String? rejectionReason;
  final DateTime createdAt;

  CatalogModel({
    required this.id,
    required this.marketId,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    this.isApproved = false,
    this.rejectionReason,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'marketId': marketId,
        'imageUrl': imageUrl,
        'startDate': startDate,
        'endDate': endDate,
        'isApproved': isApproved,
        'rejectionReason': rejectionReason,
        'createdAt': createdAt,
      };

  factory CatalogModel.fromJson(Map<String, dynamic> json, String id) {
    return CatalogModel(
      id: id,
      marketId: json['marketId'],
      imageUrl: json['imageUrl'],
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: (json['endDate'] as Timestamp).toDate(),
      isApproved: json['isApproved'] ?? false,
      rejectionReason: json['rejectionReason'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }
} 