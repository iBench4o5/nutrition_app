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

  static List<Meal> meals = [
    const Meal(
      id: '0',
      name: 'Breakfast',
      calories: 0,
      items: [],
    ),
    const Meal(
      id: '1',
      name: 'Lunch',
      calories: 0,
      items: [],
    ),
    const Meal(
      id: '2',
      name: 'Dinner',
      calories: 0,
      items: [],
    ),
    const Meal(
      id: '3',
      name: 'Snacks',
      calories: 0,
      items: [],
    ),
  ];
}
