enum RecipeCategory {
  hotDish('Горячее', 'hot_dish'),
  soup('Суп', 'soup'),
  salad('Салат', 'salad'),
  side('Гарнир', 'side'),
  baking('Выпечка', 'baking'),
  dessert('Десерт', 'dessert'),
  breakfast('Завтрак', 'breakfast'),
  appetizer('Закуска', 'appetizer'),
  drink('Напиток', 'drink'),
  other('Другое', 'other');

  const RecipeCategory(this.label, this.value);
  final String label;
  final String value;

  static RecipeCategory fromValue(String value) =>
      RecipeCategory.values.firstWhere((e) => e.value == value,
          orElse: () => RecipeCategory.other);
}

enum Cuisine {
  russian('Русская', 'russian'),
  european('Европейская', 'european'),
  asian('Азиатская', 'asian'),
  italian('Итальянская', 'italian'),
  french('Французская', 'french'),
  american('Американская', 'american'),
  eastern('Восточная', 'eastern'),
  other('Другое', 'other');

  const Cuisine(this.label, this.value);
  final String label;
  final String value;

  static Cuisine fromValue(String value) =>
      Cuisine.values.firstWhere((e) => e.value == value,
          orElse: () => Cuisine.other);
}

enum PantryCategory {
  vegetables('Овощи', 'vegetables'),
  fruits('Фрукты', 'fruits'),
  meat('Мясо', 'meat'),
  fish('Рыба', 'fish'),
  dairy('Молочные', 'dairy'),
  grains('Крупы', 'grains'),
  pasta('Макароны', 'pasta'),
  spices('Специи', 'spices'),
  baking('Выпечка', 'baking'),
  frozen('Заморозка', 'frozen'),
  drinks('Напитки', 'drinks'),
  canned('Консервы', 'canned'),
  other('Прочее', 'other');

  const PantryCategory(this.label, this.value);
  final String label;
  final String value;

  static PantryCategory fromValue(String value) =>
      PantryCategory.values.firstWhere((e) => e.value == value,
          orElse: () => PantryCategory.other);
}

enum MeasurementUnit {
  g('г', 'g'),
  kg('кг', 'kg'),
  ml('мл', 'ml'),
  l('л', 'l'),
  pcs('шт', 'pcs'),
  tbsp('ст.л.', 'tbsp'),
  tsp('ч.л.', 'tsp'),
  cup('стакан', 'cup'),
  pinch('щепотка', 'pinch');

  const MeasurementUnit(this.label, this.value);
  final String label;
  final String value;

  static MeasurementUnit fromValue(String value) =>
      MeasurementUnit.values.firstWhere((e) => e.value == value,
          orElse: () => MeasurementUnit.g);
}

enum MealType {
  breakfast('Завтрак', 'breakfast'),
  lunch('Обед', 'lunch'),
  dinner('Ужин', 'dinner'),
  snack('Перекус', 'snack');

  const MealType(this.label, this.value);
  final String label;
  final String value;

  static MealType fromValue(String value) =>
      MealType.values.firstWhere((e) => e.value == value,
          orElse: () => MealType.lunch);
}

enum ThemeMode {
  system('Системная'),
  light('Светлая'),
  dark('Тёмная');

  const ThemeMode(this.label);
  final String label;
}

enum SyncStatus {
  idle,
  syncing,
  error,
  offline,
}
