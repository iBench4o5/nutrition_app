import 'package:flutter/material.dart';

class ClickableStar extends StatefulWidget {
  const ClickableStar({super.key});

  @override
  ClickableStarState createState() => ClickableStarState();
}

class ClickableStarState extends State<ClickableStar> {
  bool _isStarred = false;

  void _toggleStar() {
    setState(() {
      _isStarred = !_isStarred;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.star,
        color: _isStarred ? Colors.grey : const Color(0xFFA32D2D),
        size: 24,
      ),
      onPressed: _toggleStar,
    );
  }
}
