import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_app/models/models.dart';
import 'package:nutrition_app/screens/nutrition/nutrition.dart';

void main() {
  group('MealBloc tests', () {
    late MealBloc bloc;

    setUp(() {
      bloc = MealBloc();
    });

    test('initial state is MealInitial', () {
      expect(bloc.state, isA<MealInitial>());
    });

    test('LoadMealCaloriesEvent emits MealLoaded with initial meals', () async {
      bloc.add(LoadMealCaloriesEvent());

      await expectLater(
        bloc.stream,
        emits(isA<MealLoaded>().having((s) => s.meals.length, 'meals length', 4)),
      );
    });

    test('AddItemEvent adds item correctly', () async {
      bloc.add(LoadMealCaloriesEvent());

      // Pričekaj da MealLoaded bude emitiran
      await expectLater(
        bloc.stream,
        emits(isA<MealLoaded>()),
      );

      final item = Item(
        id: '10',
        name: 'Test Item',
        caloriesPer100g: 100,
        calories: 100,
        weight: '100g',
        imageURL: '',
        protein: 10,
        fat: 5,
        carbs: 20,
      );

      final state = bloc.state as MealLoaded;
      final meal = state.meals.first;

      bloc.add(AddItemEvent(meal, item: item));

      await expectLater(
        bloc.stream,
        emits(isA<MealLoaded>().having(
              (state) => state.meals.firstWhere((m) => m.id == meal.id).items.contains(item),
          'items contain added item',
          true,
        )),
      );
    });

    test('RemoveItemEvent removes item correctly', () async {
      bloc.add(LoadMealCaloriesEvent());

      await expectLater(
        bloc.stream,
        emits(isA<MealLoaded>()),
      );

      final state = bloc.state as MealLoaded;
      final meal = state.meals.first;

      final item = Item(
        id: '20',
        name: 'Remove Item',
        caloriesPer100g: 100,
        calories: 100,
        weight: '100g',
        imageURL: '',
        protein: 5,
        fat: 3,
        carbs: 10,
      );

      // Zamijeni meal stavkama
      final newMeal = Meal(id: meal.id, name: meal.name, calories: 100, items: [item]);
      final meals = state.meals.map((m) => m.id == meal.id ? newMeal : m).toList();

      bloc.emit(MealLoaded(meals: meals));

      bloc.add(RemoveItemEvent(newMeal, index: 0));

      await expectLater(
        bloc.stream,
        emits(isA<MealLoaded>().having(
              (state) => state.meals.firstWhere((m) => m.id == newMeal.id).items.isEmpty,
          'items empty after remove',
          true,
        )),
      );
    });

    test('UpdateItemEvent updates item correctly', () async {
      bloc.add(LoadMealCaloriesEvent());

      await expectLater(
        bloc.stream,
        emits(isA<MealLoaded>()),
      );

      final state = bloc.state as MealLoaded;
      final meal = state.meals.first;

      final originalItem = Item(
        id: '30',
        name: 'Original Item',
        caloriesPer100g: 100,
        calories: 100,
        weight: '100g',
        imageURL: '',
        protein: 5,
        fat: 3,
        carbs: 10,
      );

      final updatedItem = Item(
        id: '30',
        name: 'Updated Item',
        caloriesPer100g: 150,
        calories: 150,
        weight: '150g',
        imageURL: '',
        protein: 7,
        fat: 4,
        carbs: 15,
      );

      final newMeal = Meal(id: meal.id, name: meal.name, calories: 100, items: [originalItem]);
      final meals = state.meals.map((m) => m.id == meal.id ? newMeal : m).toList();

      bloc.emit(MealLoaded(meals: meals));

      bloc.add(UpdateItemEvent(newMeal, index: 0, updatedItem: updatedItem));

      await expectLater(
        bloc.stream,
        emits(isA<MealLoaded>().having(
              (state) => state.meals.firstWhere((m) => m.id == newMeal.id).items[0].name,
          'item updated',
          'Updated Item',
        )),
      );
    });
  });
}
