import 'package:flutter/material.dart';
import 'package:nutrition_app/widgets/nutrition/widgets.dart';

class AddFoodScreen extends StatefulWidget {
  final String title;

  const AddFoodScreen({super.key, required this.title});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
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
              searchBar(),
              Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  isScrollable: true,
                  labelColor: Colors.black,
                  indicatorColor: Colors.red,
                  tabs: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      // Adjust padding as needed
                      child: const Tab(text: 'Recommended'),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      // Adjust padding as needed
                      child: const Tab(text: 'All'),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      // Adjust padding as needed
                      child: const Tab(text: 'My Foods'),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      // Adjust padding as needed
                      child: const Tab(text: 'Favorites'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    FoodList(
                      title: widget.title,
                    ),
                    FoodList(
                      title: widget.title,
                    ),
                    FoodList(
                      title: widget.title,
                    ),
                    FoodList(
                      title: widget.title,
                    ),
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
            child: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.search, color: Colors.grey),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: InputBorder.none,
                    ),
                  ),
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
