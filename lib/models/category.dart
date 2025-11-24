class Category {
  final String id;
  final String name;
  final String thumb;
  final String description;


  Category({
    required this.id,
    required this.name,
    required this.thumb,
    required this.description,
  });


  factory Category.fromJson(Map<String, dynamic> j) => Category(
    id: j['idCategory'] as String,
    name: j['strCategory'] as String,
    thumb: j['strCategoryThumb'] as String,
    description: j['strCategoryDescription'] as String,
   );
}