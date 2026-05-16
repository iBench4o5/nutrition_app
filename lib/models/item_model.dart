import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Item extends Equatable {
  final String id;
  final String name;
  final int calories;
  final String weight;
  final String imageURL;
  final double carbs;
  final double fat;
  final double protein;

  const Item({
    required this.id,
    required this.name,
    required this.calories,
    required this.weight,
    required this.imageURL,
    required this.protein,
    required this.fat,
    required this.carbs,
  });

  @override
  List<Object> get props => [id, name, weight, calories, imageURL, protein, fat, carbs];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'weight': weight,
      'imageURL': imageURL,
      'carbs': carbs,
      'fat': fat,
      'protein': protein,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] as String,
      name: map['name'] as String,
      calories: (map['calories'] as num).toInt(),
      weight: map['weight'] as String,
      imageURL: map['imageURL'] as String,
      carbs: (map['carbs'] as num).toDouble(),
      fat: (map['fat'] as num).toDouble(),
      protein: (map['protein'] as num).toDouble(),
    );
  }

  Item copyWith({
    String? id,
    String? name,
    int? calories,
    String? weight,
    String? imageURL,
    double? carbs,
    double? fat,
    double? protein,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      weight: weight ?? this.weight,
      imageURL: imageURL ?? this.imageURL,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      protein: protein ?? this.protein,
    );
  }

  static String generateId() => const Uuid().v4();
}