import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_app/screens/nutrition/bloc/item_bloc.dart';
import 'package:nutrition_app/widgets/nutrition/widgets.dart';

class AddFoodScreen extends StatefulWidget {
  final String title;

  const AddFoodScreen({super.key, required this.title});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(widget.title),
          toolbarHeight: 60,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              searchBar(),
            const TabBar(
              isScrollable: false,
              labelColor: Colors.black,
              indicatorColor: Color(0xFFA32D2D),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(text: 'All'),
                Tab(text: 'My Foods'),
              ],
            ),
              Expanded(
                child: TabBarView(
                  children: [
                    FoodList(title: widget.title),
                    MyFoodsList(title: widget.title),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row searchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50.0,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.search, color: Colors.grey),
                ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      if (value.length >= 3 || value.isEmpty) {
                        context.read<ItemBloc>().add(
                              value.isEmpty
                                  ? LoadItemsEvent()
                                  : SearchItemsEvent(value),
                            );
                      }
                    },
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                      context.read<ItemBloc>().add(LoadItemsEvent());
                    },
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const QRViewExample(),
            ));
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(color: const Color(0xFFA32D2D)),
            ),
            padding: const EdgeInsets.all(4.0),
            child: const Icon(Icons.qr_code_scanner, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
