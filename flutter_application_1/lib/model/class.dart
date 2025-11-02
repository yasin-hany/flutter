class Recipe {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbnail;
  final String youtube;
  final String source;
  final List<String> ingredients;
  final List<String> measurements;
  Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnail,
    required this.youtube,
    required this.source,
    required this.ingredients,
    required this.measurements,
  });
  factory Recipe.fromJson(Map<String, dynamic> json) {
    final List<String> ingredients = [];
    final List<String> measurements = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add(ingredient);
        measurements.add(measure ?? '');
      } else {
        break;
      }
    }
    final mealData = json['meals'] != null && json['meals'].isNotEmpty
        ? json['meals'][0]
        : <String, dynamic>{};
    return Recipe(
      id: mealData['idMeal'] ?? '',
      name: mealData['strMeal'],
      category: mealData['strCategory'] ,
      area: mealData['strArea'] ?? 'Global',
      instructions: mealData['strInstructions'] ,
      thumbnail: mealData['strMealThumb'] ,
      youtube: mealData['strYoutube'] ,
      source: mealData['strSource'] ,
      ingredients: ingredients,
      measurements: measurements,
    );
  }
}