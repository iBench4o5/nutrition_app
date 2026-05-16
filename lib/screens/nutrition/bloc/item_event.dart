part of 'item_bloc.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent();
  @override
  List<Object> get props => [];
}

class LoadItemsEvent extends ItemEvent {}

class SearchItemsEvent extends ItemEvent {
  final String query;
  const SearchItemsEvent(this.query);

  @override
  List<Object> get props => [query];
}

class SearchByBarcodeEvent extends ItemEvent {
  final String barcode;
  const SearchByBarcodeEvent(this.barcode);

  @override
  List<Object> get props => [barcode];
}