import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nutrition_app/data/repositories/meal_repository.dart';
import 'package:nutrition_app/models/models.dart';
import 'package:nutrition_app/screens/nutrition/bloc/meal_bloc.dart';

import 'meal_bloc_test.mocks.dart';

@GenerateMocks([MealRepository])
void main() {
  late MockMealRepository mockMealRepository;

  const testItem = Item(
    id: 'item-1', name: 'Chicken', calories: 104,
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

  group('MealBloc', () {
    blocTest<MealBloc, MealState>(
      'LoadMealCaloriesEvent emitira MealLoading zatim MealLoaded',
      build: () => MealBloc(mealRepository: mockMealRepository),
      act: (bloc) => bloc.add(LoadMealCaloriesEvent()),
      expect: () => [
        isA<MealLoading>(),
        isA<MealLoaded>(),
      ],
    );

    blocTest<MealBloc, MealState>(
      'LoadMealCaloriesEvent učitava 4 default obroka',
      build: () => MealBloc(mealRepository: mockMealRepository),
      act: (bloc) => bloc.add(LoadMealCaloriesEvent()),
      expect: () => [
        isA<MealLoading>(),
        predicate<MealState>((state) =>
        state is MealLoaded && state.meals.length == 4),
      ],
    );

    blocTest<MealBloc, MealState>(
      'AddItemEvent dodaje item u ispravan obrok',
      build: () => MealBloc(mealRepository: mockMealRepository),
      seed: () => MealLoaded(meals: defaultMeals),
      act: (bloc) => bloc.add(AddItemEvent(defaultMeals.first, item: testItem)),
      expect: () => [
        predicate<MealState>((state) {
          if (state is MealLoaded) {
            return state.meals.first.items.contains(testItem);
          }
          return false;
        }),
      ],
    );

    blocTest<MealBloc, MealState>(
      'AddItemEvent ispravno zbraja kalorije',
      build: () => MealBloc(mealRepository: mockMealRepository),
      seed: () => MealLoaded(meals: defaultMeals),
      act: (bloc) => bloc.add(AddItemEvent(defaultMeals.first, item: testItem)),
      expect: () => [
        predicate<MealState>((state) {
          if (state is MealLoaded) {
            return state.meals.first.calories == testItem.calories;
          }
          return false;
        }),
      ],
    );

    blocTest<MealBloc, MealState>(
      'RemoveItemEvent uklanja item iz obroka',
      build: () => MealBloc(mealRepository: mockMealRepository),
      seed: () => MealLoaded(
        meals: [
          Meal(
            id: 'breakfast', name: 'Breakfast',
            calories: testItem.calories, items: [testItem],
          ),
          ...defaultMeals.skip(1),
        ],
      ),
      act: (bloc) => bloc.add(
        RemoveItemEvent(
          const Meal(id: 'breakfast', name: 'Breakfast', calories: 104, items: []),
          index: 0,
        ),
      ),
      expect: () => [
        predicate<MealState>((state) {
          if (state is MealLoaded) {
            return state.meals.first.items.isEmpty &&
                state.meals.first.calories == 0;
          }
          return false;
        }),
      ],
    );

    blocTest<MealBloc, MealState>(
      'LoadMealCaloriesEvent emitira MealError kad repository baci iznimku',
      build: () {
        when(mockMealRepository.getMealsForDate(any))
            .thenThrow(Exception('Network error'));
        return MealBloc(mealRepository: mockMealRepository);
      },
      act: (bloc) => bloc.add(LoadMealCaloriesEvent()),
      expect: () => [
        isA<MealLoading>(),
        isA<MealError>(),
      ],
    );
  });
}