part of 'item_bloc.dart';

abstract class ItemState extends Equatable {
  @override
  List<Object> get props => [];
}

class ItemInitial extends ItemState {}

class ItemLoading extends ItemState {}

class ItemLoaded extends ItemState {
  final List<Item> items;
  ItemLoaded({required this.items});

  @override
  List<Object> get props => [items];
}

class ItemError extends ItemState {
  final String message;
  ItemError({required this.message});

  @override
  List<Object> get props => [message];
}