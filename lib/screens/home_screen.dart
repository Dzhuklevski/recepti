import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/api_service.dart';
import '../widgets/category_card.dart';
import 'category_screen.dart';
import 'meal_detail_screen.dart';
import '../models/meal_detail.dart';
import 'favorites_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Category>> _future;
  List<Category> _categories = [];
  List<Category> _filtered = [];
  final _searchCtrl = TextEditingController();

  @override
void initState() {
  super.initState();

  // ------------------------------
  // Initialize Firebase Messaging
  FirebaseMessaging.instance.requestPermission();

  FirebaseMessaging.instance.getToken().then((token) {
    debugPrint('FCM Token: $token');
    // You can also send this token to your server if needed
  });

  // Optional: handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('Received a message while in foreground: ${message.notification?.title}');
  });
  // ------------------------------

  // Existing code
  _future = ApiService.fetchCategories();
  _future.then((value) {
    setState(() {
      _categories = value;
      _filtered = value;
    });
  }).catchError((e) {
    // ignore errors here; FutureBuilder will also show error if needed
  });
}


  void _onSearchChanged() {
    final q = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) _filtered = _categories;
      else _filtered = _categories.where((c) => c.name.toLowerCase().contains(q)).toList();
    });
  }

  Future<void> _openRandom() async {
    final meal = await ApiService.fetchRandomMeal();
    if (meal == null) return;
    if (!mounted) return;
    Navigator.pushNamed(context, MealDetailScreen.routeName, arguments: meal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MealDB Categories'),
        actions: [
  IconButton(
    icon: const Icon(Icons.favorite),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const FavoritesScreen(),
        ),
      );
    },
  ),
  Padding(
    padding: const EdgeInsets.only(right: 12),
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      icon: const Icon(Icons.auto_awesome,),
      label: const Text("Random"),
      onPressed: _openRandom,
    ),
  ),
],


      ),
      body: FutureBuilder<List<Category>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchCtrl,
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search categories...'),
                  onChanged: (_) => _onSearchChanged(),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _filtered.isEmpty
                      ? const Center(child: Text('No categories found'))
                      : ListView.builder(
                          itemCount: _filtered.length,
                          itemBuilder: (context, i) {
                            final cat = _filtered[i];
                            return CategoryCard(
                              category: cat,
                              onTap: () => Navigator.pushNamed(context, CategoryScreen.routeName, arguments: cat.name),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
