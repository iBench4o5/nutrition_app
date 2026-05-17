import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nutrition_app/data/datasources/firebase_datasource.dart';
import 'package:nutrition_app/data/datasources/open_food_facts_datasource.dart';
import 'package:nutrition_app/data/repositories/item_repository.dart';
import 'package:nutrition_app/models/models.dart';

import 'item_repository_test.mocks.dart';

@GenerateMocks([FirebaseDatasource, OpenFoodFactsDatasource])
void main() {
  late MockFirebaseDatasource mockFirebase;
  late MockOpenFoodFactsDatasource mockOff;
  late ItemRepository repository;

  const localItem = Item(
    id: 'local-1', name: 'Chicken', calories: 104,
    weight: '100g', imageURL: '', protein: 23.0, fat: 1.1, carbs: 0.0,
  );

  const apiItem = Item(
    id: 'api-1', name: 'Banana', calories: 89,
    weight: '100g', imageURL: '', protein: 1.1, fat: 0.3, carbs: 23.0,
  );

  setUp(() {
    mockFirebase = MockFirebaseDatasource();
    mockOff = MockOpenFoodFactsDatasource();
    repository = ItemRepository(
      firebaseDatasource: mockFirebase,
      offDatasource: mockOff,
    );
  });

  group('ItemRepository', () {
    test('getAll() vraća proizvode iz Firebasea', () async {
      when(mockFirebase.getAllProducts())
          .thenAnswer((_) async => [localItem]);

      final result = await repository.getAll();

      expect(result.length, 1);
      expect(result.first.name, 'Chicken');
      verify(mockFirebase.getAllProducts()).called(1);
    });

    test('search() spaja lokalne i API rezultate', () async {
      when(mockFirebase.searchProducts('banana'))
          .thenAnswer((_) async => []);
      when(mockOff.searchByName('banana'))
          .thenAnswer((_) async => [apiItem]);

      final result = await repository.search('banana');

      expect(result.length, 1);
      expect(result.first.name, 'Banana');
    });

    test('search() ne duplicira iste proizvode', () async {
      when(mockFirebase.searchProducts('chicken'))
          .thenAnswer((_) async => [localItem]);
      when(mockOff.searchByName('chicken'))
          .thenAnswer((_) async => [localItem]);

      final result = await repository.search('chicken');

      expect(result.length, 1);
    });

    test('search() vraća lokalne rezultate ako API nije dostupan', () async {
      when(mockFirebase.searchProducts('chicken'))
          .thenAnswer((_) async => [localItem]);
      when(mockOff.searchByName('chicken'))
          .thenThrow(Exception('No internet'));

      final result = await repository.search('chicken');

      expect(result.length, 1);
      expect(result.first.name, 'Chicken');
    });

    test('add() poziva Firebase addProduct', () async {
      when(mockFirebase.addProduct(localItem))
          .thenAnswer((_) async {});

      await repository.add(localItem);

      verify(mockFirebase.addProduct(localItem)).called(1);
    });

    test('delete() poziva Firebase deleteProduct s ispravnim id-em', () async {
      when(mockFirebase.deleteProduct('local-1'))
          .thenAnswer((_) async {});

      await repository.delete('local-1');

      verify(mockFirebase.deleteProduct('local-1')).called(1);
    });

    test('getUserFoods() vraća user foods iz Firebasea', () async {
      when(mockFirebase.getUserFoods())
          .thenAnswer((_) async => [localItem]);

      final result = await repository.getUserFoods();

      expect(result.length, 1);
      verify(mockFirebase.getUserFoods()).called(1);
    });
  });
}