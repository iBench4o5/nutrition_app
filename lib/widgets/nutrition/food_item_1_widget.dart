import 'package:flutter/material.dart';
import 'package:nutrition_app/models/models.dart';
import 'package:nutrition_app/screens/screens.dart';


class FoodItem1 extends StatelessWidget {
  final String name;
  final String imageUrl;
  final int calories;
  final int caloriesPer100g;
  final String weight;
  final VoidCallback onRemove;
  final String title;
  final Item item;

  const FoodItem1({super.key,
    required this.name,
    required this.imageUrl,
    required this.calories,
    required this.caloriesPer100g,
    required this.weight,
    required this.onRemove,
    required this.title,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onRemove();
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Text(
          'Remove',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      child: Material(
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FoodDetail(title: title, item: item,)),
            );
          },
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
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
                      ? Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover)
                      : Container(width: 60, height: 60, color: Colors.grey)

                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(weight),
                        const SizedBox(width: 16,),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                calories.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
