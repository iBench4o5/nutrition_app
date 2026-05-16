import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nutrition_app/models/models.dart';

class OpenFoodFactsDatasource {
  static const String _baseUrl = 'https://world.openfoodfacts.org';

  // Pretraživanje po imenu
  Future<List<Item>> searchByName(String query) async {
    final uri = Uri.parse(
      '$_baseUrl/cgi/search.pl?search_terms=${Uri.encodeComponent(query)}&json=1&page_size=20&fields=id,product_name,nutriments,image_url,quantity',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('OFF API error: ${response.statusCode}');
    }

    final data = json.decode(response.body) as Map<String, dynamic>;
    final products = data['products'] as List<dynamic>? ?? [];

    return products
        .map((p) => _parseProduct(p as Map<String, dynamic>))
        .where((item) => item != null)
        .cast<Item>()
        .toList();
  }

  // Dohvat po barkodu
  Future<Item?> searchByBarcode(String barcode) async {
    final uri = Uri.parse('$_baseUrl/api/v0/product/$barcode.json');
    final response = await http.get(uri);

    if (response.statusCode != 200) return null;

    final data = json.decode(response.body) as Map<String, dynamic>;
    if (data['status'] != 1) return null;

    final product = data['product'] as Map<String, dynamic>?;
    if (product == null) return null;

    return _parseProduct(product);
  }

  Item? _parseProduct(Map<String, dynamic> product) {
    try {
      final name = product['product_name'] as String?;
      if (name == null || name.isEmpty) return null;

      final nutriments = product['nutriments'] as Map<String, dynamic>? ?? {};

      final calories = (nutriments['energy-kcal_100g'] as num?)?.toInt() ??
          (nutriments['energy-kcal'] as num?)?.toInt() ??
          0;
      final protein = (nutriments['proteins_100g'] as num?)?.toDouble() ?? 0.0;
      final carbs = (nutriments['carbohydrates_100g'] as num?)?.toDouble() ?? 0.0;
      final fat = (nutriments['fat_100g'] as num?)?.toDouble() ?? 0.0;

      final imageUrl = product['image_url'] as String? ?? '';
      final quantity = product['quantity'] as String? ?? '100g';
      final offId = product['id'] as String? ?? product['_id'] as String? ?? Item.generateId();

      return Item(
        id: offId,
        name: name,
        calories: calories,
        weight: quantity,
        imageURL: imageUrl,
        protein: protein,
        carbs: carbs,
        fat: fat,
      );
    } catch (_) {
      return null;
    }
  }
}