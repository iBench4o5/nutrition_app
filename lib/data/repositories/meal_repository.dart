import 'package:nutrition_app/data/datasources/firebase_datasource.dart';
import 'package:nutrition_app/models/models.dart';

class MealRepository {
  final FirebaseDatasource _datasource;

  MealRepository({FirebaseDatasource? datasource})
      : _datasource = datasource ?? FirebaseDatasource();

  Future<List<Meal>> getMealsForDate(DateTime date) =>
      _datasource.getMealsForDate(date);

  Future<void> saveMeals(DateTime date, List<Meal> meals) =>
      _datasource.saveMealsForDate(date, meals);
}