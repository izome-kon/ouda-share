import 'package:flutter/cupertino.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/utils/utils.dart';

enum CategoryType { category, location, feature }

class CategoryModel {
  final int id;
  final String title;
  final int? count;
  final ImageModel? image;
  final IconData? icon;
  final Color? color;
  final CategoryType? type;
  final bool hasChild;

  CategoryModel({
    required this.id,
    required this.title,
    this.count,
    this.image,
    this.icon,
    this.color,
    this.type = CategoryType.category,
    this.hasChild = false,
  });

  @override
  bool operator ==(Object other) => other is CategoryModel && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    CategoryType categoryType = CategoryType.category;
    ImageModel? image;
    if (json['image'] != null) {
      image = ImageModel.fromJson(json['image']);
    }
    if (json['taxonomy'] == 'listar_feature') {
      categoryType = CategoryType.feature;
    }
    if (json['taxonomy'] == 'listar_location') {
      categoryType = CategoryType.location;
    }
    final icon = UtilIcon.getIconFromCss(json['icon']);
    final color = UtilColor.getColorFromHex(json['color']);
    return CategoryModel(
      id: json['term_id'] ?? json['id'] ?? 0,
      title: json['name'] ?? 'Unknown',
      count: json['count'] ?? 0,
      image: image,
      icon: icon,
      color: color,
      type: categoryType,
      hasChild: json['has_child'] ?? false,
    );
  }
}
