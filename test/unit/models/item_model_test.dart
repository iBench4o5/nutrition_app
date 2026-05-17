import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_app/models/models.dart';

void main() {
  group('Item model', () {
    const testItem = Item(
      id: 'test-id',
      name: 'Banana',
      calories: 89,
      weight: '100g',
      imageURL: 'https://example.com/banana.jpg',
      protein: 1.1,
      fat: 0.3,
      carbs: 23.0,
    );

    test('toMap() vraća ispravnu mapu', () {
      final map = testItem.toMap();
      expect(map['id'], 'test-id');
      expect(map['name'], 'Banana');
      expect(map['calories'], 89);
      expect(map['protein'], 1.1);
      expect(map['fat'], 0.3);
      expect(map['carbs'], 23.0);
    });

    test('fromMap() kreira ispravan Item', () {
      final map = testItem.toMap();
      final fromMap = Item.fromMap(map);
      expect(fromMap.id, testItem.id);
      expect(fromMap.name, testItem.name);
      expect(fromMap.calories, testItem.calories);
      expect(fromMap.protein, testItem.protein);
    });

    test('toMap() → fromMap() round-trip', () {
      final result = Item.fromMap(testItem.toMap());
      expect(result, testItem);
    });

    test('copyWith() mijenja samo zadana polja', () {
      final modified = testItem.copyWith(calories: 200, weight: '200g');
      expect(modified.calories, 200);
      expect(modified.weight, '200g');
      expect(modified.name, testItem.name); 
      expect(modified.protein, testItem.protein);
    });

    test('generateId() vraća neprazan string', () {
      final id = Item.generateId();
      expect(id.isNotEmpty, true);
    });

    test('dva generateId() poziva vraćaju različite vrijednosti', () {
      expect(Item.generateId(), isNot(equals(Item.generateId())));
    });
  });

  group('Meal model', () {
    const testMeal = Meal(
      id: 'breakfast',
      name: 'Breakfast',
      calories: 0,
      items: [],
    );

    test('toMap() → fromMap() round-trip', () {
      final result = Meal.fromMap(testMeal.toMap());
      expect(result.id, testMeal.id);
      expect(result.name, testMeal.name);
      expect(result.calories, testMeal.calories);
    });

    test('defaultMeals vraća 4 obroka', () {
      expect(Meal.defaultMeals.length, 4);
    });

    test('defaultMeals sadrži ispravna imena', () {
      final names = Meal.defaultMeals.map((m) => m.name).toList();
      expect(names, containsAll(['Breakfast', 'Lunch', 'Dinner', 'Snacks']));
    });

    test('fromMap() parsira items listu ispravno', () {
      const item = Item(
        id: 'i1', name: 'Apple', calories: 52,
        weight: '100g', imageURL: '', protein: 0.3, fat: 0.2, carbs: 14.0,
      );
      final mealWithItem = Meal(
        id: 'lunch', name: 'Lunch', calories: 52, items: [item],
      );
      final result = Meal.fromMap(mealWithItem.toMap());
      expect(result.items.length, 1);
      expect(result.items.first.name, 'Apple');
    });
  });
}