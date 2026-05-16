part of 'meal_bloc.dart';

abstract class MealEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadMealCaloriesEvent extends MealEvent {
  final DateTime date;
  LoadMealCaloriesEvent({DateTime? date}) : date = date ?? DateTime.now();
}

class AddItemEvent extends MealEvent {
  final Meal meal;
  final Item item;
  AddItemEvent(this.meal, {required this.item});

  @override
  List<Object> get props => [meal, item];
}

class RemoveItemEvent extends MealEvent {
  final Meal meal;
  final int index;
  RemoveItemEvent(this.meal, {required this.index});

  @override
  List<Object> get props => [meal, index];
}

class UpdateItemEvent extends MealEvent {
  final Meal meal;
  final int index;
  final Item newItem;
  UpdateItemEvent(this.meal, {required this.index, required this.newItem});

  @override
  List<Object> get props => [meal, index, newItem];
}