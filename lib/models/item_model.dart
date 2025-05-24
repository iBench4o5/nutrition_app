import 'package:equatable/equatable.dart';

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
  List<Object> get props => [
        id,
        name,
        weight,
        calories,
        imageURL,
        protein,
        fat,
        carbs,
      ];

  static List<Item> items = [
    const Item(
      id: '0',
      name: 'Cekin Rooster',
      imageURL:
          'https://images-katalozi.njuskalo.hr/data/image/500x705/51148/pile-roster-cekin-1-kg-studenac1706691391342-studenac-255735452.jpg',
      calories: 104,
      carbs: 0,
      fat: 1.1,
      protein: 23,
      weight: '1.3 kg',
    ),
    const Item(
      id: '0',
      name: 'Lino Pillows',
      imageURL:
          'https://d17zv3ray5yxvp.cloudfront.net/variants/WBVDzFGVQBrbbPuMwxYvtvdK/357327d81e7592a6661fbca6215a61db162ccd438802a608d05fb668bf373162',
      calories: 312,
      carbs: 24.5,
      fat: 3,
      protein: 7.1,
      weight: '500g',
    ),
    const Item(
      id: '0',
      name: 'Proteinski napitak',
      imageURL:
          'https://d17zv3ray5yxvp.cloudfront.net/variants/bHzNxg2abubYiw1UezVUu4i1/f01be07266bbc10fa5c98438ae144b6610cfa79ad344cd3480e7432245669b41',
      calories: 150,
      carbs: 12.1,
      fat: 5.7,
      protein: 99.9,
      weight: '500ml',
    ),
  ];
}
