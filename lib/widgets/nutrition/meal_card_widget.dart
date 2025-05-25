import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_app/models/models.dart';
import 'package:nutrition_app/screens/screens.dart';
import 'package:nutrition_app/widgets/nutrition/widgets.dart';

class MealCard extends StatelessWidget {
  final String title;
  final int calories;
  final List<Item> items;

  const MealCard({
    super.key,
    required this.title,
    required this.calories,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$calories cal',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFFA32D2D),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
          // Food Item List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return FoodItem1(
                name: items[index].name,
                imageUrl: items[index].imageURL,
                calories: items[index].calories,
                caloriesPer100g: items[index].caloriesPer100g,
                weight: items[index].weight,
                title: title,
                item: items[index],
                onRemove: () {
                  final mealBloc = context.read<MealBloc>();
                  final state = mealBloc.state;

                  if (state is MealLoaded) {
                    final meal =
                        state.meals.firstWhere((meal) => meal.name == title);
                    mealBloc.add(RemoveItemEvent(meal, index: index));
                  }
                },
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8);
            },
          ),

          const SizedBox(height: 8),

          Center(
            child: Material(
              color: Colors.white,
              child: InkWell(
                borderRadius: BorderRadius.circular(24.0),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddFoodScreen(title: title)),
                  );
                },
                child: Container(
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFA32D2D)),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: const Center(
                    child: Text(
                      '+ Add food',
                      style: TextStyle(
                        color: Color(0xFFA32D2D),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
