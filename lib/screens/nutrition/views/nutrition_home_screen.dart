import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_app/screens/screens.dart';
import 'package:nutrition_app/widgets/nutrition/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: false,
            pinned: false,
            //toolbarHeight: 40,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
              onPressed: () {},
            ),
            actions: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Edit',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const CalorieCard(),
                BlocBuilder<MealBloc, MealState>(
                  builder: (context, state) {
                    if (state is MealInitial) {
                      return const CircularProgressIndicator(
                        color: Colors.orange,
                      );
                    }
                    if (state is MealLoaded) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int index = 0; index < state.meals.length; index++)
                            MealCard(
                              title: state.meals[index].name,
                              calories: state.meals[index].calories,
                              items: state.meals[index].items,
                            ),
                        ],
                      );
                    } else {
                      return const Text('Something went wrong!');
                    }
                  },
                ),
                buildNotes(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

Container bottomNavigationBar() {
    return Container(
      height: 65,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28), topRight: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, -1), // Offset in the upward direction
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.grey,
                  ),
                  onPressed: () {},
                ),
                const Column(
                  children: [
                    Text(
                      '21.05.2024.',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                    Text(
                      'Today',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    // Add your forward button action here
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding buildNotes() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: 60,
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 4,
          child: ListTile(
              title: const Text(
                'Notes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: GestureDetector(
                onTap: () {},
                child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    )),
              )),
        ),
      ),
    );
  }

}
