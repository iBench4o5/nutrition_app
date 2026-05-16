import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nutrition_app/data/repositories/meal_repository.dart';
import 'package:nutrition_app/models/models.dart';

part 'meal_event.dart';
part 'meal_state.dart';

class MealBloc extends Bloc<MealEvent, MealState> {
  final MealRepository _mealRepository;
  DateTime _currentDate = DateTime.now();

  MealBloc({MealRepository? mealRepository})
      : _mealRepository = mealRepository ?? MealRepository(),
        super(MealInitial()) {

    on<LoadMealCaloriesEvent>((event, emit) async {
      emit(MealLoading());
      try {
        _currentDate = event.date;
        final meals = await _mealRepository.getMealsForDate(_currentDate);
        emit(MealLoaded(meals: meals));
      } catch (e) {
        emit(MealError(message: e.toString()));
      }


    });

    on<UpdateItemEvent>((event, emit) async {
      if (state is MealLoaded) {
        final currentState = state as MealLoaded;
        final updatedMeals = currentState.meals.map((meal) {
          if (meal.id == event.meal.id) {
            final updatedItems = List<Item>.from(meal.items);
            updatedItems[event.index] = event.newItem;
            final newCalories = updatedItems.fold(0, (sum, i) => sum + i.calories);
            return Meal(
              id: meal.id,
              name: meal.name,
              calories: newCalories,
              items: updatedItems,
            );
          }
          return meal;
        }).toList();

        emit(MealLoaded(meals: updatedMeals));
        await _mealRepository.saveMeals(_currentDate, updatedMeals);
      }
    });

    on<AddItemEvent>((event, emit) async {
      if (state is MealLoaded) {
        final currentState = state as MealLoaded;
        final updatedMeals = currentState.meals.map((meal) {
          if (meal.id == event.meal.id) {
            return Meal(
              id: meal.id,
              name: meal.name,
              calories: meal.calories + event.item.calories,
              items: List.from(meal.items)..add(event.item),
            );
          }
          return meal;
        }).toList();

        emit(MealLoaded(meals: updatedMeals));
        await _mealRepository.saveMeals(_currentDate, updatedMeals);
      }
    });

    on<RemoveItemEvent>((event, emit) async {
      if (state is MealLoaded) {
        final currentState = state as MealLoaded;
        final updatedMeals = currentState.meals.map((meal) {
          if (meal.id == event.meal.id) {
            return Meal(
              id: meal.id,
              name: meal.name,
              calories: meal.calories - meal.items[event.index].calories,
              items: List.from(meal.items)..removeAt(event.index),
            );
          }
          return meal;
        }).toList();

        emit(MealLoaded(meals: updatedMeals));
        await _mealRepository.saveMeals(_currentDate, updatedMeals);
      }
    });
  }



}

