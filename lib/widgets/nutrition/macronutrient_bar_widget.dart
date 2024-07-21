import 'package:flutter/material.dart';

import 'remaining_calories_scale_widget.dart';

class MacronutrientBar extends StatelessWidget {
  const MacronutrientBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const RemainingCaloriesScale(),
        const SizedBox(height: 12,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                const Text('Carbohydrates'),
              ],
            ),
            const SizedBox(width: 8),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                const Text('Fat'),
              ],
            ),
            const SizedBox(width: 8),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                const Text('Protein'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
