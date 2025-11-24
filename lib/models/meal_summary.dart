class MealSummary {
  final String id;
  final String name;
  final String thumb;
  final String? category; // optional, present in search results


  MealSummary({required this.id, required this.name, required this.thumb, this.category});


  factory MealSummary.fromJson(Map<String, dynamic> j) => MealSummary(
      id: j['idMeal'] as String,
      name: j['strMeal'] as String,
      thumb: j['strMealThumb'] as String,
      category: j['strCategory'] as String?,
  );
}