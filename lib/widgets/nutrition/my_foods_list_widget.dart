import 'package:flutter/material.dart';
import 'package:nutrition_app/data/repositories/item_repository.dart';
import 'package:nutrition_app/widgets/nutrition/food_item_2_widget.dart';

class MyFoodsList extends StatelessWidget {
  final String title;

  const MyFoodsList({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ItemRepository().getUserFoods(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFA32D2D)),
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 48, color: Colors.grey),
                SizedBox(height: 8),
                Text(
                  'No foods added yet.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return FoodItem2(title: title, item: items[index]);
          },
        );
      },
    );
  }
}