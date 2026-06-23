# BUGS

## Исправленные

### BUG-001 — Undefined class 'CategoriesDao' (Этап 3.5)
**Файл:** `categories_provider.dart`  
**Причина:** Использовался `CategoriesDao` без прямого импорта  
**Исправление:** Добавлен `import '../../../../core/database/daos/categories_dao.dart'`

### BUG-002 — Deprecated `value` parameter (Этап 3.5)
**Файл:** `recipe_form_screen.dart` строки 304, 331  
**Причина:** `DropdownButtonFormField(value: ...)` устарел с Flutter 3.33  
**Исправление:** Заменено на `initialValue:` + `key: ValueKey(validValue)` (ADR-007)

### BUG-003 — 10 ошибок "Undefined name 'RoutePaths'" (Этап 1)
**Файл:** `app_shell.dart`  
**Причина:** Неправильный импорт `app_router.dart` вместо `route_names.dart`  
**Исправление:** Исправлен импорт

## Известные ограничения (не баги)

- `flutter analyze` недоступен в CI sandbox — проверяется вручную на машине разработчика
- Firebase (Auth + Firestore) закомментирован до Этапа 12
- `kDefaultFamilyId = 'default_family'` — placeholder до Этапа 12
