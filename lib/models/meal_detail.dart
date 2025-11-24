class MealDetail {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumb;
  final List<Map<String, String>> ingredients;
  final String? youtube;

  MealDetail({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumb,
    required this.ingredients,
    this.youtube,
  });

  factory MealDetail.fromJson(Map<String, dynamic> j) {
  final ingredients = <Map<String, String>>[];

  for (var i = 1; i <= 20; i++) {
    final ingredient = j['strIngredient$i']?.toString().trim();
    final measure = j['strMeasure$i']?.toString().trim();

    if (ingredient != null && ingredient.isNotEmpty) {
      ingredients.add({
        'ingredient': ingredient,
        'measure': (measure != null && measure.isNotEmpty) ? measure : '',
      });
    }
  }

  return MealDetail(
    id: j['idMeal']?.toString() ?? '',
    name: j['strMeal']?.toString() ?? '',
    category: j['strCategory']?.toString() ?? '',
    area: j['strArea']?.toString() ?? '',
    instructions: j['strInstructions']?.toString() ?? '',
    thumb: j['strMealThumb']?.toString() ?? '',
    ingredients: ingredients, // <-- now List<Map<String,String>>
    youtube: (j['strYoutube']?.toString().trim().isNotEmpty ?? false)
        ? j['strYoutube'].toString()
        : null,
  );
}}