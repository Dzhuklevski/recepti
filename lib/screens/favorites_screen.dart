import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../services/api_service.dart';
import 'meal_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseService = FirebaseService();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Meals')),
      body: StreamBuilder(
        stream: firebaseService.getFavorites(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('No favorites yet'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final meal = docs[index];

              return ListTile(
                leading: Image.network(meal['thumbnail']),
                title: Text(meal['name']),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () async {
                  final detail =
                      await ApiService.fetchMealDetail(meal['id']);
                  if (detail == null) return;

                  Navigator.pushNamed(
                    context,
                    MealDetailScreen.routeName,
                    arguments: detail,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
