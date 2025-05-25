import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_app/models/models.dart';
import 'package:nutrition_app/widgets/nutrition/widgets.dart'; // Pretpostavka: MealCard je ovdje

void main() {
  group('MealCard Widget Tests', () {
    late Meal testMeal;

    setUp(() {
      // Pripremi testni meal sa stavkama
      testMeal = Meal(
        id: '1',
        name: 'Lunch',
        calories: 450,
        items: [
          Item(
            id: '10',
            name: 'Apple',
            caloriesPer100g: 52,
            calories: 52,
            weight: '100g',
            imageURL: '',
            protein: 0.3,
            fat: 0.2,
            carbs: 14,
          ),
          Item(
            id: '11',
            name: 'Bread',
            caloriesPer100g: 265,
            calories: 398,
            weight: '150g',
            imageURL: '',
            protein: 9,
            fat: 3.2,
            carbs: 49,
          ),
        ],
      );
    });

    testWidgets('MealCard displays title and calories', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MealCard(
              title: testMeal.name,
              calories: testMeal.calories,
              items: testMeal.items,
            ),
          ),
        ),
      );

      // Provjeri da je prikazan naslov
      expect(find.text('Lunch'), findsOneWidget);

      // Provjeri da su prikazane kalorije u formatu: '450 cal'
      expect(find.text('450 cal'), findsOneWidget);
    });

    testWidgets('MealCard displays list of items with names and calories', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MealCard(
              title: testMeal.name,
              calories: testMeal.calories,
              items: testMeal.items,
            ),
          ),
        ),
      );

      // Provjeri da su prikazana imena stavki
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Bread'), findsOneWidget);

      // Provjeri da su prikazane kalorije stavki (kao stringovi)
      expect(find.text('52'), findsOneWidget);    // za Apple
      expect(find.text('398'), findsOneWidget);   // za Bread
    });
  });
}
