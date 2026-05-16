import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_app/data/repositories/item_repository.dart';
import 'package:nutrition_app/data/repositories/meal_repository.dart';
import 'package:nutrition_app/firebase_options.dart';
import 'package:nutrition_app/screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => ItemRepository()),
        RepositoryProvider(create: (_) => MealRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MealBloc(
              mealRepository: context.read<MealRepository>(),
            )..add(LoadMealCaloriesEvent()),
          ),
          BlocProvider(
            create: (context) => ItemBloc(
              itemRepository: context.read<ItemRepository>(),
            )..add(LoadItemsEvent()),
          ),
        ],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomePage(),
        ),
      ),
    );
  }
}