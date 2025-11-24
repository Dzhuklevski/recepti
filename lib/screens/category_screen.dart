import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/meal_summary.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';
import '../models/meal_detail.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = '/category';
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late String category;
  List<MealSummary> meals = [];
  List<MealSummary> filtered = [];
  bool loading = true;
  final _searchCtrl = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    category = (args as String?) ?? 'Unknown';
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    setState(() => loading = true);
    try {
      final list = await ApiService.fetchMealsByCategory(category);
      setState(() {
        meals = list;
        filtered = list;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _onSearch(String q) async {
    final t = q.trim();
    if (t.isEmpty) {
      setState(() => filtered = meals);
      return;
    }
    setState(() => loading = true);
    final results = await ApiService.searchMeals(t, category: category);
    setState(() {
      filtered = results;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: 'Search dishes in $category...'),
              onSubmitted: _onSearch,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : filtered.isEmpty
                      ? const Center(child: Text('No dishes found'))
                      : GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: filtered.length,
                          itemBuilder: (context, i) {
                            final m = filtered[i];
                            return MealCard(
                              meal: m,
                              onTap: () async {
                                final detail = await ApiService.fetchMealDetail(m.id);
                                if (detail == null) return;
                                if (!mounted) return;
                                Navigator.pushNamed(context, MealDetailScreen.routeName, arguments: detail);
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
