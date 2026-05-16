import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrition_app/models/models.dart';

class FirebaseDatasource {
  final FirebaseFirestore _firestore;

  FirebaseDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _productsCollection =>
      _firestore.collection('food_products');

  Future<List<Item>> getAllProducts() async {
    final snapshot = await _productsCollection.get();
    return snapshot.docs
        .map((doc) => Item.fromMap(doc.data()))
        .toList();
  }

  Future<List<Item>> searchProducts(String query) async {
    final snapshot = await _productsCollection.get();
    final all = snapshot.docs.map((doc) => Item.fromMap(doc.data())).toList();
    return all
        .where((item) =>
        item.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<void> addProduct(Item item) async {
    await _productsCollection.doc(item.id).set(item.toMap());
  }

  Future<void> updateProduct(Item item) async {
    await _productsCollection.doc(item.id).update(item.toMap());
  }

  Future<void> deleteProduct(String id) async {
    await _productsCollection.doc(id).delete();
  }

  CollectionReference<Map<String, dynamic>> get _logsCollection =>
      _firestore.collection('daily_logs');

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Future<List<Meal>> getMealsForDate(DateTime date) async {
    final doc = await _logsCollection.doc(_dateKey(date)).get();
    if (!doc.exists || doc.data() == null) {
      return Meal.defaultMeals;
    }
    final mealsData = doc.data()!['meals'] as List<dynamic>;
    return mealsData
        .map((m) => Meal.fromMap(m as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveMealsForDate(DateTime date, List<Meal> meals) async {
    await _logsCollection.doc(_dateKey(date)).set({
      'date': _dateKey(date),
      'meals': meals.map((m) => m.toMap()).toList(),
    });
  }

  CollectionReference<Map<String, dynamic>> get _userFoodsCollection =>
      _firestore.collection('user_foods');

  Future<List<Item>> getUserFoods() async {
    final snapshot = await _userFoodsCollection.get();
    return snapshot.docs.map((doc) => Item.fromMap(doc.data())).toList();
  }

  Future<void> addUserFood(Item item) async {
    await _userFoodsCollection.doc(item.id).set(item.toMap());
  }


}