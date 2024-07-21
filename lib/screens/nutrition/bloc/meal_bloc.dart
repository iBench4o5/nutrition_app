import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_app/models/models.dart';

part 'meal_event.dart';part 'meal_state.dart';

class MealBloc extends Bloc<MealEvent, MealState> {
  MealBloc() : super(MealInitial()) {
    on<LoadMealCaloriesEvent>((event, emit) async {
      emit(MealLoaded(meals: Meal.meals));
    });

    on<AddItemEvent>((event, emit) {
      if (state is MealLoaded) {
        final currentState = state as MealLoaded;
        final updatedMeals = currentState.meals.map((meal) {
          if (meal.id == event.meal.id) {
            int calories = meal.calories + event.item.calories;
            return Meal(
              id: meal.id,
              name: meal.name,
              calories: calories,
              items: List.from(meal.items)..add(event.item),
            );
          }
          return meal;
        }).toList();
        emit(MealLoaded(meals: updatedMeals));
      }
    });

    on<RemoveItemEvent>((event, emit) {
      if (state is MealLoaded) {
        final currentState = state as MealLoaded;
        final updatedMeals = currentState.meals.map((meal) {
          if (meal.id == event.meal.id) {
            return Meal(
                id: meal.id,
                name: meal.name,
                calories: meal.calories - meal.items[event.index].calories,
                items: List.from(meal.items)..removeAt(event.index));
          }
          return meal;
        }).toList();
        emit(MealLoaded(meals: updatedMeals));
      }
    });
  }
}
