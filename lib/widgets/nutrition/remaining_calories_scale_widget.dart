import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_app/models/models.dart';
import 'package:nutrition_app/screens/screens.dart';


class RemainingCaloriesScale extends StatelessWidget {
  const RemainingCaloriesScale({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealBloc, MealState>(
      builder: (context, state) {
        if (state is MealLoaded) {
          final totalCalories = _calculateTotalCalories(state.meals);
          final remainingCalories = (1900 - totalCalories).clamp(0, double.infinity).toInt();
          double width = 360;

          return Container(
            width: width,
            height: 14,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(6)
            ),
            child: Row(
              children: [
                Container(
                  height: 14,
                  width: (width * 0.25) * (remainingCalories / 1900),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6),
                      bottomLeft: Radius.circular(6),
                    ),
                  ),
                ),
                Container(
                  height: 14,
                  width: width * 0.35 * (remainingCalories / 1900),
                  decoration: BoxDecoration(
                    color: Colors.deepOrangeAccent[100],
                  ),
                ),
                Container(
                  height: 14,
                  width: width * 0.4 * (remainingCalories / 1900),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(6),
                      bottomRight: Radius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Text('Error 1');
        }
      }
    );
  }

  static int _calculateTotalCalories(List<Meal> meals) {
    int totalCalories = 0;
    for (var meal in meals) {
      for (var item in meal.items) {
        totalCalories += item.calories;
      }
    }
    return totalCalories;
  }
}
