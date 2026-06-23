// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RecipesTableTable extends RecipesTable
    with TableInfo<$RecipesTableTable, RecipesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _familyIdMeta =
      const VerificationMeta('familyId');
  @override
  late final GeneratedColumn<String> familyId = GeneratedColumn<String>(
      'family_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _photoUrlMeta =
      const VerificationMeta('photoUrl');
  @override
  late final GeneratedColumn<String> photoUrl = GeneratedColumn<String>(
      'photo_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cuisineMeta =
      const VerificationMeta('cuisine');
  @override
  late final GeneratedColumn<String> cuisine = GeneratedColumn<String>(
      'cuisine', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cookTimeMinutesMeta =
      const VerificationMeta('cookTimeMinutes');
  @override
  late final GeneratedColumn<int> cookTimeMinutes = GeneratedColumn<int>(
      'cook_time_minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(30));
  static const VerificationMeta _defaultServingsMeta =
      const VerificationMeta('defaultServings');
  @override
  late final GeneratedColumn<int> defaultServings = GeneratedColumn<int>(
      'default_servings', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(4));
  static const VerificationMeta _instructionsMeta =
      const VerificationMeta('instructions');
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
      'instructions', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isFavoriteMeta =
      const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        familyId,
        title,
        description,
        photoUrl,
        category,
        cuisine,
        cookTimeMinutes,
        defaultServings,
        instructions,
        isFavorite,
        createdBy,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes';
  @override
  VerificationContext validateIntegrity(Insertable<RecipesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('family_id')) {
      context.handle(_familyIdMeta,
          familyId.isAcceptableOrUnknown(data['family_id']!, _familyIdMeta));
    } else if (isInserting) {
      context.missing(_familyIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('photo_url')) {
      context.handle(_photoUrlMeta,
          photoUrl.isAcceptableOrUnknown(data['photo_url']!, _photoUrlMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('cuisine')) {
      context.handle(_cuisineMeta,
          cuisine.isAcceptableOrUnknown(data['cuisine']!, _cuisineMeta));
    } else if (isInserting) {
      context.missing(_cuisineMeta);
    }
    if (data.containsKey('cook_time_minutes')) {
      context.handle(
          _cookTimeMinutesMeta,
          cookTimeMinutes.isAcceptableOrUnknown(
              data['cook_time_minutes']!, _cookTimeMinutesMeta));
    }
    if (data.containsKey('default_servings')) {
      context.handle(
          _defaultServingsMeta,
          defaultServings.isAcceptableOrUnknown(
              data['default_servings']!, _defaultServingsMeta));
    }
    if (data.containsKey('instructions')) {
      context.handle(
          _instructionsMeta,
          instructions.isAcceptableOrUnknown(
              data['instructions']!, _instructionsMeta));
    } else if (isInserting) {
      context.missing(_instructionsMeta);
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      familyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}family_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      photoUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_url']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      cuisine: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cuisine'])!,
      cookTimeMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cook_time_minutes'])!,
      defaultServings: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}default_servings'])!,
      instructions: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}instructions'])!,
      isFavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $RecipesTableTable createAlias(String alias) {
    return $RecipesTableTable(attachedDatabase, alias);
  }
}

class RecipesTableData extends DataClass
    implements Insertable<RecipesTableData> {
  final String id;
  final String familyId;
  final String title;
  final String? description;
  final String? photoUrl;
  final String category;
  final String cuisine;
  final int cookTimeMinutes;
  final int defaultServings;
  final String instructions;
  final bool isFavorite;
  final String createdBy;
  final int createdAt;
  final int updatedAt;
  const RecipesTableData(
      {required this.id,
      required this.familyId,
      required this.title,
      this.description,
      this.photoUrl,
      required this.category,
      required this.cuisine,
      required this.cookTimeMinutes,
      required this.defaultServings,
      required this.instructions,
      required this.isFavorite,
      required this.createdBy,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['family_id'] = Variable<String>(familyId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || photoUrl != null) {
      map['photo_url'] = Variable<String>(photoUrl);
    }
    map['category'] = Variable<String>(category);
    map['cuisine'] = Variable<String>(cuisine);
    map['cook_time_minutes'] = Variable<int>(cookTimeMinutes);
    map['default_servings'] = Variable<int>(defaultServings);
    map['instructions'] = Variable<String>(instructions);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['created_by'] = Variable<String>(createdBy);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  RecipesTableCompanion toCompanion(bool nullToAbsent) {
    return RecipesTableCompanion(
      id: Value(id),
      familyId: Value(familyId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      photoUrl: photoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(photoUrl),
      category: Value(category),
      cuisine: Value(cuisine),
      cookTimeMinutes: Value(cookTimeMinutes),
      defaultServings: Value(defaultServings),
      instructions: Value(instructions),
      isFavorite: Value(isFavorite),
      createdBy: Value(createdBy),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RecipesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipesTableData(
      id: serializer.fromJson<String>(json['id']),
      familyId: serializer.fromJson<String>(json['familyId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      photoUrl: serializer.fromJson<String?>(json['photoUrl']),
      category: serializer.fromJson<String>(json['category']),
      cuisine: serializer.fromJson<String>(json['cuisine']),
      cookTimeMinutes: serializer.fromJson<int>(json['cookTimeMinutes']),
      defaultServings: serializer.fromJson<int>(json['defaultServings']),
      instructions: serializer.fromJson<String>(json['instructions']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'familyId': serializer.toJson<String>(familyId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'photoUrl': serializer.toJson<String?>(photoUrl),
      'category': serializer.toJson<String>(category),
      'cuisine': serializer.toJson<String>(cuisine),
      'cookTimeMinutes': serializer.toJson<int>(cookTimeMinutes),
      'defaultServings': serializer.toJson<int>(defaultServings),
      'instructions': serializer.toJson<String>(instructions),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'createdBy': serializer.toJson<String>(createdBy),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  RecipesTableData copyWith(
          {String? id,
          String? familyId,
          String? title,
          Value<String?> description = const Value.absent(),
          Value<String?> photoUrl = const Value.absent(),
          String? category,
          String? cuisine,
          int? cookTimeMinutes,
          int? defaultServings,
          String? instructions,
          bool? isFavorite,
          String? createdBy,
          int? createdAt,
          int? updatedAt}) =>
      RecipesTableData(
        id: id ?? this.id,
        familyId: familyId ?? this.familyId,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        photoUrl: photoUrl.present ? photoUrl.value : this.photoUrl,
        category: category ?? this.category,
        cuisine: cuisine ?? this.cuisine,
        cookTimeMinutes: cookTimeMinutes ?? this.cookTimeMinutes,
        defaultServings: defaultServings ?? this.defaultServings,
        instructions: instructions ?? this.instructions,
        isFavorite: isFavorite ?? this.isFavorite,
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  RecipesTableData copyWithCompanion(RecipesTableCompanion data) {
    return RecipesTableData(
      id: data.id.present ? data.id.value : this.id,
      familyId: data.familyId.present ? data.familyId.value : this.familyId,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      photoUrl: data.photoUrl.present ? data.photoUrl.value : this.photoUrl,
      category: data.category.present ? data.category.value : this.category,
      cuisine: data.cuisine.present ? data.cuisine.value : this.cuisine,
      cookTimeMinutes: data.cookTimeMinutes.present
          ? data.cookTimeMinutes.value
          : this.cookTimeMinutes,
      defaultServings: data.defaultServings.present
          ? data.defaultServings.value
          : this.defaultServings,
      instructions: data.instructions.present
          ? data.instructions.value
          : this.instructions,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipesTableData(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('category: $category, ')
          ..write('cuisine: $cuisine, ')
          ..write('cookTimeMinutes: $cookTimeMinutes, ')
          ..write('defaultServings: $defaultServings, ')
          ..write('instructions: $instructions, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      familyId,
      title,
      description,
      photoUrl,
      category,
      cuisine,
      cookTimeMinutes,
      defaultServings,
      instructions,
      isFavorite,
      createdBy,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipesTableData &&
          other.id == this.id &&
          other.familyId == this.familyId &&
          other.title == this.title &&
          other.description == this.description &&
          other.photoUrl == this.photoUrl &&
          other.category == this.category &&
          other.cuisine == this.cuisine &&
          other.cookTimeMinutes == this.cookTimeMinutes &&
          other.defaultServings == this.defaultServings &&
          other.instructions == this.instructions &&
          other.isFavorite == this.isFavorite &&
          other.createdBy == this.createdBy &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RecipesTableCompanion extends UpdateCompanion<RecipesTableData> {
  final Value<String> id;
  final Value<String> familyId;
  final Value<String> title;
  final Value<String?> description;
  final Value<String?> photoUrl;
  final Value<String> category;
  final Value<String> cuisine;
  final Value<int> cookTimeMinutes;
  final Value<int> defaultServings;
  final Value<String> instructions;
  final Value<bool> isFavorite;
  final Value<String> createdBy;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const RecipesTableCompanion({
    this.id = const Value.absent(),
    this.familyId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.category = const Value.absent(),
    this.cuisine = const Value.absent(),
    this.cookTimeMinutes = const Value.absent(),
    this.defaultServings = const Value.absent(),
    this.instructions = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipesTableCompanion.insert({
    required String id,
    required String familyId,
    required String title,
    this.description = const Value.absent(),
    this.photoUrl = const Value.absent(),
    required String category,
    required String cuisine,
    this.cookTimeMinutes = const Value.absent(),
    this.defaultServings = const Value.absent(),
    required String instructions,
    this.isFavorite = const Value.absent(),
    required String createdBy,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        familyId = Value(familyId),
        title = Value(title),
        category = Value(category),
        cuisine = Value(cuisine),
        instructions = Value(instructions),
        createdBy = Value(createdBy),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<RecipesTableData> custom({
    Expression<String>? id,
    Expression<String>? familyId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? photoUrl,
    Expression<String>? category,
    Expression<String>? cuisine,
    Expression<int>? cookTimeMinutes,
    Expression<int>? defaultServings,
    Expression<String>? instructions,
    Expression<bool>? isFavorite,
    Expression<String>? createdBy,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (familyId != null) 'family_id': familyId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (category != null) 'category': category,
      if (cuisine != null) 'cuisine': cuisine,
      if (cookTimeMinutes != null) 'cook_time_minutes': cookTimeMinutes,
      if (defaultServings != null) 'default_servings': defaultServings,
      if (instructions != null) 'instructions': instructions,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (createdBy != null) 'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? familyId,
      Value<String>? title,
      Value<String?>? description,
      Value<String?>? photoUrl,
      Value<String>? category,
      Value<String>? cuisine,
      Value<int>? cookTimeMinutes,
      Value<int>? defaultServings,
      Value<String>? instructions,
      Value<bool>? isFavorite,
      Value<String>? createdBy,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return RecipesTableCompanion(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      title: title ?? this.title,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      category: category ?? this.category,
      cuisine: cuisine ?? this.cuisine,
      cookTimeMinutes: cookTimeMinutes ?? this.cookTimeMinutes,
      defaultServings: defaultServings ?? this.defaultServings,
      instructions: instructions ?? this.instructions,
      isFavorite: isFavorite ?? this.isFavorite,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (familyId.present) {
      map['family_id'] = Variable<String>(familyId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (photoUrl.present) {
      map['photo_url'] = Variable<String>(photoUrl.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (cuisine.present) {
      map['cuisine'] = Variable<String>(cuisine.value);
    }
    if (cookTimeMinutes.present) {
      map['cook_time_minutes'] = Variable<int>(cookTimeMinutes.value);
    }
    if (defaultServings.present) {
      map['default_servings'] = Variable<int>(defaultServings.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesTableCompanion(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('category: $category, ')
          ..write('cuisine: $cuisine, ')
          ..write('cookTimeMinutes: $cookTimeMinutes, ')
          ..write('defaultServings: $defaultServings, ')
          ..write('instructions: $instructions, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IngredientsTableTable extends IngredientsTable
    with TableInfo<$IngredientsTableTable, IngredientsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recipeIdMeta =
      const VerificationMeta('recipeId');
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
      'recipe_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES recipes (id) ON DELETE CASCADE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, recipeId, name, quantity, unit, category, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredients';
  @override
  VerificationContext validateIntegrity(
      Insertable<IngredientsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(_recipeIdMeta,
          recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta));
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IngredientsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IngredientsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      recipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recipe_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $IngredientsTableTable createAlias(String alias) {
    return $IngredientsTableTable(attachedDatabase, alias);
  }
}

class IngredientsTableData extends DataClass
    implements Insertable<IngredientsTableData> {
  final String id;
  final String recipeId;
  final String name;
  final double quantity;
  final String unit;
  final String? category;
  final int sortOrder;
  const IngredientsTableData(
      {required this.id,
      required this.recipeId,
      required this.name,
      required this.quantity,
      required this.unit,
      this.category,
      required this.sortOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['recipe_id'] = Variable<String>(recipeId);
    map['name'] = Variable<String>(name);
    map['quantity'] = Variable<double>(quantity);
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  IngredientsTableCompanion toCompanion(bool nullToAbsent) {
    return IngredientsTableCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      name: Value(name),
      quantity: Value(quantity),
      unit: Value(unit),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      sortOrder: Value(sortOrder),
    );
  }

  factory IngredientsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IngredientsTableData(
      id: serializer.fromJson<String>(json['id']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      name: serializer.fromJson<String>(json['name']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unit: serializer.fromJson<String>(json['unit']),
      category: serializer.fromJson<String?>(json['category']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'recipeId': serializer.toJson<String>(recipeId),
      'name': serializer.toJson<String>(name),
      'quantity': serializer.toJson<double>(quantity),
      'unit': serializer.toJson<String>(unit),
      'category': serializer.toJson<String?>(category),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  IngredientsTableData copyWith(
          {String? id,
          String? recipeId,
          String? name,
          double? quantity,
          String? unit,
          Value<String?> category = const Value.absent(),
          int? sortOrder}) =>
      IngredientsTableData(
        id: id ?? this.id,
        recipeId: recipeId ?? this.recipeId,
        name: name ?? this.name,
        quantity: quantity ?? this.quantity,
        unit: unit ?? this.unit,
        category: category.present ? category.value : this.category,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  IngredientsTableData copyWithCompanion(IngredientsTableCompanion data) {
    return IngredientsTableData(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      name: data.name.present ? data.name.value : this.name,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      category: data.category.present ? data.category.value : this.category,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IngredientsTableData(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('category: $category, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, recipeId, name, quantity, unit, category, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IngredientsTableData &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.name == this.name &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.category == this.category &&
          other.sortOrder == this.sortOrder);
}

class IngredientsTableCompanion extends UpdateCompanion<IngredientsTableData> {
  final Value<String> id;
  final Value<String> recipeId;
  final Value<String> name;
  final Value<double> quantity;
  final Value<String> unit;
  final Value<String?> category;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const IngredientsTableCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.category = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IngredientsTableCompanion.insert({
    required String id,
    required String recipeId,
    required String name,
    required double quantity,
    required String unit,
    this.category = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        recipeId = Value(recipeId),
        name = Value(name),
        quantity = Value(quantity),
        unit = Value(unit);
  static Insertable<IngredientsTableData> custom({
    Expression<String>? id,
    Expression<String>? recipeId,
    Expression<String>? name,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<String>? category,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (category != null) 'category': category,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IngredientsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? recipeId,
      Value<String>? name,
      Value<double>? quantity,
      Value<String>? unit,
      Value<String?>? category,
      Value<int>? sortOrder,
      Value<int>? rowid}) {
    return IngredientsTableCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientsTableCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('category: $category, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PantryItemsTableTable extends PantryItemsTable
    with TableInfo<$PantryItemsTableTable, PantryItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PantryItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _familyIdMeta =
      const VerificationMeta('familyId');
  @override
  late final GeneratedColumn<String> familyId = GeneratedColumn<String>(
      'family_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _minQuantityMeta =
      const VerificationMeta('minQuantity');
  @override
  late final GeneratedColumn<double> minQuantity = GeneratedColumn<double>(
      'min_quantity', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        familyId,
        name,
        quantity,
        unit,
        category,
        minQuantity,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pantry_items';
  @override
  VerificationContext validateIntegrity(
      Insertable<PantryItemsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('family_id')) {
      context.handle(_familyIdMeta,
          familyId.isAcceptableOrUnknown(data['family_id']!, _familyIdMeta));
    } else if (isInserting) {
      context.missing(_familyIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('min_quantity')) {
      context.handle(
          _minQuantityMeta,
          minQuantity.isAcceptableOrUnknown(
              data['min_quantity']!, _minQuantityMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PantryItemsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PantryItemsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      familyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}family_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      minQuantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}min_quantity'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PantryItemsTableTable createAlias(String alias) {
    return $PantryItemsTableTable(attachedDatabase, alias);
  }
}

class PantryItemsTableData extends DataClass
    implements Insertable<PantryItemsTableData> {
  final String id;
  final String familyId;
  final String name;
  final double quantity;
  final String unit;
  final String category;
  final double minQuantity;
  final int createdAt;
  final int updatedAt;
  const PantryItemsTableData(
      {required this.id,
      required this.familyId,
      required this.name,
      required this.quantity,
      required this.unit,
      required this.category,
      required this.minQuantity,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['family_id'] = Variable<String>(familyId);
    map['name'] = Variable<String>(name);
    map['quantity'] = Variable<double>(quantity);
    map['unit'] = Variable<String>(unit);
    map['category'] = Variable<String>(category);
    map['min_quantity'] = Variable<double>(minQuantity);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  PantryItemsTableCompanion toCompanion(bool nullToAbsent) {
    return PantryItemsTableCompanion(
      id: Value(id),
      familyId: Value(familyId),
      name: Value(name),
      quantity: Value(quantity),
      unit: Value(unit),
      category: Value(category),
      minQuantity: Value(minQuantity),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PantryItemsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PantryItemsTableData(
      id: serializer.fromJson<String>(json['id']),
      familyId: serializer.fromJson<String>(json['familyId']),
      name: serializer.fromJson<String>(json['name']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unit: serializer.fromJson<String>(json['unit']),
      category: serializer.fromJson<String>(json['category']),
      minQuantity: serializer.fromJson<double>(json['minQuantity']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'familyId': serializer.toJson<String>(familyId),
      'name': serializer.toJson<String>(name),
      'quantity': serializer.toJson<double>(quantity),
      'unit': serializer.toJson<String>(unit),
      'category': serializer.toJson<String>(category),
      'minQuantity': serializer.toJson<double>(minQuantity),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  PantryItemsTableData copyWith(
          {String? id,
          String? familyId,
          String? name,
          double? quantity,
          String? unit,
          String? category,
          double? minQuantity,
          int? createdAt,
          int? updatedAt}) =>
      PantryItemsTableData(
        id: id ?? this.id,
        familyId: familyId ?? this.familyId,
        name: name ?? this.name,
        quantity: quantity ?? this.quantity,
        unit: unit ?? this.unit,
        category: category ?? this.category,
        minQuantity: minQuantity ?? this.minQuantity,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  PantryItemsTableData copyWithCompanion(PantryItemsTableCompanion data) {
    return PantryItemsTableData(
      id: data.id.present ? data.id.value : this.id,
      familyId: data.familyId.present ? data.familyId.value : this.familyId,
      name: data.name.present ? data.name.value : this.name,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      category: data.category.present ? data.category.value : this.category,
      minQuantity:
          data.minQuantity.present ? data.minQuantity.value : this.minQuantity,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PantryItemsTableData(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('category: $category, ')
          ..write('minQuantity: $minQuantity, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, familyId, name, quantity, unit, category,
      minQuantity, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PantryItemsTableData &&
          other.id == this.id &&
          other.familyId == this.familyId &&
          other.name == this.name &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.category == this.category &&
          other.minQuantity == this.minQuantity &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PantryItemsTableCompanion extends UpdateCompanion<PantryItemsTableData> {
  final Value<String> id;
  final Value<String> familyId;
  final Value<String> name;
  final Value<double> quantity;
  final Value<String> unit;
  final Value<String> category;
  final Value<double> minQuantity;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const PantryItemsTableCompanion({
    this.id = const Value.absent(),
    this.familyId = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.category = const Value.absent(),
    this.minQuantity = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PantryItemsTableCompanion.insert({
    required String id,
    required String familyId,
    required String name,
    this.quantity = const Value.absent(),
    required String unit,
    required String category,
    this.minQuantity = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        familyId = Value(familyId),
        name = Value(name),
        unit = Value(unit),
        category = Value(category),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<PantryItemsTableData> custom({
    Expression<String>? id,
    Expression<String>? familyId,
    Expression<String>? name,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<String>? category,
    Expression<double>? minQuantity,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (familyId != null) 'family_id': familyId,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (category != null) 'category': category,
      if (minQuantity != null) 'min_quantity': minQuantity,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PantryItemsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? familyId,
      Value<String>? name,
      Value<double>? quantity,
      Value<String>? unit,
      Value<String>? category,
      Value<double>? minQuantity,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return PantryItemsTableCompanion(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      minQuantity: minQuantity ?? this.minQuantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (familyId.present) {
      map['family_id'] = Variable<String>(familyId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (minQuantity.present) {
      map['min_quantity'] = Variable<double>(minQuantity.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PantryItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('category: $category, ')
          ..write('minQuantity: $minQuantity, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MealPlansTableTable extends MealPlansTable
    with TableInfo<$MealPlansTableTable, MealPlansTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealPlansTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _familyIdMeta =
      const VerificationMeta('familyId');
  @override
  late final GeneratedColumn<String> familyId = GeneratedColumn<String>(
      'family_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _planDateMeta =
      const VerificationMeta('planDate');
  @override
  late final GeneratedColumn<int> planDate = GeneratedColumn<int>(
      'plan_date', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _mealTypeMeta =
      const VerificationMeta('mealType');
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
      'meal_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _servingsMeta =
      const VerificationMeta('servings');
  @override
  late final GeneratedColumn<int> servings = GeneratedColumn<int>(
      'servings', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(4));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, familyId, planDate, mealType, servings, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_plans';
  @override
  VerificationContext validateIntegrity(Insertable<MealPlansTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('family_id')) {
      context.handle(_familyIdMeta,
          familyId.isAcceptableOrUnknown(data['family_id']!, _familyIdMeta));
    } else if (isInserting) {
      context.missing(_familyIdMeta);
    }
    if (data.containsKey('plan_date')) {
      context.handle(_planDateMeta,
          planDate.isAcceptableOrUnknown(data['plan_date']!, _planDateMeta));
    } else if (isInserting) {
      context.missing(_planDateMeta);
    }
    if (data.containsKey('meal_type')) {
      context.handle(_mealTypeMeta,
          mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta));
    } else if (isInserting) {
      context.missing(_mealTypeMeta);
    }
    if (data.containsKey('servings')) {
      context.handle(_servingsMeta,
          servings.isAcceptableOrUnknown(data['servings']!, _servingsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealPlansTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealPlansTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      familyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}family_id'])!,
      planDate: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}plan_date'])!,
      mealType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meal_type'])!,
      servings: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}servings'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MealPlansTableTable createAlias(String alias) {
    return $MealPlansTableTable(attachedDatabase, alias);
  }
}

class MealPlansTableData extends DataClass
    implements Insertable<MealPlansTableData> {
  final String id;
  final String familyId;
  final int planDate;
  final String mealType;
  final int servings;
  final int createdAt;
  final int updatedAt;
  const MealPlansTableData(
      {required this.id,
      required this.familyId,
      required this.planDate,
      required this.mealType,
      required this.servings,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['family_id'] = Variable<String>(familyId);
    map['plan_date'] = Variable<int>(planDate);
    map['meal_type'] = Variable<String>(mealType);
    map['servings'] = Variable<int>(servings);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  MealPlansTableCompanion toCompanion(bool nullToAbsent) {
    return MealPlansTableCompanion(
      id: Value(id),
      familyId: Value(familyId),
      planDate: Value(planDate),
      mealType: Value(mealType),
      servings: Value(servings),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MealPlansTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealPlansTableData(
      id: serializer.fromJson<String>(json['id']),
      familyId: serializer.fromJson<String>(json['familyId']),
      planDate: serializer.fromJson<int>(json['planDate']),
      mealType: serializer.fromJson<String>(json['mealType']),
      servings: serializer.fromJson<int>(json['servings']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'familyId': serializer.toJson<String>(familyId),
      'planDate': serializer.toJson<int>(planDate),
      'mealType': serializer.toJson<String>(mealType),
      'servings': serializer.toJson<int>(servings),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  MealPlansTableData copyWith(
          {String? id,
          String? familyId,
          int? planDate,
          String? mealType,
          int? servings,
          int? createdAt,
          int? updatedAt}) =>
      MealPlansTableData(
        id: id ?? this.id,
        familyId: familyId ?? this.familyId,
        planDate: planDate ?? this.planDate,
        mealType: mealType ?? this.mealType,
        servings: servings ?? this.servings,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  MealPlansTableData copyWithCompanion(MealPlansTableCompanion data) {
    return MealPlansTableData(
      id: data.id.present ? data.id.value : this.id,
      familyId: data.familyId.present ? data.familyId.value : this.familyId,
      planDate: data.planDate.present ? data.planDate.value : this.planDate,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      servings: data.servings.present ? data.servings.value : this.servings,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealPlansTableData(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('planDate: $planDate, ')
          ..write('mealType: $mealType, ')
          ..write('servings: $servings, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, familyId, planDate, mealType, servings, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealPlansTableData &&
          other.id == this.id &&
          other.familyId == this.familyId &&
          other.planDate == this.planDate &&
          other.mealType == this.mealType &&
          other.servings == this.servings &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MealPlansTableCompanion extends UpdateCompanion<MealPlansTableData> {
  final Value<String> id;
  final Value<String> familyId;
  final Value<int> planDate;
  final Value<String> mealType;
  final Value<int> servings;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const MealPlansTableCompanion({
    this.id = const Value.absent(),
    this.familyId = const Value.absent(),
    this.planDate = const Value.absent(),
    this.mealType = const Value.absent(),
    this.servings = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MealPlansTableCompanion.insert({
    required String id,
    required String familyId,
    required int planDate,
    required String mealType,
    this.servings = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        familyId = Value(familyId),
        planDate = Value(planDate),
        mealType = Value(mealType),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<MealPlansTableData> custom({
    Expression<String>? id,
    Expression<String>? familyId,
    Expression<int>? planDate,
    Expression<String>? mealType,
    Expression<int>? servings,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (familyId != null) 'family_id': familyId,
      if (planDate != null) 'plan_date': planDate,
      if (mealType != null) 'meal_type': mealType,
      if (servings != null) 'servings': servings,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MealPlansTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? familyId,
      Value<int>? planDate,
      Value<String>? mealType,
      Value<int>? servings,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return MealPlansTableCompanion(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      planDate: planDate ?? this.planDate,
      mealType: mealType ?? this.mealType,
      servings: servings ?? this.servings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (familyId.present) {
      map['family_id'] = Variable<String>(familyId.value);
    }
    if (planDate.present) {
      map['plan_date'] = Variable<int>(planDate.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (servings.present) {
      map['servings'] = Variable<int>(servings.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealPlansTableCompanion(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('planDate: $planDate, ')
          ..write('mealType: $mealType, ')
          ..write('servings: $servings, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MealPlanRecipesTableTable extends MealPlanRecipesTable
    with TableInfo<$MealPlanRecipesTableTable, MealPlanRecipesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealPlanRecipesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mealPlanIdMeta =
      const VerificationMeta('mealPlanId');
  @override
  late final GeneratedColumn<String> mealPlanId = GeneratedColumn<String>(
      'meal_plan_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES meal_plans (id) ON DELETE CASCADE'));
  static const VerificationMeta _recipeIdMeta =
      const VerificationMeta('recipeId');
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
      'recipe_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES recipes (id) ON DELETE CASCADE'));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, mealPlanId, recipeId, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_plan_recipes';
  @override
  VerificationContext validateIntegrity(
      Insertable<MealPlanRecipesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('meal_plan_id')) {
      context.handle(
          _mealPlanIdMeta,
          mealPlanId.isAcceptableOrUnknown(
              data['meal_plan_id']!, _mealPlanIdMeta));
    } else if (isInserting) {
      context.missing(_mealPlanIdMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(_recipeIdMeta,
          recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta));
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealPlanRecipesTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealPlanRecipesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      mealPlanId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meal_plan_id'])!,
      recipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recipe_id'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $MealPlanRecipesTableTable createAlias(String alias) {
    return $MealPlanRecipesTableTable(attachedDatabase, alias);
  }
}

class MealPlanRecipesTableData extends DataClass
    implements Insertable<MealPlanRecipesTableData> {
  final String id;
  final String mealPlanId;
  final String recipeId;
  final int sortOrder;
  const MealPlanRecipesTableData(
      {required this.id,
      required this.mealPlanId,
      required this.recipeId,
      required this.sortOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['meal_plan_id'] = Variable<String>(mealPlanId);
    map['recipe_id'] = Variable<String>(recipeId);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  MealPlanRecipesTableCompanion toCompanion(bool nullToAbsent) {
    return MealPlanRecipesTableCompanion(
      id: Value(id),
      mealPlanId: Value(mealPlanId),
      recipeId: Value(recipeId),
      sortOrder: Value(sortOrder),
    );
  }

  factory MealPlanRecipesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealPlanRecipesTableData(
      id: serializer.fromJson<String>(json['id']),
      mealPlanId: serializer.fromJson<String>(json['mealPlanId']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'mealPlanId': serializer.toJson<String>(mealPlanId),
      'recipeId': serializer.toJson<String>(recipeId),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  MealPlanRecipesTableData copyWith(
          {String? id, String? mealPlanId, String? recipeId, int? sortOrder}) =>
      MealPlanRecipesTableData(
        id: id ?? this.id,
        mealPlanId: mealPlanId ?? this.mealPlanId,
        recipeId: recipeId ?? this.recipeId,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  MealPlanRecipesTableData copyWithCompanion(
      MealPlanRecipesTableCompanion data) {
    return MealPlanRecipesTableData(
      id: data.id.present ? data.id.value : this.id,
      mealPlanId:
          data.mealPlanId.present ? data.mealPlanId.value : this.mealPlanId,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealPlanRecipesTableData(')
          ..write('id: $id, ')
          ..write('mealPlanId: $mealPlanId, ')
          ..write('recipeId: $recipeId, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, mealPlanId, recipeId, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealPlanRecipesTableData &&
          other.id == this.id &&
          other.mealPlanId == this.mealPlanId &&
          other.recipeId == this.recipeId &&
          other.sortOrder == this.sortOrder);
}

class MealPlanRecipesTableCompanion
    extends UpdateCompanion<MealPlanRecipesTableData> {
  final Value<String> id;
  final Value<String> mealPlanId;
  final Value<String> recipeId;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const MealPlanRecipesTableCompanion({
    this.id = const Value.absent(),
    this.mealPlanId = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MealPlanRecipesTableCompanion.insert({
    required String id,
    required String mealPlanId,
    required String recipeId,
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        mealPlanId = Value(mealPlanId),
        recipeId = Value(recipeId);
  static Insertable<MealPlanRecipesTableData> custom({
    Expression<String>? id,
    Expression<String>? mealPlanId,
    Expression<String>? recipeId,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mealPlanId != null) 'meal_plan_id': mealPlanId,
      if (recipeId != null) 'recipe_id': recipeId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MealPlanRecipesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? mealPlanId,
      Value<String>? recipeId,
      Value<int>? sortOrder,
      Value<int>? rowid}) {
    return MealPlanRecipesTableCompanion(
      id: id ?? this.id,
      mealPlanId: mealPlanId ?? this.mealPlanId,
      recipeId: recipeId ?? this.recipeId,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (mealPlanId.present) {
      map['meal_plan_id'] = Variable<String>(mealPlanId.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealPlanRecipesTableCompanion(')
          ..write('id: $id, ')
          ..write('mealPlanId: $mealPlanId, ')
          ..write('recipeId: $recipeId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShoppingListsTableTable extends ShoppingListsTable
    with TableInfo<$ShoppingListsTableTable, ShoppingListsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingListsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _familyIdMeta =
      const VerificationMeta('familyId');
  @override
  late final GeneratedColumn<String> familyId = GeneratedColumn<String>(
      'family_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateFromMeta =
      const VerificationMeta('dateFrom');
  @override
  late final GeneratedColumn<int> dateFrom = GeneratedColumn<int>(
      'date_from', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dateToMeta = const VerificationMeta('dateTo');
  @override
  late final GeneratedColumn<int> dateTo = GeneratedColumn<int>(
      'date_to', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, familyId, name, dateFrom, dateTo, isCompleted, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_lists';
  @override
  VerificationContext validateIntegrity(
      Insertable<ShoppingListsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('family_id')) {
      context.handle(_familyIdMeta,
          familyId.isAcceptableOrUnknown(data['family_id']!, _familyIdMeta));
    } else if (isInserting) {
      context.missing(_familyIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('date_from')) {
      context.handle(_dateFromMeta,
          dateFrom.isAcceptableOrUnknown(data['date_from']!, _dateFromMeta));
    } else if (isInserting) {
      context.missing(_dateFromMeta);
    }
    if (data.containsKey('date_to')) {
      context.handle(_dateToMeta,
          dateTo.isAcceptableOrUnknown(data['date_to']!, _dateToMeta));
    } else if (isInserting) {
      context.missing(_dateToMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingListsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingListsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      familyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}family_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      dateFrom: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}date_from'])!,
      dateTo: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}date_to'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ShoppingListsTableTable createAlias(String alias) {
    return $ShoppingListsTableTable(attachedDatabase, alias);
  }
}

class ShoppingListsTableData extends DataClass
    implements Insertable<ShoppingListsTableData> {
  final String id;
  final String familyId;
  final String name;
  final int dateFrom;
  final int dateTo;
  final bool isCompleted;
  final int createdAt;
  final int updatedAt;
  const ShoppingListsTableData(
      {required this.id,
      required this.familyId,
      required this.name,
      required this.dateFrom,
      required this.dateTo,
      required this.isCompleted,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['family_id'] = Variable<String>(familyId);
    map['name'] = Variable<String>(name);
    map['date_from'] = Variable<int>(dateFrom);
    map['date_to'] = Variable<int>(dateTo);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ShoppingListsTableCompanion toCompanion(bool nullToAbsent) {
    return ShoppingListsTableCompanion(
      id: Value(id),
      familyId: Value(familyId),
      name: Value(name),
      dateFrom: Value(dateFrom),
      dateTo: Value(dateTo),
      isCompleted: Value(isCompleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ShoppingListsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingListsTableData(
      id: serializer.fromJson<String>(json['id']),
      familyId: serializer.fromJson<String>(json['familyId']),
      name: serializer.fromJson<String>(json['name']),
      dateFrom: serializer.fromJson<int>(json['dateFrom']),
      dateTo: serializer.fromJson<int>(json['dateTo']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'familyId': serializer.toJson<String>(familyId),
      'name': serializer.toJson<String>(name),
      'dateFrom': serializer.toJson<int>(dateFrom),
      'dateTo': serializer.toJson<int>(dateTo),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ShoppingListsTableData copyWith(
          {String? id,
          String? familyId,
          String? name,
          int? dateFrom,
          int? dateTo,
          bool? isCompleted,
          int? createdAt,
          int? updatedAt}) =>
      ShoppingListsTableData(
        id: id ?? this.id,
        familyId: familyId ?? this.familyId,
        name: name ?? this.name,
        dateFrom: dateFrom ?? this.dateFrom,
        dateTo: dateTo ?? this.dateTo,
        isCompleted: isCompleted ?? this.isCompleted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ShoppingListsTableData copyWithCompanion(ShoppingListsTableCompanion data) {
    return ShoppingListsTableData(
      id: data.id.present ? data.id.value : this.id,
      familyId: data.familyId.present ? data.familyId.value : this.familyId,
      name: data.name.present ? data.name.value : this.name,
      dateFrom: data.dateFrom.present ? data.dateFrom.value : this.dateFrom,
      dateTo: data.dateTo.present ? data.dateTo.value : this.dateTo,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListsTableData(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('name: $name, ')
          ..write('dateFrom: $dateFrom, ')
          ..write('dateTo: $dateTo, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, familyId, name, dateFrom, dateTo, isCompleted, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingListsTableData &&
          other.id == this.id &&
          other.familyId == this.familyId &&
          other.name == this.name &&
          other.dateFrom == this.dateFrom &&
          other.dateTo == this.dateTo &&
          other.isCompleted == this.isCompleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ShoppingListsTableCompanion
    extends UpdateCompanion<ShoppingListsTableData> {
  final Value<String> id;
  final Value<String> familyId;
  final Value<String> name;
  final Value<int> dateFrom;
  final Value<int> dateTo;
  final Value<bool> isCompleted;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ShoppingListsTableCompanion({
    this.id = const Value.absent(),
    this.familyId = const Value.absent(),
    this.name = const Value.absent(),
    this.dateFrom = const Value.absent(),
    this.dateTo = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShoppingListsTableCompanion.insert({
    required String id,
    required String familyId,
    required String name,
    required int dateFrom,
    required int dateTo,
    this.isCompleted = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        familyId = Value(familyId),
        name = Value(name),
        dateFrom = Value(dateFrom),
        dateTo = Value(dateTo),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<ShoppingListsTableData> custom({
    Expression<String>? id,
    Expression<String>? familyId,
    Expression<String>? name,
    Expression<int>? dateFrom,
    Expression<int>? dateTo,
    Expression<bool>? isCompleted,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (familyId != null) 'family_id': familyId,
      if (name != null) 'name': name,
      if (dateFrom != null) 'date_from': dateFrom,
      if (dateTo != null) 'date_to': dateTo,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShoppingListsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? familyId,
      Value<String>? name,
      Value<int>? dateFrom,
      Value<int>? dateTo,
      Value<bool>? isCompleted,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return ShoppingListsTableCompanion(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      name: name ?? this.name,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (familyId.present) {
      map['family_id'] = Variable<String>(familyId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dateFrom.present) {
      map['date_from'] = Variable<int>(dateFrom.value);
    }
    if (dateTo.present) {
      map['date_to'] = Variable<int>(dateTo.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListsTableCompanion(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('name: $name, ')
          ..write('dateFrom: $dateFrom, ')
          ..write('dateTo: $dateTo, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShoppingItemsTableTable extends ShoppingItemsTable
    with TableInfo<$ShoppingItemsTableTable, ShoppingItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _shoppingListIdMeta =
      const VerificationMeta('shoppingListId');
  @override
  late final GeneratedColumn<String> shoppingListId = GeneratedColumn<String>(
      'shopping_list_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES shopping_lists (id) ON DELETE CASCADE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityNeededMeta =
      const VerificationMeta('quantityNeeded');
  @override
  late final GeneratedColumn<double> quantityNeeded = GeneratedColumn<double>(
      'quantity_needed', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _quantityInPantryMeta =
      const VerificationMeta('quantityInPantry');
  @override
  late final GeneratedColumn<double> quantityInPantry = GeneratedColumn<double>(
      'quantity_in_pantry', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _quantityToBuyMeta =
      const VerificationMeta('quantityToBuy');
  @override
  late final GeneratedColumn<double> quantityToBuy = GeneratedColumn<double>(
      'quantity_to_buy', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isCheckedMeta =
      const VerificationMeta('isChecked');
  @override
  late final GeneratedColumn<bool> isChecked = GeneratedColumn<bool>(
      'is_checked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_checked" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isManualMeta =
      const VerificationMeta('isManual');
  @override
  late final GeneratedColumn<bool> isManual = GeneratedColumn<bool>(
      'is_manual', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_manual" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        shoppingListId,
        name,
        quantityNeeded,
        quantityInPantry,
        quantityToBuy,
        unit,
        category,
        isChecked,
        isManual
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_items';
  @override
  VerificationContext validateIntegrity(
      Insertable<ShoppingItemsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('shopping_list_id')) {
      context.handle(
          _shoppingListIdMeta,
          shoppingListId.isAcceptableOrUnknown(
              data['shopping_list_id']!, _shoppingListIdMeta));
    } else if (isInserting) {
      context.missing(_shoppingListIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('quantity_needed')) {
      context.handle(
          _quantityNeededMeta,
          quantityNeeded.isAcceptableOrUnknown(
              data['quantity_needed']!, _quantityNeededMeta));
    } else if (isInserting) {
      context.missing(_quantityNeededMeta);
    }
    if (data.containsKey('quantity_in_pantry')) {
      context.handle(
          _quantityInPantryMeta,
          quantityInPantry.isAcceptableOrUnknown(
              data['quantity_in_pantry']!, _quantityInPantryMeta));
    }
    if (data.containsKey('quantity_to_buy')) {
      context.handle(
          _quantityToBuyMeta,
          quantityToBuy.isAcceptableOrUnknown(
              data['quantity_to_buy']!, _quantityToBuyMeta));
    } else if (isInserting) {
      context.missing(_quantityToBuyMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('is_checked')) {
      context.handle(_isCheckedMeta,
          isChecked.isAcceptableOrUnknown(data['is_checked']!, _isCheckedMeta));
    }
    if (data.containsKey('is_manual')) {
      context.handle(_isManualMeta,
          isManual.isAcceptableOrUnknown(data['is_manual']!, _isManualMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingItemsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingItemsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      shoppingListId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}shopping_list_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      quantityNeeded: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}quantity_needed'])!,
      quantityInPantry: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}quantity_in_pantry'])!,
      quantityToBuy: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}quantity_to_buy'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      isChecked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_checked'])!,
      isManual: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_manual'])!,
    );
  }

  @override
  $ShoppingItemsTableTable createAlias(String alias) {
    return $ShoppingItemsTableTable(attachedDatabase, alias);
  }
}

class ShoppingItemsTableData extends DataClass
    implements Insertable<ShoppingItemsTableData> {
  final String id;
  final String shoppingListId;
  final String name;
  final double quantityNeeded;
  final double quantityInPantry;
  final double quantityToBuy;
  final String unit;
  final String? category;
  final bool isChecked;
  final bool isManual;
  const ShoppingItemsTableData(
      {required this.id,
      required this.shoppingListId,
      required this.name,
      required this.quantityNeeded,
      required this.quantityInPantry,
      required this.quantityToBuy,
      required this.unit,
      this.category,
      required this.isChecked,
      required this.isManual});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['shopping_list_id'] = Variable<String>(shoppingListId);
    map['name'] = Variable<String>(name);
    map['quantity_needed'] = Variable<double>(quantityNeeded);
    map['quantity_in_pantry'] = Variable<double>(quantityInPantry);
    map['quantity_to_buy'] = Variable<double>(quantityToBuy);
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['is_checked'] = Variable<bool>(isChecked);
    map['is_manual'] = Variable<bool>(isManual);
    return map;
  }

  ShoppingItemsTableCompanion toCompanion(bool nullToAbsent) {
    return ShoppingItemsTableCompanion(
      id: Value(id),
      shoppingListId: Value(shoppingListId),
      name: Value(name),
      quantityNeeded: Value(quantityNeeded),
      quantityInPantry: Value(quantityInPantry),
      quantityToBuy: Value(quantityToBuy),
      unit: Value(unit),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      isChecked: Value(isChecked),
      isManual: Value(isManual),
    );
  }

  factory ShoppingItemsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingItemsTableData(
      id: serializer.fromJson<String>(json['id']),
      shoppingListId: serializer.fromJson<String>(json['shoppingListId']),
      name: serializer.fromJson<String>(json['name']),
      quantityNeeded: serializer.fromJson<double>(json['quantityNeeded']),
      quantityInPantry: serializer.fromJson<double>(json['quantityInPantry']),
      quantityToBuy: serializer.fromJson<double>(json['quantityToBuy']),
      unit: serializer.fromJson<String>(json['unit']),
      category: serializer.fromJson<String?>(json['category']),
      isChecked: serializer.fromJson<bool>(json['isChecked']),
      isManual: serializer.fromJson<bool>(json['isManual']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'shoppingListId': serializer.toJson<String>(shoppingListId),
      'name': serializer.toJson<String>(name),
      'quantityNeeded': serializer.toJson<double>(quantityNeeded),
      'quantityInPantry': serializer.toJson<double>(quantityInPantry),
      'quantityToBuy': serializer.toJson<double>(quantityToBuy),
      'unit': serializer.toJson<String>(unit),
      'category': serializer.toJson<String?>(category),
      'isChecked': serializer.toJson<bool>(isChecked),
      'isManual': serializer.toJson<bool>(isManual),
    };
  }

  ShoppingItemsTableData copyWith(
          {String? id,
          String? shoppingListId,
          String? name,
          double? quantityNeeded,
          double? quantityInPantry,
          double? quantityToBuy,
          String? unit,
          Value<String?> category = const Value.absent(),
          bool? isChecked,
          bool? isManual}) =>
      ShoppingItemsTableData(
        id: id ?? this.id,
        shoppingListId: shoppingListId ?? this.shoppingListId,
        name: name ?? this.name,
        quantityNeeded: quantityNeeded ?? this.quantityNeeded,
        quantityInPantry: quantityInPantry ?? this.quantityInPantry,
        quantityToBuy: quantityToBuy ?? this.quantityToBuy,
        unit: unit ?? this.unit,
        category: category.present ? category.value : this.category,
        isChecked: isChecked ?? this.isChecked,
        isManual: isManual ?? this.isManual,
      );
  ShoppingItemsTableData copyWithCompanion(ShoppingItemsTableCompanion data) {
    return ShoppingItemsTableData(
      id: data.id.present ? data.id.value : this.id,
      shoppingListId: data.shoppingListId.present
          ? data.shoppingListId.value
          : this.shoppingListId,
      name: data.name.present ? data.name.value : this.name,
      quantityNeeded: data.quantityNeeded.present
          ? data.quantityNeeded.value
          : this.quantityNeeded,
      quantityInPantry: data.quantityInPantry.present
          ? data.quantityInPantry.value
          : this.quantityInPantry,
      quantityToBuy: data.quantityToBuy.present
          ? data.quantityToBuy.value
          : this.quantityToBuy,
      unit: data.unit.present ? data.unit.value : this.unit,
      category: data.category.present ? data.category.value : this.category,
      isChecked: data.isChecked.present ? data.isChecked.value : this.isChecked,
      isManual: data.isManual.present ? data.isManual.value : this.isManual,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingItemsTableData(')
          ..write('id: $id, ')
          ..write('shoppingListId: $shoppingListId, ')
          ..write('name: $name, ')
          ..write('quantityNeeded: $quantityNeeded, ')
          ..write('quantityInPantry: $quantityInPantry, ')
          ..write('quantityToBuy: $quantityToBuy, ')
          ..write('unit: $unit, ')
          ..write('category: $category, ')
          ..write('isChecked: $isChecked, ')
          ..write('isManual: $isManual')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, shoppingListId, name, quantityNeeded,
      quantityInPantry, quantityToBuy, unit, category, isChecked, isManual);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingItemsTableData &&
          other.id == this.id &&
          other.shoppingListId == this.shoppingListId &&
          other.name == this.name &&
          other.quantityNeeded == this.quantityNeeded &&
          other.quantityInPantry == this.quantityInPantry &&
          other.quantityToBuy == this.quantityToBuy &&
          other.unit == this.unit &&
          other.category == this.category &&
          other.isChecked == this.isChecked &&
          other.isManual == this.isManual);
}

class ShoppingItemsTableCompanion
    extends UpdateCompanion<ShoppingItemsTableData> {
  final Value<String> id;
  final Value<String> shoppingListId;
  final Value<String> name;
  final Value<double> quantityNeeded;
  final Value<double> quantityInPantry;
  final Value<double> quantityToBuy;
  final Value<String> unit;
  final Value<String?> category;
  final Value<bool> isChecked;
  final Value<bool> isManual;
  final Value<int> rowid;
  const ShoppingItemsTableCompanion({
    this.id = const Value.absent(),
    this.shoppingListId = const Value.absent(),
    this.name = const Value.absent(),
    this.quantityNeeded = const Value.absent(),
    this.quantityInPantry = const Value.absent(),
    this.quantityToBuy = const Value.absent(),
    this.unit = const Value.absent(),
    this.category = const Value.absent(),
    this.isChecked = const Value.absent(),
    this.isManual = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShoppingItemsTableCompanion.insert({
    required String id,
    required String shoppingListId,
    required String name,
    required double quantityNeeded,
    this.quantityInPantry = const Value.absent(),
    required double quantityToBuy,
    required String unit,
    this.category = const Value.absent(),
    this.isChecked = const Value.absent(),
    this.isManual = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        shoppingListId = Value(shoppingListId),
        name = Value(name),
        quantityNeeded = Value(quantityNeeded),
        quantityToBuy = Value(quantityToBuy),
        unit = Value(unit);
  static Insertable<ShoppingItemsTableData> custom({
    Expression<String>? id,
    Expression<String>? shoppingListId,
    Expression<String>? name,
    Expression<double>? quantityNeeded,
    Expression<double>? quantityInPantry,
    Expression<double>? quantityToBuy,
    Expression<String>? unit,
    Expression<String>? category,
    Expression<bool>? isChecked,
    Expression<bool>? isManual,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shoppingListId != null) 'shopping_list_id': shoppingListId,
      if (name != null) 'name': name,
      if (quantityNeeded != null) 'quantity_needed': quantityNeeded,
      if (quantityInPantry != null) 'quantity_in_pantry': quantityInPantry,
      if (quantityToBuy != null) 'quantity_to_buy': quantityToBuy,
      if (unit != null) 'unit': unit,
      if (category != null) 'category': category,
      if (isChecked != null) 'is_checked': isChecked,
      if (isManual != null) 'is_manual': isManual,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShoppingItemsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? shoppingListId,
      Value<String>? name,
      Value<double>? quantityNeeded,
      Value<double>? quantityInPantry,
      Value<double>? quantityToBuy,
      Value<String>? unit,
      Value<String?>? category,
      Value<bool>? isChecked,
      Value<bool>? isManual,
      Value<int>? rowid}) {
    return ShoppingItemsTableCompanion(
      id: id ?? this.id,
      shoppingListId: shoppingListId ?? this.shoppingListId,
      name: name ?? this.name,
      quantityNeeded: quantityNeeded ?? this.quantityNeeded,
      quantityInPantry: quantityInPantry ?? this.quantityInPantry,
      quantityToBuy: quantityToBuy ?? this.quantityToBuy,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      isChecked: isChecked ?? this.isChecked,
      isManual: isManual ?? this.isManual,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (shoppingListId.present) {
      map['shopping_list_id'] = Variable<String>(shoppingListId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (quantityNeeded.present) {
      map['quantity_needed'] = Variable<double>(quantityNeeded.value);
    }
    if (quantityInPantry.present) {
      map['quantity_in_pantry'] = Variable<double>(quantityInPantry.value);
    }
    if (quantityToBuy.present) {
      map['quantity_to_buy'] = Variable<double>(quantityToBuy.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (isChecked.present) {
      map['is_checked'] = Variable<bool>(isChecked.value);
    }
    if (isManual.present) {
      map['is_manual'] = Variable<bool>(isManual.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('shoppingListId: $shoppingListId, ')
          ..write('name: $name, ')
          ..write('quantityNeeded: $quantityNeeded, ')
          ..write('quantityInPantry: $quantityInPantry, ')
          ..write('quantityToBuy: $quantityToBuy, ')
          ..write('unit: $unit, ')
          ..write('category: $category, ')
          ..write('isChecked: $isChecked, ')
          ..write('isManual: $isManual, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CookingHistoryTableTable extends CookingHistoryTable
    with TableInfo<$CookingHistoryTableTable, CookingHistoryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CookingHistoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _familyIdMeta =
      const VerificationMeta('familyId');
  @override
  late final GeneratedColumn<String> familyId = GeneratedColumn<String>(
      'family_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recipeIdMeta =
      const VerificationMeta('recipeId');
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
      'recipe_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES recipes (id) ON DELETE RESTRICT'));
  static const VerificationMeta _recipeTitleMeta =
      const VerificationMeta('recipeTitle');
  @override
  late final GeneratedColumn<String> recipeTitle = GeneratedColumn<String>(
      'recipe_title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _servingsCookedMeta =
      const VerificationMeta('servingsCooked');
  @override
  late final GeneratedColumn<int> servingsCooked = GeneratedColumn<int>(
      'servings_cooked', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _cookedByMeta =
      const VerificationMeta('cookedBy');
  @override
  late final GeneratedColumn<String> cookedBy = GeneratedColumn<String>(
      'cooked_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cookedAtMeta =
      const VerificationMeta('cookedAt');
  @override
  late final GeneratedColumn<int> cookedAt = GeneratedColumn<int>(
      'cooked_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        familyId,
        recipeId,
        recipeTitle,
        servingsCooked,
        cookedBy,
        cookedAt,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cooking_history';
  @override
  VerificationContext validateIntegrity(
      Insertable<CookingHistoryTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('family_id')) {
      context.handle(_familyIdMeta,
          familyId.isAcceptableOrUnknown(data['family_id']!, _familyIdMeta));
    } else if (isInserting) {
      context.missing(_familyIdMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(_recipeIdMeta,
          recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta));
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('recipe_title')) {
      context.handle(
          _recipeTitleMeta,
          recipeTitle.isAcceptableOrUnknown(
              data['recipe_title']!, _recipeTitleMeta));
    } else if (isInserting) {
      context.missing(_recipeTitleMeta);
    }
    if (data.containsKey('servings_cooked')) {
      context.handle(
          _servingsCookedMeta,
          servingsCooked.isAcceptableOrUnknown(
              data['servings_cooked']!, _servingsCookedMeta));
    } else if (isInserting) {
      context.missing(_servingsCookedMeta);
    }
    if (data.containsKey('cooked_by')) {
      context.handle(_cookedByMeta,
          cookedBy.isAcceptableOrUnknown(data['cooked_by']!, _cookedByMeta));
    } else if (isInserting) {
      context.missing(_cookedByMeta);
    }
    if (data.containsKey('cooked_at')) {
      context.handle(_cookedAtMeta,
          cookedAt.isAcceptableOrUnknown(data['cooked_at']!, _cookedAtMeta));
    } else if (isInserting) {
      context.missing(_cookedAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CookingHistoryTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CookingHistoryTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      familyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}family_id'])!,
      recipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recipe_id'])!,
      recipeTitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recipe_title'])!,
      servingsCooked: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}servings_cooked'])!,
      cookedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cooked_by'])!,
      cookedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cooked_at'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $CookingHistoryTableTable createAlias(String alias) {
    return $CookingHistoryTableTable(attachedDatabase, alias);
  }
}

class CookingHistoryTableData extends DataClass
    implements Insertable<CookingHistoryTableData> {
  final String id;
  final String familyId;
  final String recipeId;
  final String recipeTitle;
  final int servingsCooked;
  final String cookedBy;
  final int cookedAt;
  final String? notes;
  const CookingHistoryTableData(
      {required this.id,
      required this.familyId,
      required this.recipeId,
      required this.recipeTitle,
      required this.servingsCooked,
      required this.cookedBy,
      required this.cookedAt,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['family_id'] = Variable<String>(familyId);
    map['recipe_id'] = Variable<String>(recipeId);
    map['recipe_title'] = Variable<String>(recipeTitle);
    map['servings_cooked'] = Variable<int>(servingsCooked);
    map['cooked_by'] = Variable<String>(cookedBy);
    map['cooked_at'] = Variable<int>(cookedAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  CookingHistoryTableCompanion toCompanion(bool nullToAbsent) {
    return CookingHistoryTableCompanion(
      id: Value(id),
      familyId: Value(familyId),
      recipeId: Value(recipeId),
      recipeTitle: Value(recipeTitle),
      servingsCooked: Value(servingsCooked),
      cookedBy: Value(cookedBy),
      cookedAt: Value(cookedAt),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory CookingHistoryTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CookingHistoryTableData(
      id: serializer.fromJson<String>(json['id']),
      familyId: serializer.fromJson<String>(json['familyId']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      recipeTitle: serializer.fromJson<String>(json['recipeTitle']),
      servingsCooked: serializer.fromJson<int>(json['servingsCooked']),
      cookedBy: serializer.fromJson<String>(json['cookedBy']),
      cookedAt: serializer.fromJson<int>(json['cookedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'familyId': serializer.toJson<String>(familyId),
      'recipeId': serializer.toJson<String>(recipeId),
      'recipeTitle': serializer.toJson<String>(recipeTitle),
      'servingsCooked': serializer.toJson<int>(servingsCooked),
      'cookedBy': serializer.toJson<String>(cookedBy),
      'cookedAt': serializer.toJson<int>(cookedAt),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  CookingHistoryTableData copyWith(
          {String? id,
          String? familyId,
          String? recipeId,
          String? recipeTitle,
          int? servingsCooked,
          String? cookedBy,
          int? cookedAt,
          Value<String?> notes = const Value.absent()}) =>
      CookingHistoryTableData(
        id: id ?? this.id,
        familyId: familyId ?? this.familyId,
        recipeId: recipeId ?? this.recipeId,
        recipeTitle: recipeTitle ?? this.recipeTitle,
        servingsCooked: servingsCooked ?? this.servingsCooked,
        cookedBy: cookedBy ?? this.cookedBy,
        cookedAt: cookedAt ?? this.cookedAt,
        notes: notes.present ? notes.value : this.notes,
      );
  CookingHistoryTableData copyWithCompanion(CookingHistoryTableCompanion data) {
    return CookingHistoryTableData(
      id: data.id.present ? data.id.value : this.id,
      familyId: data.familyId.present ? data.familyId.value : this.familyId,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      recipeTitle:
          data.recipeTitle.present ? data.recipeTitle.value : this.recipeTitle,
      servingsCooked: data.servingsCooked.present
          ? data.servingsCooked.value
          : this.servingsCooked,
      cookedBy: data.cookedBy.present ? data.cookedBy.value : this.cookedBy,
      cookedAt: data.cookedAt.present ? data.cookedAt.value : this.cookedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CookingHistoryTableData(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('recipeId: $recipeId, ')
          ..write('recipeTitle: $recipeTitle, ')
          ..write('servingsCooked: $servingsCooked, ')
          ..write('cookedBy: $cookedBy, ')
          ..write('cookedAt: $cookedAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, familyId, recipeId, recipeTitle,
      servingsCooked, cookedBy, cookedAt, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CookingHistoryTableData &&
          other.id == this.id &&
          other.familyId == this.familyId &&
          other.recipeId == this.recipeId &&
          other.recipeTitle == this.recipeTitle &&
          other.servingsCooked == this.servingsCooked &&
          other.cookedBy == this.cookedBy &&
          other.cookedAt == this.cookedAt &&
          other.notes == this.notes);
}

class CookingHistoryTableCompanion
    extends UpdateCompanion<CookingHistoryTableData> {
  final Value<String> id;
  final Value<String> familyId;
  final Value<String> recipeId;
  final Value<String> recipeTitle;
  final Value<int> servingsCooked;
  final Value<String> cookedBy;
  final Value<int> cookedAt;
  final Value<String?> notes;
  final Value<int> rowid;
  const CookingHistoryTableCompanion({
    this.id = const Value.absent(),
    this.familyId = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.recipeTitle = const Value.absent(),
    this.servingsCooked = const Value.absent(),
    this.cookedBy = const Value.absent(),
    this.cookedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CookingHistoryTableCompanion.insert({
    required String id,
    required String familyId,
    required String recipeId,
    required String recipeTitle,
    required int servingsCooked,
    required String cookedBy,
    required int cookedAt,
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        familyId = Value(familyId),
        recipeId = Value(recipeId),
        recipeTitle = Value(recipeTitle),
        servingsCooked = Value(servingsCooked),
        cookedBy = Value(cookedBy),
        cookedAt = Value(cookedAt);
  static Insertable<CookingHistoryTableData> custom({
    Expression<String>? id,
    Expression<String>? familyId,
    Expression<String>? recipeId,
    Expression<String>? recipeTitle,
    Expression<int>? servingsCooked,
    Expression<String>? cookedBy,
    Expression<int>? cookedAt,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (familyId != null) 'family_id': familyId,
      if (recipeId != null) 'recipe_id': recipeId,
      if (recipeTitle != null) 'recipe_title': recipeTitle,
      if (servingsCooked != null) 'servings_cooked': servingsCooked,
      if (cookedBy != null) 'cooked_by': cookedBy,
      if (cookedAt != null) 'cooked_at': cookedAt,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CookingHistoryTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? familyId,
      Value<String>? recipeId,
      Value<String>? recipeTitle,
      Value<int>? servingsCooked,
      Value<String>? cookedBy,
      Value<int>? cookedAt,
      Value<String?>? notes,
      Value<int>? rowid}) {
    return CookingHistoryTableCompanion(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      recipeId: recipeId ?? this.recipeId,
      recipeTitle: recipeTitle ?? this.recipeTitle,
      servingsCooked: servingsCooked ?? this.servingsCooked,
      cookedBy: cookedBy ?? this.cookedBy,
      cookedAt: cookedAt ?? this.cookedAt,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (familyId.present) {
      map['family_id'] = Variable<String>(familyId.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (recipeTitle.present) {
      map['recipe_title'] = Variable<String>(recipeTitle.value);
    }
    if (servingsCooked.present) {
      map['servings_cooked'] = Variable<int>(servingsCooked.value);
    }
    if (cookedBy.present) {
      map['cooked_by'] = Variable<String>(cookedBy.value);
    }
    if (cookedAt.present) {
      map['cooked_at'] = Variable<int>(cookedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CookingHistoryTableCompanion(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('recipeId: $recipeId, ')
          ..write('recipeTitle: $recipeTitle, ')
          ..write('servingsCooked: $servingsCooked, ')
          ..write('cookedBy: $cookedBy, ')
          ..write('cookedAt: $cookedAt, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CookingHistoryIngredientsTableTable
    extends CookingHistoryIngredientsTable
    with
        TableInfo<$CookingHistoryIngredientsTableTable,
            CookingHistoryIngredientsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CookingHistoryIngredientsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _historyIdMeta =
      const VerificationMeta('historyId');
  @override
  late final GeneratedColumn<String> historyId = GeneratedColumn<String>(
      'history_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES cooking_history (id) ON DELETE CASCADE'));
  static const VerificationMeta _ingredientNameMeta =
      const VerificationMeta('ingredientName');
  @override
  late final GeneratedColumn<String> ingredientName = GeneratedColumn<String>(
      'ingredient_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityUsedMeta =
      const VerificationMeta('quantityUsed');
  @override
  late final GeneratedColumn<double> quantityUsed = GeneratedColumn<double>(
      'quantity_used', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pantryItemIdMeta =
      const VerificationMeta('pantryItemId');
  @override
  late final GeneratedColumn<String> pantryItemId = GeneratedColumn<String>(
      'pantry_item_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES pantry_items (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, historyId, ingredientName, quantityUsed, unit, pantryItemId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cooking_history_ingredients';
  @override
  VerificationContext validateIntegrity(
      Insertable<CookingHistoryIngredientsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('history_id')) {
      context.handle(_historyIdMeta,
          historyId.isAcceptableOrUnknown(data['history_id']!, _historyIdMeta));
    } else if (isInserting) {
      context.missing(_historyIdMeta);
    }
    if (data.containsKey('ingredient_name')) {
      context.handle(
          _ingredientNameMeta,
          ingredientName.isAcceptableOrUnknown(
              data['ingredient_name']!, _ingredientNameMeta));
    } else if (isInserting) {
      context.missing(_ingredientNameMeta);
    }
    if (data.containsKey('quantity_used')) {
      context.handle(
          _quantityUsedMeta,
          quantityUsed.isAcceptableOrUnknown(
              data['quantity_used']!, _quantityUsedMeta));
    } else if (isInserting) {
      context.missing(_quantityUsedMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('pantry_item_id')) {
      context.handle(
          _pantryItemIdMeta,
          pantryItemId.isAcceptableOrUnknown(
              data['pantry_item_id']!, _pantryItemIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CookingHistoryIngredientsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CookingHistoryIngredientsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      historyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}history_id'])!,
      ingredientName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}ingredient_name'])!,
      quantityUsed: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity_used'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      pantryItemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pantry_item_id']),
    );
  }

  @override
  $CookingHistoryIngredientsTableTable createAlias(String alias) {
    return $CookingHistoryIngredientsTableTable(attachedDatabase, alias);
  }
}

class CookingHistoryIngredientsTableData extends DataClass
    implements Insertable<CookingHistoryIngredientsTableData> {
  final String id;
  final String historyId;
  final String ingredientName;
  final double quantityUsed;
  final String unit;
  final String? pantryItemId;
  const CookingHistoryIngredientsTableData(
      {required this.id,
      required this.historyId,
      required this.ingredientName,
      required this.quantityUsed,
      required this.unit,
      this.pantryItemId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['history_id'] = Variable<String>(historyId);
    map['ingredient_name'] = Variable<String>(ingredientName);
    map['quantity_used'] = Variable<double>(quantityUsed);
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || pantryItemId != null) {
      map['pantry_item_id'] = Variable<String>(pantryItemId);
    }
    return map;
  }

  CookingHistoryIngredientsTableCompanion toCompanion(bool nullToAbsent) {
    return CookingHistoryIngredientsTableCompanion(
      id: Value(id),
      historyId: Value(historyId),
      ingredientName: Value(ingredientName),
      quantityUsed: Value(quantityUsed),
      unit: Value(unit),
      pantryItemId: pantryItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(pantryItemId),
    );
  }

  factory CookingHistoryIngredientsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CookingHistoryIngredientsTableData(
      id: serializer.fromJson<String>(json['id']),
      historyId: serializer.fromJson<String>(json['historyId']),
      ingredientName: serializer.fromJson<String>(json['ingredientName']),
      quantityUsed: serializer.fromJson<double>(json['quantityUsed']),
      unit: serializer.fromJson<String>(json['unit']),
      pantryItemId: serializer.fromJson<String?>(json['pantryItemId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'historyId': serializer.toJson<String>(historyId),
      'ingredientName': serializer.toJson<String>(ingredientName),
      'quantityUsed': serializer.toJson<double>(quantityUsed),
      'unit': serializer.toJson<String>(unit),
      'pantryItemId': serializer.toJson<String?>(pantryItemId),
    };
  }

  CookingHistoryIngredientsTableData copyWith(
          {String? id,
          String? historyId,
          String? ingredientName,
          double? quantityUsed,
          String? unit,
          Value<String?> pantryItemId = const Value.absent()}) =>
      CookingHistoryIngredientsTableData(
        id: id ?? this.id,
        historyId: historyId ?? this.historyId,
        ingredientName: ingredientName ?? this.ingredientName,
        quantityUsed: quantityUsed ?? this.quantityUsed,
        unit: unit ?? this.unit,
        pantryItemId:
            pantryItemId.present ? pantryItemId.value : this.pantryItemId,
      );
  CookingHistoryIngredientsTableData copyWithCompanion(
      CookingHistoryIngredientsTableCompanion data) {
    return CookingHistoryIngredientsTableData(
      id: data.id.present ? data.id.value : this.id,
      historyId: data.historyId.present ? data.historyId.value : this.historyId,
      ingredientName: data.ingredientName.present
          ? data.ingredientName.value
          : this.ingredientName,
      quantityUsed: data.quantityUsed.present
          ? data.quantityUsed.value
          : this.quantityUsed,
      unit: data.unit.present ? data.unit.value : this.unit,
      pantryItemId: data.pantryItemId.present
          ? data.pantryItemId.value
          : this.pantryItemId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CookingHistoryIngredientsTableData(')
          ..write('id: $id, ')
          ..write('historyId: $historyId, ')
          ..write('ingredientName: $ingredientName, ')
          ..write('quantityUsed: $quantityUsed, ')
          ..write('unit: $unit, ')
          ..write('pantryItemId: $pantryItemId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, historyId, ingredientName, quantityUsed, unit, pantryItemId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CookingHistoryIngredientsTableData &&
          other.id == this.id &&
          other.historyId == this.historyId &&
          other.ingredientName == this.ingredientName &&
          other.quantityUsed == this.quantityUsed &&
          other.unit == this.unit &&
          other.pantryItemId == this.pantryItemId);
}

class CookingHistoryIngredientsTableCompanion
    extends UpdateCompanion<CookingHistoryIngredientsTableData> {
  final Value<String> id;
  final Value<String> historyId;
  final Value<String> ingredientName;
  final Value<double> quantityUsed;
  final Value<String> unit;
  final Value<String?> pantryItemId;
  final Value<int> rowid;
  const CookingHistoryIngredientsTableCompanion({
    this.id = const Value.absent(),
    this.historyId = const Value.absent(),
    this.ingredientName = const Value.absent(),
    this.quantityUsed = const Value.absent(),
    this.unit = const Value.absent(),
    this.pantryItemId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CookingHistoryIngredientsTableCompanion.insert({
    required String id,
    required String historyId,
    required String ingredientName,
    required double quantityUsed,
    required String unit,
    this.pantryItemId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        historyId = Value(historyId),
        ingredientName = Value(ingredientName),
        quantityUsed = Value(quantityUsed),
        unit = Value(unit);
  static Insertable<CookingHistoryIngredientsTableData> custom({
    Expression<String>? id,
    Expression<String>? historyId,
    Expression<String>? ingredientName,
    Expression<double>? quantityUsed,
    Expression<String>? unit,
    Expression<String>? pantryItemId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (historyId != null) 'history_id': historyId,
      if (ingredientName != null) 'ingredient_name': ingredientName,
      if (quantityUsed != null) 'quantity_used': quantityUsed,
      if (unit != null) 'unit': unit,
      if (pantryItemId != null) 'pantry_item_id': pantryItemId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CookingHistoryIngredientsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? historyId,
      Value<String>? ingredientName,
      Value<double>? quantityUsed,
      Value<String>? unit,
      Value<String?>? pantryItemId,
      Value<int>? rowid}) {
    return CookingHistoryIngredientsTableCompanion(
      id: id ?? this.id,
      historyId: historyId ?? this.historyId,
      ingredientName: ingredientName ?? this.ingredientName,
      quantityUsed: quantityUsed ?? this.quantityUsed,
      unit: unit ?? this.unit,
      pantryItemId: pantryItemId ?? this.pantryItemId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (historyId.present) {
      map['history_id'] = Variable<String>(historyId.value);
    }
    if (ingredientName.present) {
      map['ingredient_name'] = Variable<String>(ingredientName.value);
    }
    if (quantityUsed.present) {
      map['quantity_used'] = Variable<double>(quantityUsed.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (pantryItemId.present) {
      map['pantry_item_id'] = Variable<String>(pantryItemId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CookingHistoryIngredientsTableCompanion(')
          ..write('id: $id, ')
          ..write('historyId: $historyId, ')
          ..write('ingredientName: $ingredientName, ')
          ..write('quantityUsed: $quantityUsed, ')
          ..write('unit: $unit, ')
          ..write('pantryItemId: $pantryItemId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTableTable extends SyncQueueTable
    with TableInfo<$SyncQueueTableTable, SyncQueueTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operationMeta =
      const VerificationMeta('operation');
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
      'operation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, entityType, entityId, operation, payload, retryCount, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(_operationMeta,
          operation.isAcceptableOrUnknown(data['operation']!, _operationMeta));
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      operation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SyncQueueTableTable createAlias(String alias) {
    return $SyncQueueTableTable(attachedDatabase, alias);
  }
}

class SyncQueueTableData extends DataClass
    implements Insertable<SyncQueueTableData> {
  final String id;
  final String entityType;
  final String entityId;
  final String operation;
  final String payload;
  final int retryCount;
  final int createdAt;
  const SyncQueueTableData(
      {required this.id,
      required this.entityType,
      required this.entityId,
      required this.operation,
      required this.payload,
      required this.retryCount,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['operation'] = Variable<String>(operation);
    map['payload'] = Variable<String>(payload);
    map['retry_count'] = Variable<int>(retryCount);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  SyncQueueTableCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueTableCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operation: Value(operation),
      payload: Value(payload),
      retryCount: Value(retryCount),
      createdAt: Value(createdAt),
    );
  }

  factory SyncQueueTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueTableData(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      payload: serializer.fromJson<String>(json['payload']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<String>(operation),
      'payload': serializer.toJson<String>(payload),
      'retryCount': serializer.toJson<int>(retryCount),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  SyncQueueTableData copyWith(
          {String? id,
          String? entityType,
          String? entityId,
          String? operation,
          String? payload,
          int? retryCount,
          int? createdAt}) =>
      SyncQueueTableData(
        id: id ?? this.id,
        entityType: entityType ?? this.entityType,
        entityId: entityId ?? this.entityId,
        operation: operation ?? this.operation,
        payload: payload ?? this.payload,
        retryCount: retryCount ?? this.retryCount,
        createdAt: createdAt ?? this.createdAt,
      );
  SyncQueueTableData copyWithCompanion(SyncQueueTableCompanion data) {
    return SyncQueueTableData(
      id: data.id.present ? data.id.value : this.id,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payload: data.payload.present ? data.payload.value : this.payload,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueTableData(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, entityType, entityId, operation, payload, retryCount, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueTableData &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.payload == this.payload &&
          other.retryCount == this.retryCount &&
          other.createdAt == this.createdAt);
}

class SyncQueueTableCompanion extends UpdateCompanion<SyncQueueTableData> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> operation;
  final Value<String> payload;
  final Value<int> retryCount;
  final Value<int> createdAt;
  final Value<int> rowid;
  const SyncQueueTableCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payload = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueTableCompanion.insert({
    required String id,
    required String entityType,
    required String entityId,
    required String operation,
    required String payload,
    this.retryCount = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        entityType = Value(entityType),
        entityId = Value(entityId),
        operation = Value(operation),
        payload = Value(payload),
        createdAt = Value(createdAt);
  static Insertable<SyncQueueTableData> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operation,
    Expression<String>? payload,
    Expression<int>? retryCount,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (payload != null) 'payload': payload,
      if (retryCount != null) 'retry_count': retryCount,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? entityType,
      Value<String>? entityId,
      Value<String>? operation,
      Value<String>? payload,
      Value<int>? retryCount,
      Value<int>? createdAt,
      Value<int>? rowid}) {
    return SyncQueueTableCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueTableCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTableTable extends AppSettingsTable
    with TableInfo<$AppSettingsTableTable, AppSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
      Insertable<AppSettingsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingsTableData(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AppSettingsTableTable createAlias(String alias) {
    return $AppSettingsTableTable(attachedDatabase, alias);
  }
}

class AppSettingsTableData extends DataClass
    implements Insertable<AppSettingsTableData> {
  final String key;
  final String value;
  final int updatedAt;
  const AppSettingsTableData(
      {required this.key, required this.value, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  AppSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsTableCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSettingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingsTableData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  AppSettingsTableData copyWith({String? key, String? value, int? updatedAt}) =>
      AppSettingsTableData(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppSettingsTableData copyWithCompanion(AppSettingsTableCompanion data) {
    return AppSettingsTableData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableData(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingsTableData &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsTableCompanion extends UpdateCompanion<AppSettingsTableData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const AppSettingsTableCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsTableCompanion.insert({
    required String key,
    required String value,
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value),
        updatedAt = Value(updatedAt);
  static Insertable<AppSettingsTableData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsTableCompanion copyWith(
      {Value<String>? key,
      Value<String>? value,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return AppSettingsTableCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTableTable extends CategoriesTable
    with TableInfo<$CategoriesTableTable, CategoriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _familyIdMeta =
      const VerificationMeta('familyId');
  @override
  late final GeneratedColumn<String> familyId = GeneratedColumn<String>(
      'family_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isSystemMeta =
      const VerificationMeta('isSystem');
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
      'is_system', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_system" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, familyId, type, name, value, isSystem, sortOrder, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
      Insertable<CategoriesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('family_id')) {
      context.handle(_familyIdMeta,
          familyId.isAcceptableOrUnknown(data['family_id']!, _familyIdMeta));
    } else if (isInserting) {
      context.missing(_familyIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('is_system')) {
      context.handle(_isSystemMeta,
          isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoriesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoriesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      familyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}family_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
      isSystem: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_system'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CategoriesTableTable createAlias(String alias) {
    return $CategoriesTableTable(attachedDatabase, alias);
  }
}

class CategoriesTableData extends DataClass
    implements Insertable<CategoriesTableData> {
  final String id;
  final String familyId;
  final String type;
  final String name;
  final String value;
  final bool isSystem;
  final int sortOrder;
  final int createdAt;
  const CategoriesTableData(
      {required this.id,
      required this.familyId,
      required this.type,
      required this.name,
      required this.value,
      required this.isSystem,
      required this.sortOrder,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['family_id'] = Variable<String>(familyId);
    map['type'] = Variable<String>(type);
    map['name'] = Variable<String>(name);
    map['value'] = Variable<String>(value);
    map['is_system'] = Variable<bool>(isSystem);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  CategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return CategoriesTableCompanion(
      id: Value(id),
      familyId: Value(familyId),
      type: Value(type),
      name: Value(name),
      value: Value(value),
      isSystem: Value(isSystem),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
    );
  }

  factory CategoriesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoriesTableData(
      id: serializer.fromJson<String>(json['id']),
      familyId: serializer.fromJson<String>(json['familyId']),
      type: serializer.fromJson<String>(json['type']),
      name: serializer.fromJson<String>(json['name']),
      value: serializer.fromJson<String>(json['value']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'familyId': serializer.toJson<String>(familyId),
      'type': serializer.toJson<String>(type),
      'name': serializer.toJson<String>(name),
      'value': serializer.toJson<String>(value),
      'isSystem': serializer.toJson<bool>(isSystem),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  CategoriesTableData copyWith(
          {String? id,
          String? familyId,
          String? type,
          String? name,
          String? value,
          bool? isSystem,
          int? sortOrder,
          int? createdAt}) =>
      CategoriesTableData(
        id: id ?? this.id,
        familyId: familyId ?? this.familyId,
        type: type ?? this.type,
        name: name ?? this.name,
        value: value ?? this.value,
        isSystem: isSystem ?? this.isSystem,
        sortOrder: sortOrder ?? this.sortOrder,
        createdAt: createdAt ?? this.createdAt,
      );
  CategoriesTableData copyWithCompanion(CategoriesTableCompanion data) {
    return CategoriesTableData(
      id: data.id.present ? data.id.value : this.id,
      familyId: data.familyId.present ? data.familyId.value : this.familyId,
      type: data.type.present ? data.type.value : this.type,
      name: data.name.present ? data.name.value : this.name,
      value: data.value.present ? data.value.value : this.value,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableData(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('value: $value, ')
          ..write('isSystem: $isSystem, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, familyId, type, name, value, isSystem, sortOrder, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoriesTableData &&
          other.id == this.id &&
          other.familyId == this.familyId &&
          other.type == this.type &&
          other.name == this.name &&
          other.value == this.value &&
          other.isSystem == this.isSystem &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt);
}

class CategoriesTableCompanion extends UpdateCompanion<CategoriesTableData> {
  final Value<String> id;
  final Value<String> familyId;
  final Value<String> type;
  final Value<String> name;
  final Value<String> value;
  final Value<bool> isSystem;
  final Value<int> sortOrder;
  final Value<int> createdAt;
  final Value<int> rowid;
  const CategoriesTableCompanion({
    this.id = const Value.absent(),
    this.familyId = const Value.absent(),
    this.type = const Value.absent(),
    this.name = const Value.absent(),
    this.value = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesTableCompanion.insert({
    required String id,
    required String familyId,
    required String type,
    required String name,
    required String value,
    this.isSystem = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        familyId = Value(familyId),
        type = Value(type),
        name = Value(name),
        value = Value(value),
        createdAt = Value(createdAt);
  static Insertable<CategoriesTableData> custom({
    Expression<String>? id,
    Expression<String>? familyId,
    Expression<String>? type,
    Expression<String>? name,
    Expression<String>? value,
    Expression<bool>? isSystem,
    Expression<int>? sortOrder,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (familyId != null) 'family_id': familyId,
      if (type != null) 'type': type,
      if (name != null) 'name': name,
      if (value != null) 'value': value,
      if (isSystem != null) 'is_system': isSystem,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? familyId,
      Value<String>? type,
      Value<String>? name,
      Value<String>? value,
      Value<bool>? isSystem,
      Value<int>? sortOrder,
      Value<int>? createdAt,
      Value<int>? rowid}) {
    return CategoriesTableCompanion(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      type: type ?? this.type,
      name: name ?? this.name,
      value: value ?? this.value,
      isSystem: isSystem ?? this.isSystem,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (familyId.present) {
      map['family_id'] = Variable<String>(familyId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('value: $value, ')
          ..write('isSystem: $isSystem, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RecipesTableTable recipesTable = $RecipesTableTable(this);
  late final $IngredientsTableTable ingredientsTable =
      $IngredientsTableTable(this);
  late final $PantryItemsTableTable pantryItemsTable =
      $PantryItemsTableTable(this);
  late final $MealPlansTableTable mealPlansTable = $MealPlansTableTable(this);
  late final $MealPlanRecipesTableTable mealPlanRecipesTable =
      $MealPlanRecipesTableTable(this);
  late final $ShoppingListsTableTable shoppingListsTable =
      $ShoppingListsTableTable(this);
  late final $ShoppingItemsTableTable shoppingItemsTable =
      $ShoppingItemsTableTable(this);
  late final $CookingHistoryTableTable cookingHistoryTable =
      $CookingHistoryTableTable(this);
  late final $CookingHistoryIngredientsTableTable
      cookingHistoryIngredientsTable =
      $CookingHistoryIngredientsTableTable(this);
  late final $SyncQueueTableTable syncQueueTable = $SyncQueueTableTable(this);
  late final $AppSettingsTableTable appSettingsTable =
      $AppSettingsTableTable(this);
  late final $CategoriesTableTable categoriesTable =
      $CategoriesTableTable(this);
  late final RecipesDao recipesDao = RecipesDao(this as AppDatabase);
  late final PantryDao pantryDao = PantryDao(this as AppDatabase);
  late final MealPlanDao mealPlanDao = MealPlanDao(this as AppDatabase);
  late final ShoppingDao shoppingDao = ShoppingDao(this as AppDatabase);
  late final HistoryDao historyDao = HistoryDao(this as AppDatabase);
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  late final CategoriesDao categoriesDao = CategoriesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        recipesTable,
        ingredientsTable,
        pantryItemsTable,
        mealPlansTable,
        mealPlanRecipesTable,
        shoppingListsTable,
        shoppingItemsTable,
        cookingHistoryTable,
        cookingHistoryIngredientsTable,
        syncQueueTable,
        appSettingsTable,
        categoriesTable
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('recipes',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('ingredients', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('meal_plans',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('meal_plan_recipes', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('recipes',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('meal_plan_recipes', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('shopping_lists',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('shopping_items', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('cooking_history',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('cooking_history_ingredients',
                  kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$RecipesTableTableCreateCompanionBuilder = RecipesTableCompanion
    Function({
  required String id,
  required String familyId,
  required String title,
  Value<String?> description,
  Value<String?> photoUrl,
  required String category,
  required String cuisine,
  Value<int> cookTimeMinutes,
  Value<int> defaultServings,
  required String instructions,
  Value<bool> isFavorite,
  required String createdBy,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$RecipesTableTableUpdateCompanionBuilder = RecipesTableCompanion
    Function({
  Value<String> id,
  Value<String> familyId,
  Value<String> title,
  Value<String?> description,
  Value<String?> photoUrl,
  Value<String> category,
  Value<String> cuisine,
  Value<int> cookTimeMinutes,
  Value<int> defaultServings,
  Value<String> instructions,
  Value<bool> isFavorite,
  Value<String> createdBy,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

final class $$RecipesTableTableReferences extends BaseReferences<_$AppDatabase,
    $RecipesTableTable, RecipesTableData> {
  $$RecipesTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$IngredientsTableTable, List<IngredientsTableData>>
      _ingredientsTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.ingredientsTable,
              aliasName: $_aliasNameGenerator(
                  db.recipesTable.id, db.ingredientsTable.recipeId));

  $$IngredientsTableTableProcessedTableManager get ingredientsTableRefs {
    final manager = $$IngredientsTableTableTableManager(
            $_db, $_db.ingredientsTable)
        .filter((f) => f.recipeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_ingredientsTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MealPlanRecipesTableTable,
      List<MealPlanRecipesTableData>> _mealPlanRecipesTableRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.mealPlanRecipesTable,
          aliasName: $_aliasNameGenerator(
              db.recipesTable.id, db.mealPlanRecipesTable.recipeId));

  $$MealPlanRecipesTableTableProcessedTableManager
      get mealPlanRecipesTableRefs {
    final manager = $$MealPlanRecipesTableTableTableManager(
            $_db, $_db.mealPlanRecipesTable)
        .filter((f) => f.recipeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_mealPlanRecipesTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CookingHistoryTableTable,
      List<CookingHistoryTableData>> _cookingHistoryTableRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.cookingHistoryTable,
          aliasName: $_aliasNameGenerator(
              db.recipesTable.id, db.cookingHistoryTable.recipeId));

  $$CookingHistoryTableTableProcessedTableManager get cookingHistoryTableRefs {
    final manager = $$CookingHistoryTableTableTableManager(
            $_db, $_db.cookingHistoryTable)
        .filter((f) => f.recipeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_cookingHistoryTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RecipesTableTableFilterComposer
    extends Composer<_$AppDatabase, $RecipesTableTable> {
  $$RecipesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get familyId => $composableBuilder(
      column: $table.familyId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoUrl => $composableBuilder(
      column: $table.photoUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cuisine => $composableBuilder(
      column: $table.cuisine, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cookTimeMinutes => $composableBuilder(
      column: $table.cookTimeMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get defaultServings => $composableBuilder(
      column: $table.defaultServings,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get instructions => $composableBuilder(
      column: $table.instructions, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> ingredientsTableRefs(
      Expression<bool> Function($$IngredientsTableTableFilterComposer f) f) {
    final $$IngredientsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ingredientsTable,
        getReferencedColumn: (t) => t.recipeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientsTableTableFilterComposer(
              $db: $db,
              $table: $db.ingredientsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> mealPlanRecipesTableRefs(
      Expression<bool> Function($$MealPlanRecipesTableTableFilterComposer f)
          f) {
    final $$MealPlanRecipesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mealPlanRecipesTable,
        getReferencedColumn: (t) => t.recipeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealPlanRecipesTableTableFilterComposer(
              $db: $db,
              $table: $db.mealPlanRecipesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> cookingHistoryTableRefs(
      Expression<bool> Function($$CookingHistoryTableTableFilterComposer f) f) {
    final $$CookingHistoryTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.cookingHistoryTable,
        getReferencedColumn: (t) => t.recipeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CookingHistoryTableTableFilterComposer(
              $db: $db,
              $table: $db.cookingHistoryTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RecipesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipesTableTable> {
  $$RecipesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get familyId => $composableBuilder(
      column: $table.familyId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoUrl => $composableBuilder(
      column: $table.photoUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cuisine => $composableBuilder(
      column: $table.cuisine, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cookTimeMinutes => $composableBuilder(
      column: $table.cookTimeMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get defaultServings => $composableBuilder(
      column: $table.defaultServings,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get instructions => $composableBuilder(
      column: $table.instructions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$RecipesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipesTableTable> {
  $$RecipesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get familyId =>
      $composableBuilder(column: $table.familyId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get cuisine =>
      $composableBuilder(column: $table.cuisine, builder: (column) => column);

  GeneratedColumn<int> get cookTimeMinutes => $composableBuilder(
      column: $table.cookTimeMinutes, builder: (column) => column);

  GeneratedColumn<int> get defaultServings => $composableBuilder(
      column: $table.defaultServings, builder: (column) => column);

  GeneratedColumn<String> get instructions => $composableBuilder(
      column: $table.instructions, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> ingredientsTableRefs<T extends Object>(
      Expression<T> Function($$IngredientsTableTableAnnotationComposer a) f) {
    final $$IngredientsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ingredientsTable,
        getReferencedColumn: (t) => t.recipeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.ingredientsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> mealPlanRecipesTableRefs<T extends Object>(
      Expression<T> Function($$MealPlanRecipesTableTableAnnotationComposer a)
          f) {
    final $$MealPlanRecipesTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.mealPlanRecipesTable,
            getReferencedColumn: (t) => t.recipeId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MealPlanRecipesTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.mealPlanRecipesTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> cookingHistoryTableRefs<T extends Object>(
      Expression<T> Function($$CookingHistoryTableTableAnnotationComposer a)
          f) {
    final $$CookingHistoryTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.cookingHistoryTable,
            getReferencedColumn: (t) => t.recipeId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CookingHistoryTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.cookingHistoryTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$RecipesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecipesTableTable,
    RecipesTableData,
    $$RecipesTableTableFilterComposer,
    $$RecipesTableTableOrderingComposer,
    $$RecipesTableTableAnnotationComposer,
    $$RecipesTableTableCreateCompanionBuilder,
    $$RecipesTableTableUpdateCompanionBuilder,
    (RecipesTableData, $$RecipesTableTableReferences),
    RecipesTableData,
    PrefetchHooks Function(
        {bool ingredientsTableRefs,
        bool mealPlanRecipesTableRefs,
        bool cookingHistoryTableRefs})> {
  $$RecipesTableTableTableManager(_$AppDatabase db, $RecipesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> familyId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> photoUrl = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> cuisine = const Value.absent(),
            Value<int> cookTimeMinutes = const Value.absent(),
            Value<int> defaultServings = const Value.absent(),
            Value<String> instructions = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<String> createdBy = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecipesTableCompanion(
            id: id,
            familyId: familyId,
            title: title,
            description: description,
            photoUrl: photoUrl,
            category: category,
            cuisine: cuisine,
            cookTimeMinutes: cookTimeMinutes,
            defaultServings: defaultServings,
            instructions: instructions,
            isFavorite: isFavorite,
            createdBy: createdBy,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String familyId,
            required String title,
            Value<String?> description = const Value.absent(),
            Value<String?> photoUrl = const Value.absent(),
            required String category,
            required String cuisine,
            Value<int> cookTimeMinutes = const Value.absent(),
            Value<int> defaultServings = const Value.absent(),
            required String instructions,
            Value<bool> isFavorite = const Value.absent(),
            required String createdBy,
            required int createdAt,
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              RecipesTableCompanion.insert(
            id: id,
            familyId: familyId,
            title: title,
            description: description,
            photoUrl: photoUrl,
            category: category,
            cuisine: cuisine,
            cookTimeMinutes: cookTimeMinutes,
            defaultServings: defaultServings,
            instructions: instructions,
            isFavorite: isFavorite,
            createdBy: createdBy,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RecipesTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {ingredientsTableRefs = false,
              mealPlanRecipesTableRefs = false,
              cookingHistoryTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (ingredientsTableRefs) db.ingredientsTable,
                if (mealPlanRecipesTableRefs) db.mealPlanRecipesTable,
                if (cookingHistoryTableRefs) db.cookingHistoryTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ingredientsTableRefs)
                    await $_getPrefetchedData<RecipesTableData,
                            $RecipesTableTable, IngredientsTableData>(
                        currentTable: table,
                        referencedTable: $$RecipesTableTableReferences
                            ._ingredientsTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RecipesTableTableReferences(db, table, p0)
                                .ingredientsTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.recipeId == item.id),
                        typedResults: items),
                  if (mealPlanRecipesTableRefs)
                    await $_getPrefetchedData<RecipesTableData,
                            $RecipesTableTable, MealPlanRecipesTableData>(
                        currentTable: table,
                        referencedTable: $$RecipesTableTableReferences
                            ._mealPlanRecipesTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RecipesTableTableReferences(db, table, p0)
                                .mealPlanRecipesTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.recipeId == item.id),
                        typedResults: items),
                  if (cookingHistoryTableRefs)
                    await $_getPrefetchedData<RecipesTableData,
                            $RecipesTableTable, CookingHistoryTableData>(
                        currentTable: table,
                        referencedTable: $$RecipesTableTableReferences
                            ._cookingHistoryTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RecipesTableTableReferences(db, table, p0)
                                .cookingHistoryTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.recipeId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$RecipesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecipesTableTable,
    RecipesTableData,
    $$RecipesTableTableFilterComposer,
    $$RecipesTableTableOrderingComposer,
    $$RecipesTableTableAnnotationComposer,
    $$RecipesTableTableCreateCompanionBuilder,
    $$RecipesTableTableUpdateCompanionBuilder,
    (RecipesTableData, $$RecipesTableTableReferences),
    RecipesTableData,
    PrefetchHooks Function(
        {bool ingredientsTableRefs,
        bool mealPlanRecipesTableRefs,
        bool cookingHistoryTableRefs})>;
typedef $$IngredientsTableTableCreateCompanionBuilder
    = IngredientsTableCompanion Function({
  required String id,
  required String recipeId,
  required String name,
  required double quantity,
  required String unit,
  Value<String?> category,
  Value<int> sortOrder,
  Value<int> rowid,
});
typedef $$IngredientsTableTableUpdateCompanionBuilder
    = IngredientsTableCompanion Function({
  Value<String> id,
  Value<String> recipeId,
  Value<String> name,
  Value<double> quantity,
  Value<String> unit,
  Value<String?> category,
  Value<int> sortOrder,
  Value<int> rowid,
});

final class $$IngredientsTableTableReferences extends BaseReferences<
    _$AppDatabase, $IngredientsTableTable, IngredientsTableData> {
  $$IngredientsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $RecipesTableTable _recipeIdTable(_$AppDatabase db) =>
      db.recipesTable.createAlias($_aliasNameGenerator(
          db.ingredientsTable.recipeId, db.recipesTable.id));

  $$RecipesTableTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<String>('recipe_id')!;

    final manager = $$RecipesTableTableTableManager($_db, $_db.recipesTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$IngredientsTableTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientsTableTable> {
  $$IngredientsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  $$RecipesTableTableFilterComposer get recipeId {
    final $$RecipesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recipeId,
        referencedTable: $db.recipesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipesTableTableFilterComposer(
              $db: $db,
              $table: $db.recipesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$IngredientsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientsTableTable> {
  $$IngredientsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  $$RecipesTableTableOrderingComposer get recipeId {
    final $$RecipesTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recipeId,
        referencedTable: $db.recipesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipesTableTableOrderingComposer(
              $db: $db,
              $table: $db.recipesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$IngredientsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientsTableTable> {
  $$IngredientsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$RecipesTableTableAnnotationComposer get recipeId {
    final $$RecipesTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recipeId,
        referencedTable: $db.recipesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipesTableTableAnnotationComposer(
              $db: $db,
              $table: $db.recipesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$IngredientsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $IngredientsTableTable,
    IngredientsTableData,
    $$IngredientsTableTableFilterComposer,
    $$IngredientsTableTableOrderingComposer,
    $$IngredientsTableTableAnnotationComposer,
    $$IngredientsTableTableCreateCompanionBuilder,
    $$IngredientsTableTableUpdateCompanionBuilder,
    (IngredientsTableData, $$IngredientsTableTableReferences),
    IngredientsTableData,
    PrefetchHooks Function({bool recipeId})> {
  $$IngredientsTableTableTableManager(
      _$AppDatabase db, $IngredientsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngredientsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IngredientsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> recipeId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              IngredientsTableCompanion(
            id: id,
            recipeId: recipeId,
            name: name,
            quantity: quantity,
            unit: unit,
            category: category,
            sortOrder: sortOrder,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String recipeId,
            required String name,
            required double quantity,
            required String unit,
            Value<String?> category = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              IngredientsTableCompanion.insert(
            id: id,
            recipeId: recipeId,
            name: name,
            quantity: quantity,
            unit: unit,
            category: category,
            sortOrder: sortOrder,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$IngredientsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({recipeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (recipeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.recipeId,
                    referencedTable:
                        $$IngredientsTableTableReferences._recipeIdTable(db),
                    referencedColumn:
                        $$IngredientsTableTableReferences._recipeIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$IngredientsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $IngredientsTableTable,
    IngredientsTableData,
    $$IngredientsTableTableFilterComposer,
    $$IngredientsTableTableOrderingComposer,
    $$IngredientsTableTableAnnotationComposer,
    $$IngredientsTableTableCreateCompanionBuilder,
    $$IngredientsTableTableUpdateCompanionBuilder,
    (IngredientsTableData, $$IngredientsTableTableReferences),
    IngredientsTableData,
    PrefetchHooks Function({bool recipeId})>;
typedef $$PantryItemsTableTableCreateCompanionBuilder
    = PantryItemsTableCompanion Function({
  required String id,
  required String familyId,
  required String name,
  Value<double> quantity,
  required String unit,
  required String category,
  Value<double> minQuantity,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$PantryItemsTableTableUpdateCompanionBuilder
    = PantryItemsTableCompanion Function({
  Value<String> id,
  Value<String> familyId,
  Value<String> name,
  Value<double> quantity,
  Value<String> unit,
  Value<String> category,
  Value<double> minQuantity,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

final class $$PantryItemsTableTableReferences extends BaseReferences<
    _$AppDatabase, $PantryItemsTableTable, PantryItemsTableData> {
  $$PantryItemsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CookingHistoryIngredientsTableTable,
          List<CookingHistoryIngredientsTableData>>
      _cookingHistoryIngredientsTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.cookingHistoryIngredientsTable,
              aliasName: $_aliasNameGenerator(db.pantryItemsTable.id,
                  db.cookingHistoryIngredientsTable.pantryItemId));

  $$CookingHistoryIngredientsTableTableProcessedTableManager
      get cookingHistoryIngredientsTableRefs {
    final manager = $$CookingHistoryIngredientsTableTableTableManager(
            $_db, $_db.cookingHistoryIngredientsTable)
        .filter(
            (f) => f.pantryItemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult
        .readTableOrNull(_cookingHistoryIngredientsTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PantryItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PantryItemsTableTable> {
  $$PantryItemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get familyId => $composableBuilder(
      column: $table.familyId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get minQuantity => $composableBuilder(
      column: $table.minQuantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> cookingHistoryIngredientsTableRefs(
      Expression<bool> Function(
              $$CookingHistoryIngredientsTableTableFilterComposer f)
          f) {
    final $$CookingHistoryIngredientsTableTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.cookingHistoryIngredientsTable,
            getReferencedColumn: (t) => t.pantryItemId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CookingHistoryIngredientsTableTableFilterComposer(
                  $db: $db,
                  $table: $db.cookingHistoryIngredientsTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$PantryItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PantryItemsTableTable> {
  $$PantryItemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get familyId => $composableBuilder(
      column: $table.familyId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get minQuantity => $composableBuilder(
      column: $table.minQuantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PantryItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PantryItemsTableTable> {
  $$PantryItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get familyId =>
      $composableBuilder(column: $table.familyId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get minQuantity => $composableBuilder(
      column: $table.minQuantity, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> cookingHistoryIngredientsTableRefs<T extends Object>(
      Expression<T> Function(
              $$CookingHistoryIngredientsTableTableAnnotationComposer a)
          f) {
    final $$CookingHistoryIngredientsTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.cookingHistoryIngredientsTable,
            getReferencedColumn: (t) => t.pantryItemId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CookingHistoryIngredientsTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.cookingHistoryIngredientsTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$PantryItemsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PantryItemsTableTable,
    PantryItemsTableData,
    $$PantryItemsTableTableFilterComposer,
    $$PantryItemsTableTableOrderingComposer,
    $$PantryItemsTableTableAnnotationComposer,
    $$PantryItemsTableTableCreateCompanionBuilder,
    $$PantryItemsTableTableUpdateCompanionBuilder,
    (PantryItemsTableData, $$PantryItemsTableTableReferences),
    PantryItemsTableData,
    PrefetchHooks Function({bool cookingHistoryIngredientsTableRefs})> {
  $$PantryItemsTableTableTableManager(
      _$AppDatabase db, $PantryItemsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PantryItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PantryItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PantryItemsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> familyId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<double> minQuantity = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PantryItemsTableCompanion(
            id: id,
            familyId: familyId,
            name: name,
            quantity: quantity,
            unit: unit,
            category: category,
            minQuantity: minQuantity,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String familyId,
            required String name,
            Value<double> quantity = const Value.absent(),
            required String unit,
            required String category,
            Value<double> minQuantity = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              PantryItemsTableCompanion.insert(
            id: id,
            familyId: familyId,
            name: name,
            quantity: quantity,
            unit: unit,
            category: category,
            minQuantity: minQuantity,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PantryItemsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {cookingHistoryIngredientsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (cookingHistoryIngredientsTableRefs)
                  db.cookingHistoryIngredientsTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (cookingHistoryIngredientsTableRefs)
                    await $_getPrefetchedData<
                            PantryItemsTableData,
                            $PantryItemsTableTable,
                            CookingHistoryIngredientsTableData>(
                        currentTable: table,
                        referencedTable: $$PantryItemsTableTableReferences
                            ._cookingHistoryIngredientsTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PantryItemsTableTableReferences(db, table, p0)
                                .cookingHistoryIngredientsTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.pantryItemId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PantryItemsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PantryItemsTableTable,
    PantryItemsTableData,
    $$PantryItemsTableTableFilterComposer,
    $$PantryItemsTableTableOrderingComposer,
    $$PantryItemsTableTableAnnotationComposer,
    $$PantryItemsTableTableCreateCompanionBuilder,
    $$PantryItemsTableTableUpdateCompanionBuilder,
    (PantryItemsTableData, $$PantryItemsTableTableReferences),
    PantryItemsTableData,
    PrefetchHooks Function({bool cookingHistoryIngredientsTableRefs})>;
typedef $$MealPlansTableTableCreateCompanionBuilder = MealPlansTableCompanion
    Function({
  required String id,
  required String familyId,
  required int planDate,
  required String mealType,
  Value<int> servings,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$MealPlansTableTableUpdateCompanionBuilder = MealPlansTableCompanion
    Function({
  Value<String> id,
  Value<String> familyId,
  Value<int> planDate,
  Value<String> mealType,
  Value<int> servings,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

final class $$MealPlansTableTableReferences extends BaseReferences<
    _$AppDatabase, $MealPlansTableTable, MealPlansTableData> {
  $$MealPlansTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MealPlanRecipesTableTable,
      List<MealPlanRecipesTableData>> _mealPlanRecipesTableRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.mealPlanRecipesTable,
          aliasName: $_aliasNameGenerator(
              db.mealPlansTable.id, db.mealPlanRecipesTable.mealPlanId));

  $$MealPlanRecipesTableTableProcessedTableManager
      get mealPlanRecipesTableRefs {
    final manager = $$MealPlanRecipesTableTableTableManager(
            $_db, $_db.mealPlanRecipesTable)
        .filter((f) => f.mealPlanId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_mealPlanRecipesTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MealPlansTableTableFilterComposer
    extends Composer<_$AppDatabase, $MealPlansTableTable> {
  $$MealPlansTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get familyId => $composableBuilder(
      column: $table.familyId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get planDate => $composableBuilder(
      column: $table.planDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mealType => $composableBuilder(
      column: $table.mealType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get servings => $composableBuilder(
      column: $table.servings, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> mealPlanRecipesTableRefs(
      Expression<bool> Function($$MealPlanRecipesTableTableFilterComposer f)
          f) {
    final $$MealPlanRecipesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mealPlanRecipesTable,
        getReferencedColumn: (t) => t.mealPlanId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealPlanRecipesTableTableFilterComposer(
              $db: $db,
              $table: $db.mealPlanRecipesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MealPlansTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MealPlansTableTable> {
  $$MealPlansTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get familyId => $composableBuilder(
      column: $table.familyId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get planDate => $composableBuilder(
      column: $table.planDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mealType => $composableBuilder(
      column: $table.mealType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get servings => $composableBuilder(
      column: $table.servings, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$MealPlansTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealPlansTableTable> {
  $$MealPlansTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get familyId =>
      $composableBuilder(column: $table.familyId, builder: (column) => column);

  GeneratedColumn<int> get planDate =>
      $composableBuilder(column: $table.planDate, builder: (column) => column);

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<int> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> mealPlanRecipesTableRefs<T extends Object>(
      Expression<T> Function($$MealPlanRecipesTableTableAnnotationComposer a)
          f) {
    final $$MealPlanRecipesTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.mealPlanRecipesTable,
            getReferencedColumn: (t) => t.mealPlanId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MealPlanRecipesTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.mealPlanRecipesTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$MealPlansTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MealPlansTableTable,
    MealPlansTableData,
    $$MealPlansTableTableFilterComposer,
    $$MealPlansTableTableOrderingComposer,
    $$MealPlansTableTableAnnotationComposer,
    $$MealPlansTableTableCreateCompanionBuilder,
    $$MealPlansTableTableUpdateCompanionBuilder,
    (MealPlansTableData, $$MealPlansTableTableReferences),
    MealPlansTableData,
    PrefetchHooks Function({bool mealPlanRecipesTableRefs})> {
  $$MealPlansTableTableTableManager(
      _$AppDatabase db, $MealPlansTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealPlansTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealPlansTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealPlansTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> familyId = const Value.absent(),
            Value<int> planDate = const Value.absent(),
            Value<String> mealType = const Value.absent(),
            Value<int> servings = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MealPlansTableCompanion(
            id: id,
            familyId: familyId,
            planDate: planDate,
            mealType: mealType,
            servings: servings,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String familyId,
            required int planDate,
            required String mealType,
            Value<int> servings = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              MealPlansTableCompanion.insert(
            id: id,
            familyId: familyId,
            planDate: planDate,
            mealType: mealType,
            servings: servings,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MealPlansTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({mealPlanRecipesTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (mealPlanRecipesTableRefs) db.mealPlanRecipesTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mealPlanRecipesTableRefs)
                    await $_getPrefetchedData<MealPlansTableData,
                            $MealPlansTableTable, MealPlanRecipesTableData>(
                        currentTable: table,
                        referencedTable: $$MealPlansTableTableReferences
                            ._mealPlanRecipesTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MealPlansTableTableReferences(db, table, p0)
                                .mealPlanRecipesTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.mealPlanId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MealPlansTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MealPlansTableTable,
    MealPlansTableData,
    $$MealPlansTableTableFilterComposer,
    $$MealPlansTableTableOrderingComposer,
    $$MealPlansTableTableAnnotationComposer,
    $$MealPlansTableTableCreateCompanionBuilder,
    $$MealPlansTableTableUpdateCompanionBuilder,
    (MealPlansTableData, $$MealPlansTableTableReferences),
    MealPlansTableData,
    PrefetchHooks Function({bool mealPlanRecipesTableRefs})>;
typedef $$MealPlanRecipesTableTableCreateCompanionBuilder
    = MealPlanRecipesTableCompanion Function({
  required String id,
  required String mealPlanId,
  required String recipeId,
  Value<int> sortOrder,
  Value<int> rowid,
});
typedef $$MealPlanRecipesTableTableUpdateCompanionBuilder
    = MealPlanRecipesTableCompanion Function({
  Value<String> id,
  Value<String> mealPlanId,
  Value<String> recipeId,
  Value<int> sortOrder,
  Value<int> rowid,
});

final class $$MealPlanRecipesTableTableReferences extends BaseReferences<
    _$AppDatabase, $MealPlanRecipesTableTable, MealPlanRecipesTableData> {
  $$MealPlanRecipesTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MealPlansTableTable _mealPlanIdTable(_$AppDatabase db) =>
      db.mealPlansTable.createAlias($_aliasNameGenerator(
          db.mealPlanRecipesTable.mealPlanId, db.mealPlansTable.id));

  $$MealPlansTableTableProcessedTableManager get mealPlanId {
    final $_column = $_itemColumn<String>('meal_plan_id')!;

    final manager = $$MealPlansTableTableTableManager($_db, $_db.mealPlansTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mealPlanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $RecipesTableTable _recipeIdTable(_$AppDatabase db) =>
      db.recipesTable.createAlias($_aliasNameGenerator(
          db.mealPlanRecipesTable.recipeId, db.recipesTable.id));

  $$RecipesTableTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<String>('recipe_id')!;

    final manager = $$RecipesTableTableTableManager($_db, $_db.recipesTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MealPlanRecipesTableTableFilterComposer
    extends Composer<_$AppDatabase, $MealPlanRecipesTableTable> {
  $$MealPlanRecipesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  $$MealPlansTableTableFilterComposer get mealPlanId {
    final $$MealPlansTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mealPlanId,
        referencedTable: $db.mealPlansTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealPlansTableTableFilterComposer(
              $db: $db,
              $table: $db.mealPlansTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RecipesTableTableFilterComposer get recipeId {
    final $$RecipesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recipeId,
        referencedTable: $db.recipesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipesTableTableFilterComposer(
              $db: $db,
              $table: $db.recipesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MealPlanRecipesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MealPlanRecipesTableTable> {
  $$MealPlanRecipesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  $$MealPlansTableTableOrderingComposer get mealPlanId {
    final $$MealPlansTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mealPlanId,
        referencedTable: $db.mealPlansTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealPlansTableTableOrderingComposer(
              $db: $db,
              $table: $db.mealPlansTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RecipesTableTableOrderingComposer get recipeId {
    final $$RecipesTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recipeId,
        referencedTable: $db.recipesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipesTableTableOrderingComposer(
              $db: $db,
              $table: $db.recipesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MealPlanRecipesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealPlanRecipesTableTable> {
  $$MealPlanRecipesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$MealPlansTableTableAnnotationComposer get mealPlanId {
    final $$MealPlansTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mealPlanId,
        referencedTable: $db.mealPlansTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealPlansTableTableAnnotationComposer(
              $db: $db,
              $table: $db.mealPlansTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RecipesTableTableAnnotationComposer get recipeId {
    final $$RecipesTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recipeId,
        referencedTable: $db.recipesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipesTableTableAnnotationComposer(
              $db: $db,
              $table: $db.recipesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MealPlanRecipesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MealPlanRecipesTableTable,
    MealPlanRecipesTableData,
    $$MealPlanRecipesTableTableFilterComposer,
    $$MealPlanRecipesTableTableOrderingComposer,
    $$MealPlanRecipesTableTableAnnotationComposer,
    $$MealPlanRecipesTableTableCreateCompanionBuilder,
    $$MealPlanRecipesTableTableUpdateCompanionBuilder,
    (MealPlanRecipesTableData, $$MealPlanRecipesTableTableReferences),
    MealPlanRecipesTableData,
    PrefetchHooks Function({bool mealPlanId, bool recipeId})> {
  $$MealPlanRecipesTableTableTableManager(
      _$AppDatabase db, $MealPlanRecipesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealPlanRecipesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealPlanRecipesTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealPlanRecipesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> mealPlanId = const Value.absent(),
            Value<String> recipeId = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MealPlanRecipesTableCompanion(
            id: id,
            mealPlanId: mealPlanId,
            recipeId: recipeId,
            sortOrder: sortOrder,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String mealPlanId,
            required String recipeId,
            Value<int> sortOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MealPlanRecipesTableCompanion.insert(
            id: id,
            mealPlanId: mealPlanId,
            recipeId: recipeId,
            sortOrder: sortOrder,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MealPlanRecipesTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({mealPlanId = false, recipeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (mealPlanId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.mealPlanId,
                    referencedTable: $$MealPlanRecipesTableTableReferences
                        ._mealPlanIdTable(db),
                    referencedColumn: $$MealPlanRecipesTableTableReferences
                        ._mealPlanIdTable(db)
                        .id,
                  ) as T;
                }
                if (recipeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.recipeId,
                    referencedTable: $$MealPlanRecipesTableTableReferences
                        ._recipeIdTable(db),
                    referencedColumn: $$MealPlanRecipesTableTableReferences
                        ._recipeIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MealPlanRecipesTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $MealPlanRecipesTableTable,
        MealPlanRecipesTableData,
        $$MealPlanRecipesTableTableFilterComposer,
        $$MealPlanRecipesTableTableOrderingComposer,
        $$MealPlanRecipesTableTableAnnotationComposer,
        $$MealPlanRecipesTableTableCreateCompanionBuilder,
        $$MealPlanRecipesTableTableUpdateCompanionBuilder,
        (MealPlanRecipesTableData, $$MealPlanRecipesTableTableReferences),
        MealPlanRecipesTableData,
        PrefetchHooks Function({bool mealPlanId, bool recipeId})>;
typedef $$ShoppingListsTableTableCreateCompanionBuilder
    = ShoppingListsTableCompanion Function({
  required String id,
  required String familyId,
  required String name,
  required int dateFrom,
  required int dateTo,
  Value<bool> isCompleted,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$ShoppingListsTableTableUpdateCompanionBuilder
    = ShoppingListsTableCompanion Function({
  Value<String> id,
  Value<String> familyId,
  Value<String> name,
  Value<int> dateFrom,
  Value<int> dateTo,
  Value<bool> isCompleted,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

final class $$ShoppingListsTableTableReferences extends BaseReferences<
    _$AppDatabase, $ShoppingListsTableTable, ShoppingListsTableData> {
  $$ShoppingListsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ShoppingItemsTableTable,
      List<ShoppingItemsTableData>> _shoppingItemsTableRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.shoppingItemsTable,
          aliasName: $_aliasNameGenerator(
              db.shoppingListsTable.id, db.shoppingItemsTable.shoppingListId));

  $$ShoppingItemsTableTableProcessedTableManager get shoppingItemsTableRefs {
    final manager = $$ShoppingItemsTableTableTableManager(
            $_db, $_db.shoppingItemsTable)
        .filter(
            (f) => f.shoppingListId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_shoppingItemsTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ShoppingListsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingListsTableTable> {
  $$ShoppingListsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get familyId => $composableBuilder(
      column: $table.familyId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dateFrom => $composableBuilder(
      column: $table.dateFrom, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dateTo => $composableBuilder(
      column: $table.dateTo, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> shoppingItemsTableRefs(
      Expression<bool> Function($$ShoppingItemsTableTableFilterComposer f) f) {
    final $$ShoppingItemsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.shoppingItemsTable,
        getReferencedColumn: (t) => t.shoppingListId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShoppingItemsTableTableFilterComposer(
              $db: $db,
              $table: $db.shoppingItemsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ShoppingListsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingListsTableTable> {
  $$ShoppingListsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get familyId => $composableBuilder(
      column: $table.familyId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dateFrom => $composableBuilder(
      column: $table.dateFrom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dateTo => $composableBuilder(
      column: $table.dateTo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ShoppingListsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingListsTableTable> {
  $$ShoppingListsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get familyId =>
      $composableBuilder(column: $table.familyId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get dateFrom =>
      $composableBuilder(column: $table.dateFrom, builder: (column) => column);

  GeneratedColumn<int> get dateTo =>
      $composableBuilder(column: $table.dateTo, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> shoppingItemsTableRefs<T extends Object>(
      Expression<T> Function($$ShoppingItemsTableTableAnnotationComposer a) f) {
    final $$ShoppingItemsTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.shoppingItemsTable,
            getReferencedColumn: (t) => t.shoppingListId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ShoppingItemsTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.shoppingItemsTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ShoppingListsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ShoppingListsTableTable,
    ShoppingListsTableData,
    $$ShoppingListsTableTableFilterComposer,
    $$ShoppingListsTableTableOrderingComposer,
    $$ShoppingListsTableTableAnnotationComposer,
    $$ShoppingListsTableTableCreateCompanionBuilder,
    $$ShoppingListsTableTableUpdateCompanionBuilder,
    (ShoppingListsTableData, $$ShoppingListsTableTableReferences),
    ShoppingListsTableData,
    PrefetchHooks Function({bool shoppingItemsTableRefs})> {
  $$ShoppingListsTableTableTableManager(
      _$AppDatabase db, $ShoppingListsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingListsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingListsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingListsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> familyId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> dateFrom = const Value.absent(),
            Value<int> dateTo = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShoppingListsTableCompanion(
            id: id,
            familyId: familyId,
            name: name,
            dateFrom: dateFrom,
            dateTo: dateTo,
            isCompleted: isCompleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String familyId,
            required String name,
            required int dateFrom,
            required int dateTo,
            Value<bool> isCompleted = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ShoppingListsTableCompanion.insert(
            id: id,
            familyId: familyId,
            name: name,
            dateFrom: dateFrom,
            dateTo: dateTo,
            isCompleted: isCompleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ShoppingListsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({shoppingItemsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (shoppingItemsTableRefs) db.shoppingItemsTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (shoppingItemsTableRefs)
                    await $_getPrefetchedData<ShoppingListsTableData,
                            $ShoppingListsTableTable, ShoppingItemsTableData>(
                        currentTable: table,
                        referencedTable: $$ShoppingListsTableTableReferences
                            ._shoppingItemsTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ShoppingListsTableTableReferences(db, table, p0)
                                .shoppingItemsTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.shoppingListId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ShoppingListsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ShoppingListsTableTable,
    ShoppingListsTableData,
    $$ShoppingListsTableTableFilterComposer,
    $$ShoppingListsTableTableOrderingComposer,
    $$ShoppingListsTableTableAnnotationComposer,
    $$ShoppingListsTableTableCreateCompanionBuilder,
    $$ShoppingListsTableTableUpdateCompanionBuilder,
    (ShoppingListsTableData, $$ShoppingListsTableTableReferences),
    ShoppingListsTableData,
    PrefetchHooks Function({bool shoppingItemsTableRefs})>;
typedef $$ShoppingItemsTableTableCreateCompanionBuilder
    = ShoppingItemsTableCompanion Function({
  required String id,
  required String shoppingListId,
  required String name,
  required double quantityNeeded,
  Value<double> quantityInPantry,
  required double quantityToBuy,
  required String unit,
  Value<String?> category,
  Value<bool> isChecked,
  Value<bool> isManual,
  Value<int> rowid,
});
typedef $$ShoppingItemsTableTableUpdateCompanionBuilder
    = ShoppingItemsTableCompanion Function({
  Value<String> id,
  Value<String> shoppingListId,
  Value<String> name,
  Value<double> quantityNeeded,
  Value<double> quantityInPantry,
  Value<double> quantityToBuy,
  Value<String> unit,
  Value<String?> category,
  Value<bool> isChecked,
  Value<bool> isManual,
  Value<int> rowid,
});

final class $$ShoppingItemsTableTableReferences extends BaseReferences<
    _$AppDatabase, $ShoppingItemsTableTable, ShoppingItemsTableData> {
  $$ShoppingItemsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ShoppingListsTableTable _shoppingListIdTable(_$AppDatabase db) =>
      db.shoppingListsTable.createAlias($_aliasNameGenerator(
          db.shoppingItemsTable.shoppingListId, db.shoppingListsTable.id));

  $$ShoppingListsTableTableProcessedTableManager get shoppingListId {
    final $_column = $_itemColumn<String>('shopping_list_id')!;

    final manager =
        $$ShoppingListsTableTableTableManager($_db, $_db.shoppingListsTable)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shoppingListIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ShoppingItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTableTable> {
  $$ShoppingItemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantityNeeded => $composableBuilder(
      column: $table.quantityNeeded,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantityInPantry => $composableBuilder(
      column: $table.quantityInPantry,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantityToBuy => $composableBuilder(
      column: $table.quantityToBuy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isChecked => $composableBuilder(
      column: $table.isChecked, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isManual => $composableBuilder(
      column: $table.isManual, builder: (column) => ColumnFilters(column));

  $$ShoppingListsTableTableFilterComposer get shoppingListId {
    final $$ShoppingListsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shoppingListId,
        referencedTable: $db.shoppingListsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShoppingListsTableTableFilterComposer(
              $db: $db,
              $table: $db.shoppingListsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ShoppingItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTableTable> {
  $$ShoppingItemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantityNeeded => $composableBuilder(
      column: $table.quantityNeeded,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantityInPantry => $composableBuilder(
      column: $table.quantityInPantry,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantityToBuy => $composableBuilder(
      column: $table.quantityToBuy,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isChecked => $composableBuilder(
      column: $table.isChecked, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isManual => $composableBuilder(
      column: $table.isManual, builder: (column) => ColumnOrderings(column));

  $$ShoppingListsTableTableOrderingComposer get shoppingListId {
    final $$ShoppingListsTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shoppingListId,
        referencedTable: $db.shoppingListsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShoppingListsTableTableOrderingComposer(
              $db: $db,
              $table: $db.shoppingListsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ShoppingItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTableTable> {
  $$ShoppingItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get quantityNeeded => $composableBuilder(
      column: $table.quantityNeeded, builder: (column) => column);

  GeneratedColumn<double> get quantityInPantry => $composableBuilder(
      column: $table.quantityInPantry, builder: (column) => column);

  GeneratedColumn<double> get quantityToBuy => $composableBuilder(
      column: $table.quantityToBuy, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get isChecked =>
      $composableBuilder(column: $table.isChecked, builder: (column) => column);

  GeneratedColumn<bool> get isManual =>
      $composableBuilder(column: $table.isManual, builder: (column) => column);

  $$ShoppingListsTableTableAnnotationComposer get shoppingListId {
    final $$ShoppingListsTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.shoppingListId,
            referencedTable: $db.shoppingListsTable,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ShoppingListsTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.shoppingListsTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$ShoppingItemsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ShoppingItemsTableTable,
    ShoppingItemsTableData,
    $$ShoppingItemsTableTableFilterComposer,
    $$ShoppingItemsTableTableOrderingComposer,
    $$ShoppingItemsTableTableAnnotationComposer,
    $$ShoppingItemsTableTableCreateCompanionBuilder,
    $$ShoppingItemsTableTableUpdateCompanionBuilder,
    (ShoppingItemsTableData, $$ShoppingItemsTableTableReferences),
    ShoppingItemsTableData,
    PrefetchHooks Function({bool shoppingListId})> {
  $$ShoppingItemsTableTableTableManager(
      _$AppDatabase db, $ShoppingItemsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingItemsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> shoppingListId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> quantityNeeded = const Value.absent(),
            Value<double> quantityInPantry = const Value.absent(),
            Value<double> quantityToBuy = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<bool> isChecked = const Value.absent(),
            Value<bool> isManual = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShoppingItemsTableCompanion(
            id: id,
            shoppingListId: shoppingListId,
            name: name,
            quantityNeeded: quantityNeeded,
            quantityInPantry: quantityInPantry,
            quantityToBuy: quantityToBuy,
            unit: unit,
            category: category,
            isChecked: isChecked,
            isManual: isManual,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String shoppingListId,
            required String name,
            required double quantityNeeded,
            Value<double> quantityInPantry = const Value.absent(),
            required double quantityToBuy,
            required String unit,
            Value<String?> category = const Value.absent(),
            Value<bool> isChecked = const Value.absent(),
            Value<bool> isManual = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShoppingItemsTableCompanion.insert(
            id: id,
            shoppingListId: shoppingListId,
            name: name,
            quantityNeeded: quantityNeeded,
            quantityInPantry: quantityInPantry,
            quantityToBuy: quantityToBuy,
            unit: unit,
            category: category,
            isChecked: isChecked,
            isManual: isManual,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ShoppingItemsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({shoppingListId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (shoppingListId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.shoppingListId,
                    referencedTable: $$ShoppingItemsTableTableReferences
                        ._shoppingListIdTable(db),
                    referencedColumn: $$ShoppingItemsTableTableReferences
                        ._shoppingListIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ShoppingItemsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ShoppingItemsTableTable,
    ShoppingItemsTableData,
    $$ShoppingItemsTableTableFilterComposer,
    $$ShoppingItemsTableTableOrderingComposer,
    $$ShoppingItemsTableTableAnnotationComposer,
    $$ShoppingItemsTableTableCreateCompanionBuilder,
    $$ShoppingItemsTableTableUpdateCompanionBuilder,
    (ShoppingItemsTableData, $$ShoppingItemsTableTableReferences),
    ShoppingItemsTableData,
    PrefetchHooks Function({bool shoppingListId})>;
typedef $$CookingHistoryTableTableCreateCompanionBuilder
    = CookingHistoryTableCompanion Function({
  required String id,
  required String familyId,
  required String recipeId,
  required String recipeTitle,
  required int servingsCooked,
  required String cookedBy,
  required int cookedAt,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$CookingHistoryTableTableUpdateCompanionBuilder
    = CookingHistoryTableCompanion Function({
  Value<String> id,
  Value<String> familyId,
  Value<String> recipeId,
  Value<String> recipeTitle,
  Value<int> servingsCooked,
  Value<String> cookedBy,
  Value<int> cookedAt,
  Value<String?> notes,
  Value<int> rowid,
});

final class $$CookingHistoryTableTableReferences extends BaseReferences<
    _$AppDatabase, $CookingHistoryTableTable, CookingHistoryTableData> {
  $$CookingHistoryTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $RecipesTableTable _recipeIdTable(_$AppDatabase db) =>
      db.recipesTable.createAlias($_aliasNameGenerator(
          db.cookingHistoryTable.recipeId, db.recipesTable.id));

  $$RecipesTableTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<String>('recipe_id')!;

    final manager = $$RecipesTableTableTableManager($_db, $_db.recipesTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$CookingHistoryIngredientsTableTable,
          List<CookingHistoryIngredientsTableData>>
      _cookingHistoryIngredientsTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.cookingHistoryIngredientsTable,
              aliasName: $_aliasNameGenerator(db.cookingHistoryTable.id,
                  db.cookingHistoryIngredientsTable.historyId));

  $$CookingHistoryIngredientsTableTableProcessedTableManager
      get cookingHistoryIngredientsTableRefs {
    final manager = $$CookingHistoryIngredientsTableTableTableManager(
            $_db, $_db.cookingHistoryIngredientsTable)
        .filter((f) => f.historyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult
        .readTableOrNull(_cookingHistoryIngredientsTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CookingHistoryTableTableFilterComposer
    extends Composer<_$AppDatabase, $CookingHistoryTableTable> {
  $$CookingHistoryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get familyId => $composableBuilder(
      column: $table.familyId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recipeTitle => $composableBuilder(
      column: $table.recipeTitle, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get servingsCooked => $composableBuilder(
      column: $table.servingsCooked,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cookedBy => $composableBuilder(
      column: $table.cookedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cookedAt => $composableBuilder(
      column: $table.cookedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  $$RecipesTableTableFilterComposer get recipeId {
    final $$RecipesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recipeId,
        referencedTable: $db.recipesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipesTableTableFilterComposer(
              $db: $db,
              $table: $db.recipesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> cookingHistoryIngredientsTableRefs(
      Expression<bool> Function(
              $$CookingHistoryIngredientsTableTableFilterComposer f)
          f) {
    final $$CookingHistoryIngredientsTableTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.cookingHistoryIngredientsTable,
            getReferencedColumn: (t) => t.historyId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CookingHistoryIngredientsTableTableFilterComposer(
                  $db: $db,
                  $table: $db.cookingHistoryIngredientsTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$CookingHistoryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CookingHistoryTableTable> {
  $$CookingHistoryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get familyId => $composableBuilder(
      column: $table.familyId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recipeTitle => $composableBuilder(
      column: $table.recipeTitle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get servingsCooked => $composableBuilder(
      column: $table.servingsCooked,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cookedBy => $composableBuilder(
      column: $table.cookedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cookedAt => $composableBuilder(
      column: $table.cookedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  $$RecipesTableTableOrderingComposer get recipeId {
    final $$RecipesTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recipeId,
        referencedTable: $db.recipesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipesTableTableOrderingComposer(
              $db: $db,
              $table: $db.recipesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CookingHistoryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CookingHistoryTableTable> {
  $$CookingHistoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get familyId =>
      $composableBuilder(column: $table.familyId, builder: (column) => column);

  GeneratedColumn<String> get recipeTitle => $composableBuilder(
      column: $table.recipeTitle, builder: (column) => column);

  GeneratedColumn<int> get servingsCooked => $composableBuilder(
      column: $table.servingsCooked, builder: (column) => column);

  GeneratedColumn<String> get cookedBy =>
      $composableBuilder(column: $table.cookedBy, builder: (column) => column);

  GeneratedColumn<int> get cookedAt =>
      $composableBuilder(column: $table.cookedAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$RecipesTableTableAnnotationComposer get recipeId {
    final $$RecipesTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recipeId,
        referencedTable: $db.recipesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipesTableTableAnnotationComposer(
              $db: $db,
              $table: $db.recipesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> cookingHistoryIngredientsTableRefs<T extends Object>(
      Expression<T> Function(
              $$CookingHistoryIngredientsTableTableAnnotationComposer a)
          f) {
    final $$CookingHistoryIngredientsTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.cookingHistoryIngredientsTable,
            getReferencedColumn: (t) => t.historyId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CookingHistoryIngredientsTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.cookingHistoryIngredientsTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$CookingHistoryTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CookingHistoryTableTable,
    CookingHistoryTableData,
    $$CookingHistoryTableTableFilterComposer,
    $$CookingHistoryTableTableOrderingComposer,
    $$CookingHistoryTableTableAnnotationComposer,
    $$CookingHistoryTableTableCreateCompanionBuilder,
    $$CookingHistoryTableTableUpdateCompanionBuilder,
    (CookingHistoryTableData, $$CookingHistoryTableTableReferences),
    CookingHistoryTableData,
    PrefetchHooks Function(
        {bool recipeId, bool cookingHistoryIngredientsTableRefs})> {
  $$CookingHistoryTableTableTableManager(
      _$AppDatabase db, $CookingHistoryTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CookingHistoryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CookingHistoryTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CookingHistoryTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> familyId = const Value.absent(),
            Value<String> recipeId = const Value.absent(),
            Value<String> recipeTitle = const Value.absent(),
            Value<int> servingsCooked = const Value.absent(),
            Value<String> cookedBy = const Value.absent(),
            Value<int> cookedAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CookingHistoryTableCompanion(
            id: id,
            familyId: familyId,
            recipeId: recipeId,
            recipeTitle: recipeTitle,
            servingsCooked: servingsCooked,
            cookedBy: cookedBy,
            cookedAt: cookedAt,
            notes: notes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String familyId,
            required String recipeId,
            required String recipeTitle,
            required int servingsCooked,
            required String cookedBy,
            required int cookedAt,
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CookingHistoryTableCompanion.insert(
            id: id,
            familyId: familyId,
            recipeId: recipeId,
            recipeTitle: recipeTitle,
            servingsCooked: servingsCooked,
            cookedBy: cookedBy,
            cookedAt: cookedAt,
            notes: notes,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CookingHistoryTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {recipeId = false, cookingHistoryIngredientsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (cookingHistoryIngredientsTableRefs)
                  db.cookingHistoryIngredientsTable
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (recipeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.recipeId,
                    referencedTable:
                        $$CookingHistoryTableTableReferences._recipeIdTable(db),
                    referencedColumn: $$CookingHistoryTableTableReferences
                        ._recipeIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (cookingHistoryIngredientsTableRefs)
                    await $_getPrefetchedData<
                            CookingHistoryTableData,
                            $CookingHistoryTableTable,
                            CookingHistoryIngredientsTableData>(
                        currentTable: table,
                        referencedTable: $$CookingHistoryTableTableReferences
                            ._cookingHistoryIngredientsTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CookingHistoryTableTableReferences(db, table, p0)
                                .cookingHistoryIngredientsTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.historyId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CookingHistoryTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CookingHistoryTableTable,
    CookingHistoryTableData,
    $$CookingHistoryTableTableFilterComposer,
    $$CookingHistoryTableTableOrderingComposer,
    $$CookingHistoryTableTableAnnotationComposer,
    $$CookingHistoryTableTableCreateCompanionBuilder,
    $$CookingHistoryTableTableUpdateCompanionBuilder,
    (CookingHistoryTableData, $$CookingHistoryTableTableReferences),
    CookingHistoryTableData,
    PrefetchHooks Function(
        {bool recipeId, bool cookingHistoryIngredientsTableRefs})>;
typedef $$CookingHistoryIngredientsTableTableCreateCompanionBuilder
    = CookingHistoryIngredientsTableCompanion Function({
  required String id,
  required String historyId,
  required String ingredientName,
  required double quantityUsed,
  required String unit,
  Value<String?> pantryItemId,
  Value<int> rowid,
});
typedef $$CookingHistoryIngredientsTableTableUpdateCompanionBuilder
    = CookingHistoryIngredientsTableCompanion Function({
  Value<String> id,
  Value<String> historyId,
  Value<String> ingredientName,
  Value<double> quantityUsed,
  Value<String> unit,
  Value<String?> pantryItemId,
  Value<int> rowid,
});

final class $$CookingHistoryIngredientsTableTableReferences
    extends BaseReferences<_$AppDatabase, $CookingHistoryIngredientsTableTable,
        CookingHistoryIngredientsTableData> {
  $$CookingHistoryIngredientsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $CookingHistoryTableTable _historyIdTable(_$AppDatabase db) =>
      db.cookingHistoryTable.createAlias($_aliasNameGenerator(
          db.cookingHistoryIngredientsTable.historyId,
          db.cookingHistoryTable.id));

  $$CookingHistoryTableTableProcessedTableManager get historyId {
    final $_column = $_itemColumn<String>('history_id')!;

    final manager =
        $$CookingHistoryTableTableTableManager($_db, $_db.cookingHistoryTable)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_historyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PantryItemsTableTable _pantryItemIdTable(_$AppDatabase db) =>
      db.pantryItemsTable.createAlias($_aliasNameGenerator(
          db.cookingHistoryIngredientsTable.pantryItemId,
          db.pantryItemsTable.id));

  $$PantryItemsTableTableProcessedTableManager? get pantryItemId {
    final $_column = $_itemColumn<String>('pantry_item_id');
    if ($_column == null) return null;
    final manager =
        $$PantryItemsTableTableTableManager($_db, $_db.pantryItemsTable)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pantryItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CookingHistoryIngredientsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CookingHistoryIngredientsTableTable> {
  $$CookingHistoryIngredientsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ingredientName => $composableBuilder(
      column: $table.ingredientName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantityUsed => $composableBuilder(
      column: $table.quantityUsed, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  $$CookingHistoryTableTableFilterComposer get historyId {
    final $$CookingHistoryTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.historyId,
        referencedTable: $db.cookingHistoryTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CookingHistoryTableTableFilterComposer(
              $db: $db,
              $table: $db.cookingHistoryTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PantryItemsTableTableFilterComposer get pantryItemId {
    final $$PantryItemsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pantryItemId,
        referencedTable: $db.pantryItemsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PantryItemsTableTableFilterComposer(
              $db: $db,
              $table: $db.pantryItemsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CookingHistoryIngredientsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CookingHistoryIngredientsTableTable> {
  $$CookingHistoryIngredientsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ingredientName => $composableBuilder(
      column: $table.ingredientName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantityUsed => $composableBuilder(
      column: $table.quantityUsed,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  $$CookingHistoryTableTableOrderingComposer get historyId {
    final $$CookingHistoryTableTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.historyId,
            referencedTable: $db.cookingHistoryTable,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CookingHistoryTableTableOrderingComposer(
                  $db: $db,
                  $table: $db.cookingHistoryTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$PantryItemsTableTableOrderingComposer get pantryItemId {
    final $$PantryItemsTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pantryItemId,
        referencedTable: $db.pantryItemsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PantryItemsTableTableOrderingComposer(
              $db: $db,
              $table: $db.pantryItemsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CookingHistoryIngredientsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CookingHistoryIngredientsTableTable> {
  $$CookingHistoryIngredientsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ingredientName => $composableBuilder(
      column: $table.ingredientName, builder: (column) => column);

  GeneratedColumn<double> get quantityUsed => $composableBuilder(
      column: $table.quantityUsed, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  $$CookingHistoryTableTableAnnotationComposer get historyId {
    final $$CookingHistoryTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.historyId,
            referencedTable: $db.cookingHistoryTable,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CookingHistoryTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.cookingHistoryTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$PantryItemsTableTableAnnotationComposer get pantryItemId {
    final $$PantryItemsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pantryItemId,
        referencedTable: $db.pantryItemsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PantryItemsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.pantryItemsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CookingHistoryIngredientsTableTableTableManager
    extends RootTableManager<
        _$AppDatabase,
        $CookingHistoryIngredientsTableTable,
        CookingHistoryIngredientsTableData,
        $$CookingHistoryIngredientsTableTableFilterComposer,
        $$CookingHistoryIngredientsTableTableOrderingComposer,
        $$CookingHistoryIngredientsTableTableAnnotationComposer,
        $$CookingHistoryIngredientsTableTableCreateCompanionBuilder,
        $$CookingHistoryIngredientsTableTableUpdateCompanionBuilder,
        (
          CookingHistoryIngredientsTableData,
          $$CookingHistoryIngredientsTableTableReferences
        ),
        CookingHistoryIngredientsTableData,
        PrefetchHooks Function({bool historyId, bool pantryItemId})> {
  $$CookingHistoryIngredientsTableTableTableManager(
      _$AppDatabase db, $CookingHistoryIngredientsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CookingHistoryIngredientsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$CookingHistoryIngredientsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CookingHistoryIngredientsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> historyId = const Value.absent(),
            Value<String> ingredientName = const Value.absent(),
            Value<double> quantityUsed = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<String?> pantryItemId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CookingHistoryIngredientsTableCompanion(
            id: id,
            historyId: historyId,
            ingredientName: ingredientName,
            quantityUsed: quantityUsed,
            unit: unit,
            pantryItemId: pantryItemId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String historyId,
            required String ingredientName,
            required double quantityUsed,
            required String unit,
            Value<String?> pantryItemId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CookingHistoryIngredientsTableCompanion.insert(
            id: id,
            historyId: historyId,
            ingredientName: ingredientName,
            quantityUsed: quantityUsed,
            unit: unit,
            pantryItemId: pantryItemId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CookingHistoryIngredientsTableTableReferences(
                        db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({historyId = false, pantryItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (historyId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.historyId,
                    referencedTable:
                        $$CookingHistoryIngredientsTableTableReferences
                            ._historyIdTable(db),
                    referencedColumn:
                        $$CookingHistoryIngredientsTableTableReferences
                            ._historyIdTable(db)
                            .id,
                  ) as T;
                }
                if (pantryItemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.pantryItemId,
                    referencedTable:
                        $$CookingHistoryIngredientsTableTableReferences
                            ._pantryItemIdTable(db),
                    referencedColumn:
                        $$CookingHistoryIngredientsTableTableReferences
                            ._pantryItemIdTable(db)
                            .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$CookingHistoryIngredientsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $CookingHistoryIngredientsTableTable,
        CookingHistoryIngredientsTableData,
        $$CookingHistoryIngredientsTableTableFilterComposer,
        $$CookingHistoryIngredientsTableTableOrderingComposer,
        $$CookingHistoryIngredientsTableTableAnnotationComposer,
        $$CookingHistoryIngredientsTableTableCreateCompanionBuilder,
        $$CookingHistoryIngredientsTableTableUpdateCompanionBuilder,
        (
          CookingHistoryIngredientsTableData,
          $$CookingHistoryIngredientsTableTableReferences
        ),
        CookingHistoryIngredientsTableData,
        PrefetchHooks Function({bool historyId, bool pantryItemId})>;
typedef $$SyncQueueTableTableCreateCompanionBuilder = SyncQueueTableCompanion
    Function({
  required String id,
  required String entityType,
  required String entityId,
  required String operation,
  required String payload,
  Value<int> retryCount,
  required int createdAt,
  Value<int> rowid,
});
typedef $$SyncQueueTableTableUpdateCompanionBuilder = SyncQueueTableCompanion
    Function({
  Value<String> id,
  Value<String> entityType,
  Value<String> entityId,
  Value<String> operation,
  Value<String> payload,
  Value<int> retryCount,
  Value<int> createdAt,
  Value<int> rowid,
});

class $$SyncQueueTableTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SyncQueueTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncQueueTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncQueueTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTableTable,
    SyncQueueTableData,
    $$SyncQueueTableTableFilterComposer,
    $$SyncQueueTableTableOrderingComposer,
    $$SyncQueueTableTableAnnotationComposer,
    $$SyncQueueTableTableCreateCompanionBuilder,
    $$SyncQueueTableTableUpdateCompanionBuilder,
    (
      SyncQueueTableData,
      BaseReferences<_$AppDatabase, $SyncQueueTableTable, SyncQueueTableData>
    ),
    SyncQueueTableData,
    PrefetchHooks Function()> {
  $$SyncQueueTableTableTableManager(
      _$AppDatabase db, $SyncQueueTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> operation = const Value.absent(),
            Value<String> payload = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueTableCompanion(
            id: id,
            entityType: entityType,
            entityId: entityId,
            operation: operation,
            payload: payload,
            retryCount: retryCount,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String entityType,
            required String entityId,
            required String operation,
            required String payload,
            Value<int> retryCount = const Value.absent(),
            required int createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueTableCompanion.insert(
            id: id,
            entityType: entityType,
            entityId: entityId,
            operation: operation,
            payload: payload,
            retryCount: retryCount,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncQueueTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueTableTable,
    SyncQueueTableData,
    $$SyncQueueTableTableFilterComposer,
    $$SyncQueueTableTableOrderingComposer,
    $$SyncQueueTableTableAnnotationComposer,
    $$SyncQueueTableTableCreateCompanionBuilder,
    $$SyncQueueTableTableUpdateCompanionBuilder,
    (
      SyncQueueTableData,
      BaseReferences<_$AppDatabase, $SyncQueueTableTable, SyncQueueTableData>
    ),
    SyncQueueTableData,
    PrefetchHooks Function()>;
typedef $$AppSettingsTableTableCreateCompanionBuilder
    = AppSettingsTableCompanion Function({
  required String key,
  required String value,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$AppSettingsTableTableUpdateCompanionBuilder
    = AppSettingsTableCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$AppSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$AppSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$AppSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTableTable,
    AppSettingsTableData,
    $$AppSettingsTableTableFilterComposer,
    $$AppSettingsTableTableOrderingComposer,
    $$AppSettingsTableTableAnnotationComposer,
    $$AppSettingsTableTableCreateCompanionBuilder,
    $$AppSettingsTableTableUpdateCompanionBuilder,
    (
      AppSettingsTableData,
      BaseReferences<_$AppDatabase, $AppSettingsTableTable,
          AppSettingsTableData>
    ),
    AppSettingsTableData,
    PrefetchHooks Function()> {
  $$AppSettingsTableTableTableManager(
      _$AppDatabase db, $AppSettingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsTableCompanion(
            key: key,
            value: value,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsTableCompanion.insert(
            key: key,
            value: value,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingsTableTable,
    AppSettingsTableData,
    $$AppSettingsTableTableFilterComposer,
    $$AppSettingsTableTableOrderingComposer,
    $$AppSettingsTableTableAnnotationComposer,
    $$AppSettingsTableTableCreateCompanionBuilder,
    $$AppSettingsTableTableUpdateCompanionBuilder,
    (
      AppSettingsTableData,
      BaseReferences<_$AppDatabase, $AppSettingsTableTable,
          AppSettingsTableData>
    ),
    AppSettingsTableData,
    PrefetchHooks Function()>;
typedef $$CategoriesTableTableCreateCompanionBuilder = CategoriesTableCompanion
    Function({
  required String id,
  required String familyId,
  required String type,
  required String name,
  required String value,
  Value<bool> isSystem,
  Value<int> sortOrder,
  required int createdAt,
  Value<int> rowid,
});
typedef $$CategoriesTableTableUpdateCompanionBuilder = CategoriesTableCompanion
    Function({
  Value<String> id,
  Value<String> familyId,
  Value<String> type,
  Value<String> name,
  Value<String> value,
  Value<bool> isSystem,
  Value<int> sortOrder,
  Value<int> createdAt,
  Value<int> rowid,
});

class $$CategoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get familyId => $composableBuilder(
      column: $table.familyId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSystem => $composableBuilder(
      column: $table.isSystem, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$CategoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get familyId => $composableBuilder(
      column: $table.familyId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSystem => $composableBuilder(
      column: $table.isSystem, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$CategoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get familyId =>
      $composableBuilder(column: $table.familyId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CategoriesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTableTable,
    CategoriesTableData,
    $$CategoriesTableTableFilterComposer,
    $$CategoriesTableTableOrderingComposer,
    $$CategoriesTableTableAnnotationComposer,
    $$CategoriesTableTableCreateCompanionBuilder,
    $$CategoriesTableTableUpdateCompanionBuilder,
    (
      CategoriesTableData,
      BaseReferences<_$AppDatabase, $CategoriesTableTable, CategoriesTableData>
    ),
    CategoriesTableData,
    PrefetchHooks Function()> {
  $$CategoriesTableTableTableManager(
      _$AppDatabase db, $CategoriesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> familyId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<bool> isSystem = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesTableCompanion(
            id: id,
            familyId: familyId,
            type: type,
            name: name,
            value: value,
            isSystem: isSystem,
            sortOrder: sortOrder,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String familyId,
            required String type,
            required String name,
            required String value,
            Value<bool> isSystem = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            required int createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesTableCompanion.insert(
            id: id,
            familyId: familyId,
            type: type,
            name: name,
            value: value,
            isSystem: isSystem,
            sortOrder: sortOrder,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CategoriesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTableTable,
    CategoriesTableData,
    $$CategoriesTableTableFilterComposer,
    $$CategoriesTableTableOrderingComposer,
    $$CategoriesTableTableAnnotationComposer,
    $$CategoriesTableTableCreateCompanionBuilder,
    $$CategoriesTableTableUpdateCompanionBuilder,
    (
      CategoriesTableData,
      BaseReferences<_$AppDatabase, $CategoriesTableTable, CategoriesTableData>
    ),
    CategoriesTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RecipesTableTableTableManager get recipesTable =>
      $$RecipesTableTableTableManager(_db, _db.recipesTable);
  $$IngredientsTableTableTableManager get ingredientsTable =>
      $$IngredientsTableTableTableManager(_db, _db.ingredientsTable);
  $$PantryItemsTableTableTableManager get pantryItemsTable =>
      $$PantryItemsTableTableTableManager(_db, _db.pantryItemsTable);
  $$MealPlansTableTableTableManager get mealPlansTable =>
      $$MealPlansTableTableTableManager(_db, _db.mealPlansTable);
  $$MealPlanRecipesTableTableTableManager get mealPlanRecipesTable =>
      $$MealPlanRecipesTableTableTableManager(_db, _db.mealPlanRecipesTable);
  $$ShoppingListsTableTableTableManager get shoppingListsTable =>
      $$ShoppingListsTableTableTableManager(_db, _db.shoppingListsTable);
  $$ShoppingItemsTableTableTableManager get shoppingItemsTable =>
      $$ShoppingItemsTableTableTableManager(_db, _db.shoppingItemsTable);
  $$CookingHistoryTableTableTableManager get cookingHistoryTable =>
      $$CookingHistoryTableTableTableManager(_db, _db.cookingHistoryTable);
  $$CookingHistoryIngredientsTableTableTableManager
      get cookingHistoryIngredientsTable =>
          $$CookingHistoryIngredientsTableTableTableManager(
              _db, _db.cookingHistoryIngredientsTable);
  $$SyncQueueTableTableTableManager get syncQueueTable =>
      $$SyncQueueTableTableTableManager(_db, _db.syncQueueTable);
  $$AppSettingsTableTableTableManager get appSettingsTable =>
      $$AppSettingsTableTableTableManager(_db, _db.appSettingsTable);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(_db, _db.categoriesTable);
}
