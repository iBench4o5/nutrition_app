import 'package:nutrition_app/data/datasources/firebase_datasource.dart';
import 'package:nutrition_app/data/datasources/open_food_facts_datasource.dart';
import 'package:nutrition_app/models/models.dart';

class ItemRepository {
  final FirebaseDatasource _firebase;
  final OpenFoodFactsDatasource _offApi;

  ItemRepository({
    FirebaseDatasource? firebaseDatasource,
    OpenFoodFactsDatasource? offDatasource,
  })  : _firebase = firebaseDatasource ?? FirebaseDatasource(),
        _offApi = offDatasource ?? OpenFoodFactsDatasource();

  Future<List<Item>> getAll() => _firebase.getAllProducts();

  // Pretražuje lokalno i s API-ja, spaja rezultate
  Future<List<Item>> search(String query) async {
    if (query.isEmpty) return getAll();

    final localResults = await _firebase.searchProducts(query);

    try {
      final apiResults = await _offApi.searchByName(query);

      // Spoji, ukloni duplikate po imenu
      final localNames = localResults.map((i) => i.name.toLowerCase()).toSet();
      final uniqueApiResults = apiResults
          .where((i) => !localNames.contains(i.name.toLowerCase()))
          .toList();

      return [...localResults, ...uniqueApiResults];
    } catch (_) {
      // Ako API nije dostupan, vrati samo lokalne
      return localResults;
    }
  }

  Future<Item?> searchByBarcode(String barcode) async {
    // Prvo provjeri lokalnu bazu
    final all = await _firebase.getAllProducts();
    final local = all.where((i) => i.id == barcode).firstOrNull;
    if (local != null) return local;

    // Ako nema lokalno, pitaj API
    return _offApi.searchByBarcode(barcode);
  }

  Future<void> add(Item item) => _firebase.addProduct(item);

  Future<void> update(Item item) => _firebase.updateProduct(item);

  Future<void> delete(String id) => _firebase.deleteProduct(id);

  Future<List<Item>> getUserFoods() => _firebase.getUserFoods();

  Future<void> addToUserFoods(Item item) => _firebase.addUserFood(item);
}
