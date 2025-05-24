import 'package:flutter/material.dart';
import 'package:nutrition_app/widgets/nutrition/widgets.dart';
import 'package:nutrition_app/models/item_model.dart';

class AddFoodScreen extends StatefulWidget {
  final String title;

  const AddFoodScreen({super.key, required this.title});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Item> _filteredItems = List.from(Item.items);

  void _applyFilter() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = List.from(Item.items);
      } else {
        _filteredItems = Item.items
            .where((item) => item.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(widget.title),
          toolbarHeight: 60,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Row(
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
                              onSubmitted: (_) => _applyFilter(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
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
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  isScrollable: true,
                  labelColor: Colors.black,
                  indicatorColor: Colors.red,
                  tabs: const [
                    Tab(text: 'Recommended'),
                    Tab(text: 'All'),
                    Tab(text: 'My Foods'),
                    Tab(text: 'Favorites'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    FoodList(title: widget.title, items: _filteredItems),
                    FoodList(title: widget.title, items: _filteredItems),
                    FoodList(title: widget.title, items: _filteredItems),
                    FoodList(title: widget.title, items: _filteredItems),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
