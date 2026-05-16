import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_app/screens/nutrition/bloc/item_bloc.dart';
import 'package:nutrition_app/widgets/nutrition/food_item_2_widget.dart';

class FoodList extends StatelessWidget {
  final String title;

  const FoodList({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemBloc, ItemState>(
      builder: (context, state) {
        if (state is ItemInitial) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, size: 48, color: Colors.grey),
                SizedBox(height: 12),
                Text(
                  'Search for food to get started',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          );
        }
        if (state is ItemLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFA32D2D)),
          );
        }
        if (state is ItemLoaded) {
          if (state.items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.no_food, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    'No results found.',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              return FoodItem2(title: title, item: state.items[index]);
            },
          );
        }
        if (state is ItemError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const SizedBox.shrink();
      },
    );
  }
}