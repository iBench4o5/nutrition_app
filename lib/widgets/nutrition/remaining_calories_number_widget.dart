import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_app/models/models.dart';
import 'package:nutrition_app/screens/screens.dart';


class RemainingCalories extends StatelessWidget {
  const RemainingCalories({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealBloc, MealState>(
      builder: (context, state) {
        if (state is MealLoaded) {
          const dailyIntake = 1900;
          final totalCalories = _calculateTotalCalories(state.meals);
          final remainingCalories = (dailyIntake - totalCalories).toInt();
          return RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${remainingCalories.toString()} cal ',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: remainingCalories < 0 ? Colors.red : Colors.black,
                  ),
                ),
                const TextSpan(
                  text: ' / 1,900 cal',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          );
        }
        return const Text(
          'Greška!',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        );
      },
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
