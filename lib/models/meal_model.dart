import 'package:equatable/equatable.dart';
import 'item_model.dart';

class Meal extends Equatable {
  final String id;
  final String name;
  final int calories;
  final List<Item> items;

  const Meal({
    required this.id,
    required this.name,
    required this.calories,
    required this.items,
  });

  @override
  List<Object> get props => [id, name, calories, items];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'] as String,
      name: map['name'] as String,
      calories: (map['calories'] as num).toInt(),
      items: (map['items'] as List<dynamic>?)
          ?.map((i) => Item.fromMap(i as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Meal copyWith({
    String? id,
    String? name,
    int? calories,
    List<Item>? items,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      items: items ?? this.items,
    );
  }

  static List<Meal> get defaultMeals => [
    const Meal(id: 'breakfast', name: 'Breakfast', calories: 0, items: []),
    const Meal(id: 'lunch', name: 'Lunch', calories: 0, items: []),
    const Meal(id: 'dinner', name: 'Dinner', calories: 0, items: []),
    const Meal(id: 'snacks', name: 'Snacks', calories: 0, items: []),
  ];
}