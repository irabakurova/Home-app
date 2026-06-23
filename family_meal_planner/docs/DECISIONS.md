# ARCHITECTURE DECISIONS

## ADR-001 — Feature First Architecture
**Решение:** `lib/features/<feature>/domain|data|presentation`  
**Причина:** Изоляция фич, упрощает масштабирование и поиск кода

## ADR-002 — Drift ORM
**Решение:** Drift 2.x + SQLite  
**Причина:** Типобезопасные запросы, реактивные стримы, поддержка миграций

## ADR-003 — Riverpod 2 (код-генерация)
**Решение:** `riverpod_annotation` + build_runner  
**Причина:** Компайл-тайм безопасность, автоматический lifecycle

## ADR-004 — GoRouter ShellRoute
**Решение:** `ShellRoute` для bottom nav, вложенные `GoRoute` для детальных экранов  
**Причина:** Сохранение состояния вкладок, глубокие ссылки

## ADR-005 — String slugs для категорий
**Решение:** `Recipe.category` и `PantryItem.category` хранятся как String slug (`'hot_dish'`, `'vegetables'`)  
**Причина:** Поддержка кастомных пользовательских категорий без изменения схемы. Slug из `CategoriesTable.value`

## ADR-006 — CategoriesTable (schemaVersion 2)
**Решение:** Единая таблица категорий с полем `type` (`'recipe'|'cuisine'|'pantry'`) и флагом `isSystem`  
**Причина:** Расширяемость без новых таблиц, защита системных категорий от удаления

## ADR-007 — DropdownButtonFormField + `key: ValueKey`
**Решение:** При программном изменении значения дропдауна используем `key: ValueKey(validValue)` + `initialValue`  
**Причина:** `initialValue` устанавливается только в `initState`. `ValueKey` заставляет виджет пересоздаться при смене значения (нужно при `_loadRecipe()`)

## ADR-008 — Inline quantity editing (PantryItemTile)
**Решение:** Tap по бейджу → inline TextField → сохранение при `onSubmitted`/`onTapOutside`  
**Причина:** Ускоренный UX — не нужно открывать форму для изменения количества

## ADR-009 — kDefaultFamilyId placeholder
**Решение:** `const kDefaultFamilyId = 'default_family'` до Этапа 12  
**Причина:** Откладывает Firebase зависимость, не блокирует разработку фич
