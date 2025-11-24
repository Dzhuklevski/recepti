import 'package:flutter/material.dart';

class IngredientList extends StatelessWidget {
  final List<Map<String, String>> ingredients;
  const IngredientList({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    if (ingredients.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text('No ingredients available.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < ingredients.length; i++) ...[
          _IngredientRow(
            ingredient: ingredients[i]['ingredient'] ?? '',
            measure: ingredients[i]['measure'] ?? '',
          ),
          if (i != ingredients.length - 1) const Divider(height: 12),
        ],
      ],
    );
  }
}

class _IngredientRow extends StatelessWidget {
  final String ingredient;
  final String measure;
  const _IngredientRow({required this.ingredient, required this.measure});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          const Icon(Icons.kitchen, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              ingredient,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          if (measure.isNotEmpty)
            Text(
              measure,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
        ],
      ),
    );
  }
}
