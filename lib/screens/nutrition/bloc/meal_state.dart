part of 'meal_bloc.dart';

@immutable
abstract class MealState extends Equatable{
  const MealState();

  @override
  List<Object> get props => [];
}

class MealInitial extends MealState {}

class MealLoaded extends MealState {
  final List<Meal> meals;

  const MealLoaded({required this.meals});

  @override
  List<Object> get props => [meals];
}
