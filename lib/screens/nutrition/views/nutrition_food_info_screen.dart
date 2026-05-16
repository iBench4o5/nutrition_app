import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_app/models/models.dart';
import 'package:nutrition_app/screens/screens.dart';
import 'package:nutrition_app/widgets/nutrition/widgets.dart';

String? globalSelectedOption;

class FoodDetail extends StatefulWidget {
  final String title;
  final Item item;
  final bool isEditing;
  final int itemIndex;

  const FoodDetail({
    super.key,
    required this.title,
    required this.item,
    this.isEditing = false,
    this.itemIndex = 0,
  });

  @override
  State<FoodDetail> createState() => _FoodDetailState();
}

class _FoodDetailState extends State<FoodDetail> {
  final TextEditingController _gramsController =
  TextEditingController(text: '100');
  double _multiplier = 1.0;
  late Item _baseItem;

  @override
  void initState() {
    super.initState();
    globalSelectedOption = widget.title;

    final weightStr = widget.item.weight.replaceAll(RegExp(r'[^0-9.]'), '');
    final initialGrams = double.tryParse(weightStr) ?? 100.0;
    _gramsController.text = initialGrams.toInt().toString();
    _multiplier = initialGrams / 100.0;

    if (widget.isEditing && initialGrams != 100.0) {
      final factor = 100.0 / initialGrams;
      _baseItem = widget.item.copyWith(
        calories: (widget.item.calories * factor).round(),
        protein: widget.item.protein * factor,
        carbs: widget.item.carbs * factor,
        fat: widget.item.fat * factor,
        weight: '100g',
      );
    } else {
      _baseItem = widget.item;
    }
  }

  @override
  void dispose() {
    _gramsController.dispose();
    super.dispose();
  }

  double _scaled(double value) => value * _multiplier;
  int _scaledCalories() => (_baseItem.calories * _multiplier).round();

  Item _buildScaledItem() {
    return _baseItem.copyWith(
      calories: _scaledCalories(),
      protein: _scaled(_baseItem.protein),
      carbs: _scaled(_baseItem.carbs),
      fat: _scaled(_baseItem.fat),
      weight: '${_gramsController.text}g',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Food info'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildImage(),
            const SizedBox(height: 16),
            _buildGeneralInfo(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCaloriesBar(_scaledCalories()),
                _buildMacroBox('Carbs', _scaled(_baseItem.carbs), Colors.green[400]!),
                _buildMacroBox('Fat', _scaled(_baseItem.fat), Colors.deepOrangeAccent[100]!),
                _buildMacroBox('Protein', _scaled(_baseItem.protein), Colors.lightBlueAccent[100]!),
              ],
            ),
            const SizedBox(height: 16),
            widget.isEditing
                ? ElevatedButton(
              onPressed: () {
                final mealBloc = context.read<MealBloc>();
                final state = mealBloc.state;

                if (state is MealLoaded) {
                  final scaledItem = _buildScaledItem();

                  if (globalSelectedOption != null &&
                      globalSelectedOption != widget.title) {
                    final oldMeal = state.meals
                        .firstWhere((m) => m.name == widget.title);
                    mealBloc.add(
                        RemoveItemEvent(oldMeal, index: widget.itemIndex));

                    final newMeal = state.meals.firstWhere(
                            (m) => m.name == globalSelectedOption);
                    mealBloc.add(AddItemEvent(newMeal, item: scaledItem));
                  } else {
                    final meal = state.meals
                        .firstWhere((m) => m.name == widget.title);
                    mealBloc.add(UpdateItemEvent(meal,
                        index: widget.itemIndex, newItem: scaledItem));
                  }
                }

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                side: const BorderSide(color: Color(0xFFA32D2D), width: 2),
                padding: const EdgeInsets.symmetric(
                    horizontal: 50, vertical: 8),
              ),
              child: const Text(
                'Apply',
                style: TextStyle(
                  color: Color(0xFFA32D2D),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            )
                : ElevatedButton(
              onPressed: () {
                final mealBloc = context.read<MealBloc>();
                final state = mealBloc.state;

                if (state is MealLoaded) {
                  final meal = state.meals.firstWhere(
                          (meal) => meal.name == globalSelectedOption);
                  mealBloc
                      .add(AddItemEvent(meal, item: _buildScaledItem()));
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Item added to $globalSelectedOption',
                      style: const TextStyle(
                          color: Colors.black, fontSize: 14),
                    ),
                    duration: const Duration(seconds: 1),
                    backgroundColor: Colors.orangeAccent,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                side: const BorderSide(color: Color(0xFFA32D2D), width: 2),
                padding: const EdgeInsets.symmetric(
                    horizontal: 50, vertical: 8),
              ),
              child: const Text(
                '+ Add food',
                style: TextStyle(
                  color: Color(0xFFA32D2D),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Column(
      children: [
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 1),
              ),
            ],
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: widget.item.imageURL.isEmpty
                ? const _NoImage()
                : Image.network(
              widget.item.imageURL,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
              const _NoImage(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.item.name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGeneralInfo() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Serving size (g)', style: TextStyle(fontSize: 16)),
            Container(
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _gramsController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(10.0),
                ),
                onChanged: (value) {
                  final grams = double.tryParse(value) ?? 100;
                  setState(() {
                    _multiplier = grams / 100.0;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Meal', style: TextStyle(fontSize: 16)),
            Container(
              width: 150,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: MyDropdown(initialValue: widget.title),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMacroBox(String label, double value, Color color) {
    return Container(
      width: 65,
      height: 60,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
          Text(
            value % 1 == 0
                ? '${value.toInt()}g'
                : '${value.toStringAsFixed(1)}g',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCaloriesBar(int calories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Calories', style: TextStyle(fontSize: 12)),
        Text(
          '${calories}cal',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        Container(
          height: 6,
          width: 140,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                height: 6,
                width: 140 * 0.3,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
              Container(
                height: 6,
                width: 140 * 0.25,
                decoration:
                BoxDecoration(color: Colors.deepOrangeAccent[100]),
              ),
              Container(
                height: 6,
                width: 140 * 0.45,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MyDropdown extends StatefulWidget {
  final String initialValue;

  const MyDropdown({super.key, required this.initialValue});

  @override
  MyDropdownState createState() => MyDropdownState();
}

class MyDropdownState extends State<MyDropdown> {
  final List<String> options =
  Meal.defaultMeals.map((meal) => meal.name).toList();
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.white),
      child: DropdownButtonFormField<String>(
        value: selectedOption,
        isExpanded: true,
        alignment: Alignment.center,
        style: const TextStyle(
          color: Color(0xFFA32D2D),
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(10.0),
        ),
        hint: Text(
          widget.initialValue,
          style: const TextStyle(
            color: Color(0xFFA32D2D),
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        onChanged: (String? newValue) {
          setState(() {
            selectedOption = newValue;
            globalSelectedOption = selectedOption;
          });
        },
        items: options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}

class _NoImage extends StatelessWidget {
  const _NoImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2F2F2),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fastfood, color: Colors.grey, size: 60),
          Text('No image', style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}