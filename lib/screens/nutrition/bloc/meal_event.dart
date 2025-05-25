part of 'meal_bloc.dart';

@immutable
abstract class MealEvent extends Equatable {
  const MealEvent();

  @override
  List<Object> get props => [];
}

class LoadMealCaloriesEvent extends MealEvent {}

class AddItemEvent extends MealEvent {
  final Meal meal;
  final Item item;

  const AddItemEvent(this.meal, {required this.item});

  @override
  List<Object> get props => [meal, item];
}

class RemoveItemEvent extends MealEvent {
  final Meal meal;
  final int index;

  const RemoveItemEvent(this.meal, {required this.index});

  @override
  List<Object> get props => [meal, index];
}

class UpdateItemEvent extends MealEvent {
  final Meal meal;
  final int index;
  final Item updatedItem;

  const UpdateItemEvent(this.meal, {required this.index, required this.updatedItem});

  @override
  List<Object> get props => [meal, index, updatedItem];
}

