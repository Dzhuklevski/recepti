import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/meal_detail.dart';
import '../widgets/ingredient_list.dart';

class MealDetailScreen extends StatelessWidget {
  static const routeName = '/meal';
  const MealDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args == null) {
      return const Scaffold(
          body: Center(child: Text('No meal provided')));
    }
    final MealDetail meal = args as MealDetail;

    // Debug print (optional)
    print('Parsed ingredients: ${meal.ingredients}');

    return Scaffold(
      appBar: AppBar(title: Text(meal.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(meal.thumb,
                  height: 220, fit: BoxFit.cover),
            ),
            const SizedBox(height: 12),
            Text(meal.name,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Row(
              children: [
                Text('Category: ${meal.category}'),
                const SizedBox(width: 12),
                Text('Area: ${meal.area}')
              ],
            ),
            const SizedBox(height: 12),
            const Text('Ingredients',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            IngredientList(ingredients: meal.ingredients),
            const SizedBox(height: 12),
            const Text('Instructions',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(meal.instructions),
            const SizedBox(height: 16),
            meal.youtube != null && meal.youtube!.trim().isNotEmpty
    ? ElevatedButton.icon(
        onPressed: () async {
          final uri = Uri.parse(meal.youtube!);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri,
                mode: LaunchMode.externalApplication);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Could not open YouTube link')),
            );
          }
        },
        icon: const Icon(Icons.play_circle_fill),
        label: const Text('Watch on YouTube'),
      )
    : const Text(
        'No YouTube video available for this recipe',
        style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
      ),
          ],
        ),
      ),
    );
  }
}
