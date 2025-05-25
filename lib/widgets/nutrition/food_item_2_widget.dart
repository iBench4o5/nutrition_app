import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_app/models/models.dart';
import 'package:nutrition_app/screens/screens.dart';

class FoodItem2 extends StatelessWidget {
  final String title;
  final Item item;

  const FoodItem2({super.key, required this.title, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8.0),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FoodDetail(title: title, item: item, fromFoodItem2: true,)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: item.imageURL.isNotEmpty
                    ? Image.network(item.imageURL, width: 60, height: 60, fit: BoxFit.cover)
                    : Container(width: 60, height: 60, color: Colors.grey)
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(Icons.star,
                          color: Color(0xFFA32D2D), size: 16),
                    ],
                  ),
                  Text(
                      'Calories: ${item.caloriesPer100g.toStringAsFixed(item.caloriesPer100g.truncateToDouble() == item.caloriesPer100g ? 0 : 1)}, Carbs: ${item.carbs.toStringAsFixed(item.carbs.truncateToDouble() == item.carbs ? 0 : 1)}g'),
                  Text(
                      'Fat: ${item.fat.toStringAsFixed(item.fat.truncateToDouble() == item.fat ? 0 : 1)}g, Protein: ${item.protein.toStringAsFixed(item.protein.truncateToDouble() == item.protein ? 0 : 1)}g'),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.add_circle_outline,
                color: Color(0xFFA32D2D),
                size: 30,
              ),
              onPressed: () {
                final mealBloc = context.read<MealBloc>();
                final state = mealBloc.state;

                if (state is MealLoaded) {
                  final meal =
                      state.meals.firstWhere((meal) => meal.name == title);
                  mealBloc.add(AddItemEvent(meal, item: item));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Item added to $title',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      duration: const Duration(seconds: 1),
                      backgroundColor: Colors.orangeAccent,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
