import 'package:flutter/material.dart';
import 'package:nutrition_app/widgets/nutrition/food_item_2_widget.dart';
import '../../models/item_model.dart';

class FoodList extends StatelessWidget {
  final String title;
  final List<Item> items;

  const FoodList({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(4.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return FoodItem2(
          title: title,
          item: items[index],
        );
      },
    );
  }
}
