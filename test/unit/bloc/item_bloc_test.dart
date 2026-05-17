import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nutrition_app/data/repositories/item_repository.dart';
import 'package:nutrition_app/models/models.dart';
import 'package:nutrition_app/screens/nutrition/bloc/item_bloc.dart';

import 'item_bloc_test.mocks.dart';

@GenerateMocks([ItemRepository])
void main() {
  late MockItemRepository mockItemRepository;

  const testItems = [
    Item(id: '1', name: 'Banana', calories: 89, weight: '100g',
        imageURL: '', protein: 1.1, fat: 0.3, carbs: 23.0),
    Item(id: '2', name: 'Apple', calories: 52, weight: '100g',
        imageURL: '', protein: 0.3, fat: 0.2, carbs: 14.0),
  ];

  setUp(() {
    mockItemRepository = MockItemRepository();
  });

  group('ItemBloc', () {
    blocTest<ItemBloc, ItemState>(
      'početni state je ItemInitial',
      build: () => ItemBloc(itemRepository: mockItemRepository),
      verify: (bloc) => expect(bloc.state, isA<ItemInitial>()),
    );

    blocTest<ItemBloc, ItemState>(
      'LoadItemsEvent vraća ItemInitial state',
      build: () => ItemBloc(itemRepository: mockItemRepository),
      act: (bloc) => bloc.add(LoadItemsEvent()),
      expect: () => [isA<ItemInitial>()],
    );

    blocTest<ItemBloc, ItemState>(
      'SearchItemsEvent emitira ItemLoading zatim ItemLoaded',
      build: () {
        when(mockItemRepository.search('banana'))
            .thenAnswer((_) async => [testItems.first]);
        return ItemBloc(itemRepository: mockItemRepository);
      },
      act: (bloc) => bloc.add(SearchItemsEvent('banana')),
      expect: () => [
        isA<ItemLoading>(),
        predicate<ItemState>((state) =>
        state is ItemLoaded && state.items.length == 1),
      ],
    );

    blocTest<ItemBloc, ItemState>(
      'SearchItemsEvent vraća sve rezultate pretrage',
      build: () {
        when(mockItemRepository.search('a'))
            .thenAnswer((_) async => testItems);
        return ItemBloc(itemRepository: mockItemRepository);
      },
      act: (bloc) => bloc.add(SearchItemsEvent('a')),
      expect: () => [
        isA<ItemLoading>(),
        predicate<ItemState>((state) =>
        state is ItemLoaded && state.items.length == 2),
      ],
    );

    blocTest<ItemBloc, ItemState>(
      'SearchItemsEvent emitira ItemError kod greške',
      build: () {
        when(mockItemRepository.search(any))
            .thenThrow(Exception('API error'));
        return ItemBloc(itemRepository: mockItemRepository);
      },
      act: (bloc) => bloc.add(SearchItemsEvent('banana')),
      expect: () => [
        isA<ItemLoading>(),
        isA<ItemError>(),
      ],
    );
  });
}