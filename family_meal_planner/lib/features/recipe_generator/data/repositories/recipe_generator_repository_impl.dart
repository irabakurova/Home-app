import '../../../../core/database/daos/pantry_dao.dart';
import '../../../../core/database/daos/recipes_dao.dart';
import '../../../recipes/data/models/recipe_mapper.dart';
import '../../domain/entities/recipe_suggestion.dart';
import '../../domain/repositories/recipe_generator_repository.dart';

class RecipeGeneratorRepositoryImpl implements RecipeGeneratorRepository {
  RecipeGeneratorRepositoryImpl(this._recipesDao, this._pantryDao);

  final RecipesDao _recipesDao;
  final PantryDao _pantryDao;

  @override
  Future<List<RecipeSuggestion>> getSuggestions(String familyId) async {
    // 1. Load pantry — build a fast lookup map: name_lowercase → quantity
    final pantryRows = await _pantryDao.getAll(familyId);
    final pantryMap = <String, double>{};
    for (final row in pantryRows) {
      final key = row.name.toLowerCase().trim();
      // Accumulate quantities for same-name items in different units
      pantryMap[key] = (pantryMap[key] ?? 0) + row.quantity;
    }

    // 2. Load all recipes (one-shot from stream)
    final recipeRows = await _recipesDao.watchAll(familyId).first;
    if (recipeRows.isEmpty) return [];

    final suggestions = <RecipeSuggestion>[];

    for (final recipeRow in recipeRows) {
      final recipe = RecipeMapper.fromDb(recipeRow);

      // 3. Load ingredients for this recipe
      final ingRows = await _recipesDao.getByRecipe(recipe.id);
      if (ingRows.isEmpty) continue;

      final ingredients =
          ingRows.map(RecipeMapper.ingredientFromDb).toList();

      final available = <String>[];
      final missing = <MissingIngredient>[];

      for (final ing in ingredients) {
        final qty = _findPantryQty(pantryMap, ing.name);
        if (qty > 0) {
          available.add(ing.name);
        } else {
          missing.add(MissingIngredient(
            name: ing.name,
            quantityNeeded: ing.quantity,
            unit: ing.unit,
          ));
        }
      }

      // Skip recipes with zero pantry overlap
      if (available.isEmpty) continue;

      final matchPercent = available.length / ingredients.length;

      suggestions.add(RecipeSuggestion(
        recipe: recipe,
        matchPercent: matchPercent,
        available: available,
        missing: missing,
      ));
    }

    // 4. Sort: fully available first, then by match % descending
    suggestions.sort((a, b) => b.matchPercent.compareTo(a.matchPercent));

    return suggestions;
  }

  /// Russian culinary informal-name → canonical root fragment.
  ///
  /// When a recipe uses a colloquial shorthand (e.g. "манка") and the pantry
  /// stores the formal name ("манная крупа"), neither exact nor substring
  /// matching works because the words share a semantic root but differ in
  /// form.  This table maps the informal name to the first few characters of
  /// the formal adjective so a `.contains()` check on the pantry key succeeds.
  ///
  /// Format:  'informal_name': 'root_fragment_of_formal_name'
  static const Map<String, String> _foodAliases = {
    // Крупы
    'манка':    'манн',   // манка  ↔ манная крупа
    'гречка':   'гречн',  // гречка ↔ гречневая крупа
    'перловка': 'перлов', // перловка ↔ перловая крупа
    'пшёнка':   'пшённ',  // пшёнка  ↔ пшённая крупа
    'пшенка':   'пшенн',  // without ё
    'овсянка':  'овсян',  // овсянка ↔ овсяная каша/крупа
    // Овощи / фрукты
    'картошка': 'картоф', // картошка ↔ картофель
    'картофан': 'картоф',
    'помидор':  'томат',  // помидор  ↔ томат (different root — explicit map)
    'томат':    'помид',  // reverse
    // Мясо
    'курица':   'кури',   // курица ↔ куриное филе / куриная грудка
    'говядина': 'говяд',
    'свинина':  'свин',
    // Misc
    'лимонка':  'лимонн', // лимонка ↔ лимонная кислота
  };

  /// Fuzzy pantry lookup for an ingredient name.
  ///
  /// Matching priority:
  ///   1. Exact lowercase match  ("соль" == "соль")
  ///   2. Substring              ("соль йодированная" contains "соль")
  ///   3. Word-overlap           (all meaningful words of ingredient in pantry)
  ///   4. Russian food alias     ("манка" → alias "манн" → "манная крупа" ✓)
  ///
  /// Returns the pantry quantity, or 0 if no match.
  double _findPantryQty(Map<String, double> pantryMap, String ingName) {
    final ingNorm = ingName.toLowerCase().trim();

    // 1. Exact match (fast path)
    if (pantryMap.containsKey(ingNorm)) return pantryMap[ingNorm]!;

    // 2. Substring match
    for (final entry in pantryMap.entries) {
      final pantryNorm = entry.key;
      if (pantryNorm.contains(ingNorm) || ingNorm.contains(pantryNorm)) {
        return entry.value;
      }
    }

    // 3. Word-overlap match (all words ≥ 3 chars of ingredient found in pantry)
    final words = ingNorm
        .split(RegExp(r'\s+'))
        .where((w) => w.length >= 3)
        .toList();
    if (words.isNotEmpty) {
      for (final entry in pantryMap.entries) {
        if (words.every((w) => entry.key.contains(w))) {
          return entry.value;
        }
      }
    }

    // 4. Russian culinary alias match
    //    a) ingredient name is an informal alias → look for its formal root in pantry
    final ingAlias = _foodAliases[ingNorm];
    if (ingAlias != null) {
      for (final entry in pantryMap.entries) {
        if (entry.key.contains(ingAlias)) return entry.value;
      }
    }
    //    b) ingredient contains a word that is an alias → same check
    for (final word in ingNorm.split(RegExp(r'\s+'))) {
      final wordAlias = _foodAliases[word];
      if (wordAlias != null) {
        for (final entry in pantryMap.entries) {
          if (entry.key.contains(wordAlias)) return entry.value;
        }
      }
    }
    //    c) pantry item word is an alias → check if its root appears in ingredient
    for (final entry in pantryMap.entries) {
      for (final pantryWord in entry.key.split(RegExp(r'\s+'))) {
        final pantryAlias = _foodAliases[pantryWord];
        if (pantryAlias != null && ingNorm.contains(pantryAlias)) {
          return entry.value;
        }
      }
    }

    return 0;
  }
}
