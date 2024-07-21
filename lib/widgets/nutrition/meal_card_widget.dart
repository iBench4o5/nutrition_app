import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_app/models/models.dart';
import 'package:nutrition_app/screens/screens.dart';
import 'package:nutrition_app/widgets/nutrition/widgets.dart';



class MealCard extends StatelessWidget {
  final String title;
  final int calories;
  final List<Item> items;

  const MealCard(
      {super.key,
      required this.title,
      required this.calories,
      required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 0),
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
            Column(
              children: [
                for (int index = 0; index < items.length; index++)
                  FoodItem1(
                    name: items[index].name,
                    imageUrl: items[index].imageURL,
                    calories: items[index].calories,
                    weight: items[index].weight,
                    title: title,
                    item: items[index],
                    onRemove: () {
                      final mealBloc = context.read<MealBloc>();
                      final state = mealBloc.state;

                      if (state is MealLoaded) {
                        final meal = state.meals.firstWhere((meal) => meal.name == title);
                        mealBloc.add(RemoveItemEvent(meal, index: index));
                      }
                    },
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 10),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddFoodScreen(title: title)),
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
      ),
    );
  }
}
