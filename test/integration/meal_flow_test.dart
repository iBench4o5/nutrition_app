import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nutrition_app/models/models.dart';
import 'package:nutrition_app/screens/nutrition/bloc/meal_bloc.dart';

import '../unit/bloc/meal_bloc_test.mocks.dart';

void main() {
  late MockMealRepository mockMealRepository;

  const testItem = Item(
    id: 'i1', name: 'Chicken', calories: 104,
    weight: '100g', imageURL: '', protein: 23.0, fat: 1.1, carbs: 0.0,
  );

  final defaultMeals = Meal.defaultMeals;

  setUp(() {
    mockMealRepository = MockMealRepository();
    when(mockMealRepository.getMealsForDate(any))
        .thenAnswer((_) async => defaultMeals);
    when(mockMealRepository.saveMeals(any, any))
        .thenAnswer((_) async {});
  });

  group('Integracijski test – MealBloc ↔ MealRepository', () {
    blocTest<MealBloc, MealState>(
      'Cijeli tok: load → add → remove vraća prazan obrok',
      build: () => MealBloc(mealRepository: mockMealRepository),
      act: (bloc) async {
        bloc.add(LoadMealCaloriesEvent());
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(AddItemEvent(defaultMeals.first, item: testItem));
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(RemoveItemEvent(defaultMeals.first, index: 0));
      },
      wait: const Duration(milliseconds: 300),
      expect: () => [
        isA<MealLoading>(),
        isA<MealLoaded>(), // after load
        isA<MealLoaded>(), // after add
        isA<MealLoaded>(), // after remove
      ],
      verify: (bloc) {
        final state = bloc.state as MealLoaded;
        expect(state.meals.first.items.isEmpty, true);
        expect(state.meals.first.calories, 0);
        verify(mockMealRepository.saveMeals(any, any)).called(2);
      },
    );

    blocTest<MealBloc, MealState>(
      'Repository se poziva pri svakom AddItemEvent',
      build: () => MealBloc(mealRepository: mockMealRepository),
      seed: () => MealLoaded(meals: defaultMeals),
      act: (bloc) async {
        bloc.add(AddItemEvent(defaultMeals.first, item: testItem));
        await Future.delayed(const Duration(milliseconds: 50));
        bloc.add(AddItemEvent(defaultMeals[1], item: testItem));
      },
      wait: const Duration(milliseconds: 200),
      verify: (_) {
        verify(mockMealRepository.saveMeals(any, any)).called(2);
      },
    );

    blocTest<MealBloc, MealState>(
      'UpdateItemEvent mijenja kalorije i sprema u repository',
      build: () => MealBloc(mealRepository: mockMealRepository),
      seed: () => MealLoaded(
        meals: [
          Meal(
            id: 'breakfast', name: 'Breakfast',
            calories: 104, items: [testItem],
          ),
          ...defaultMeals.skip(1),
        ],
      ),
      act: (bloc) {
        const updatedItem = Item(
          id: 'i1', name: 'Chicken', calories: 208,
          weight: '200g', imageURL: '', protein: 46.0, fat: 2.2, carbs: 0.0,
        );
        bloc.add(UpdateItemEvent(
          const Meal(id: 'breakfast', name: 'Breakfast', calories: 104, items: []),
          index: 0,
          newItem: updatedItem,
        ));
      },
      expect: () => [
        predicate<MealState>((state) {
          if (state is MealLoaded) {
            return state.meals.first.calories == 208 &&
                state.meals.first.items.first.weight == '200g';
          }
          return false;
        }),
      ],
      verify: (_) {
        verify(mockMealRepository.saveMeals(any, any)).called(1);
      },
    );

    test('MealBloc i MealRepository su ispravno povezani bez mocka', () async {
      final bloc = MealBloc(mealRepository: mockMealRepository);
      expect(bloc.state, isA<MealInitial>());
      bloc.close();
    });
  });
}