# Easily Kitchen

Семейное приложение для планирования питания, управления рецептами и списками покупок.

## Возможности

### Рецепты
- Создание, редактирование, удаление рецептов
- Поиск и фильтрация по категориям и кухням
- Калькулятор порций — масштабирование ингредиентов
- Пошаговый режим готовки с таймерами
- Избранные рецепты

### Кладовая
- Управление запасами продуктов
- Инлайн-редактирование количества
- Индикатор малого запаса
- Автоматическое списание при готовке

### Планировщик меню
- Неделя / 2 недели / месяц
- Слоты: завтрак, обед, ужин, перекус
- Назначение рецептов на каждый слот

### Список покупок
- Автогенерация из плана питания
- Учёт текущих запасов кладовой
- Ручное добавление товаров
- Отметка купленного

### Генератор рецептов
- "Что можно приготовить?"
- Мatching по ингредиентам из кладовой
- Процент совпадения

### Синхронизация
- Offline-first: работает без интернета
- Двусторонняя синхронизация Firestore ↔ SQLite
- Совместное использование мужем и женой

### История
- Журнал приготовленных блюд
- Статистика: популярные рецепты, количество готовок

## Технологии

| Слой | Технология |
|------|-----------|
| UI Framework | Flutter 3.x |
| Язык | Dart 3.x |
| State Management | Riverpod 2.x |
| Навигация | GoRouter 14.x |
| Локальная БД | Drift (SQLite) |
| Auth | Firebase Authentication |
| Облачная БД | Firebase Firestore |
| Архитектура | Clean Architecture + Feature First |

## Структура проекта

```
family_meal_planner/
├── lib/
│   ├── app.dart              # Корень приложения
│   ├── main.dart             # Точка входа
│   ├── core/                 # Общая инфраструктура
│   │   ├── constants/        # Константы, enum-ы
│   │   ├── database/         # Drift schema, DAO
│   │   ├── error/            # Failure классы
│   │   ├── export/           # Экспорт/импорт данных
│   │   ├── router/           # GoRouter конфигурация
│   │   ├── sync/             # Firestore синхронизация
│   │   ├── theme/            # Material 3 тема
│   │   ├── update/           # Обновления приложения
│   │   ├── utils/            # Утилиты
│   │   └── widgets/          # Общие виджеты
│   └── features/             # Модули по фичам
│       ├── auth/             # Авторизация
│       ├── favorites/        # Избранное
│       ├── history/          # История готовки
│       ├── meal_planner/     # Планировщик меню
│       ├── pantry/           # Кладовая
│       ├── recipe_generator/ # Генератор рецептов
│       ├── recipes/          # Рецепты
│       ├── settings/         # Настройки, категории
│       └── shopping/         # Списки покупок
├── test/                     # Тесты (110+)
├── assets/
│   └── icon/                 # Иконка приложения
├── android/                  # Android платформа
├── windows/                  # Windows платформа
└── pubspec.yaml
```

## Запуск

```bash
# Установка зависимостей
flutter pub get

# Генерация кода (Drift, Riverpod)
dart run build_runner build --delete-conflicting-outputs

# Запуск на Android
flutter run

# Запуск на Windows
flutter run -d windows

# Тесты
flutter test

# Анализ кода
flutter analyze
```

## Платформы

- **Android** —.bottom nav, камера для фото рецептов
- **Windows** — NavigationRail, file picker

## Тестирование

```bash
flutter test                    # 110+ тестов
flutter analyze                 # 0 ошибок
```

Покрытие:
- Unit tests: QuantityCalculator, Ingredient, ShoppingList generation, Pantry deduction
- Widget tests: ServingSelector, EmptyStateWidget, ConfirmDialog, RecipeCard

## Firebase

Для работы синхронизации и авторизации необходим Firebase проект:

1. Создайте проект в [Firebase Console](https://console.firebase.google.com/)
2. Добавьте Android и Windows приложения
3. Скачайте `google-services.json` (Android) и `firebase_options.dart`
4. Настройте Firestore и Authentication

## Лицензия

Приватное семейное приложение.
