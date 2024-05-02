import 'package:flutter/material.dart';
import 'dart:io';
import 'foodrecognitionpage.dart';
import 'ingredientrecognitionpage.dart';

class RecognitionWrapperPage extends StatelessWidget {
  final File imageFile;

  RecognitionWrapperPage({required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        FoodRecognitionPage(foodImage: imageFile),
        IngredientRecognitionPage(ingredientImage: imageFile),
      ],
    );
  }
}
