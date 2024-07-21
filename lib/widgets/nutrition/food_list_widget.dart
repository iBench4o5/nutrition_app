import 'package:flutter/material.dart';
import 'package:nutrition_app/widgets/nutrition/food_item_2_widget.dart';

import '../../models/item_model.dart';


class FoodList extends StatelessWidget {
  final String title;

  const FoodList({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        for (int index = 0; index < Item.items.length; index++)
          FoodItem2(
            title: title,
            item: Item.items[index],
          ),

      ],
    );
  }
}