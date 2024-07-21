import 'package:flutter/material.dart';
import 'package:nutrition_app/widgets/nutrition/widgets.dart';

class CalorieCard extends StatelessWidget {
  const CalorieCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Container(
          height: 152,
          padding: const EdgeInsets.only(left: 16, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.whatshot,
                        color: Colors.red,
                      ),
                      SizedBox(width: 6,),
                      Text(
                        'Calories',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w900,
                            fontSize: 16),
                      )
                    ],
                  ),
                  TextButton(
                      onPressed: () {},
                      child: const Row(
                        children: [
                          Text(
                            'Details',
                            style: TextStyle(
                                fontSize: 16, color: Colors.black54
                            ),
                          ),
                          SizedBox(width: 5,),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black54,
                            size: 16,
                          ),
                        ],
                      )
                  ),
                ],
              ),
              const RemainingCalories(),
              const SizedBox(height: 10,),
              const MacronutrientBar(),
            ],
          ),
        ),
      ),
    );
  }
}
