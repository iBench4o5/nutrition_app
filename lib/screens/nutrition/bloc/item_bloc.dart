import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nutrition_app/data/repositories/item_repository.dart';
import 'package:nutrition_app/models/models.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ItemRepository _itemRepository;

  ItemBloc({ItemRepository? itemRepository})
      : _itemRepository = itemRepository ?? ItemRepository(),
        super(ItemInitial()) {

    on<LoadItemsEvent>((event, emit) async {
      emit(ItemInitial());
    });

    on<SearchItemsEvent>((event, emit) async {
      emit(ItemLoading());
      try {
        final items = await _itemRepository.search(event.query);
        emit(ItemLoaded(items: items));
      } catch (e) {
        emit(ItemError(message: e.toString()));
      }
    });

    on<SearchByBarcodeEvent>((event, emit) async {
      emit(ItemLoading());
      try {
        final item = await _itemRepository.searchByBarcode(event.barcode);
        if (item != null) {
          emit(ItemLoaded(items: [item]));
        } else {
          emit(ItemError(message: 'Product not found'));
        }
      } catch (e) {
        emit(ItemError(message: e.toString()));
      }
    });
  }
}