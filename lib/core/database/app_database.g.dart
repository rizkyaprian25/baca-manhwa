// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MangasTable extends Mangas with TableInfo<$MangasTable, Manga> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MangasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _altTitlesMeta = const VerificationMeta(
    'altTitles',
  );
  @override
  late final GeneratedColumn<String> altTitles = GeneratedColumn<String>(
    'alt_titles',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentRatingMeta = const VerificationMeta(
    'contentRating',
  );
  @override
  late final GeneratedColumn<String> contentRating = GeneratedColumn<String>(
    'content_rating',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverUrlMeta = const VerificationMeta(
    'coverUrl',
  );
  @override
  late final GeneratedColumn<String> coverUrl = GeneratedColumn<String>(
    'cover_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _artistMeta = const VerificationMeta('artist');
  @override
  late final GeneratedColumn<String> artist = GeneratedColumn<String>(
    'artist',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastFetchedMeta = const VerificationMeta(
    'lastFetched',
  );
  @override
  late final GeneratedColumn<DateTime> lastFetched = GeneratedColumn<DateTime>(
    'last_fetched',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    altTitles,
    description,
    status,
    contentRating,
    year,
    coverUrl,
    tags,
    author,
    artist,
    lastFetched,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mangas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Manga> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('alt_titles')) {
      context.handle(
        _altTitlesMeta,
        altTitles.isAcceptableOrUnknown(data['alt_titles']!, _altTitlesMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('content_rating')) {
      context.handle(
        _contentRatingMeta,
        contentRating.isAcceptableOrUnknown(
          data['content_rating']!,
          _contentRatingMeta,
        ),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('cover_url')) {
      context.handle(
        _coverUrlMeta,
        coverUrl.isAcceptableOrUnknown(data['cover_url']!, _coverUrlMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    }
    if (data.containsKey('artist')) {
      context.handle(
        _artistMeta,
        artist.isAcceptableOrUnknown(data['artist']!, _artistMeta),
      );
    }
    if (data.containsKey('last_fetched')) {
      context.handle(
        _lastFetchedMeta,
        lastFetched.isAcceptableOrUnknown(
          data['last_fetched']!,
          _lastFetchedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Manga map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Manga(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      altTitles: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alt_titles'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      ),
      contentRating: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_rating'],
      ),
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      coverUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_url'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      ),
      artist: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artist'],
      ),
      lastFetched: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_fetched'],
      ),
    );
  }

  @override
  $MangasTable createAlias(String alias) {
    return $MangasTable(attachedDatabase, alias);
  }
}

class Manga extends DataClass implements Insertable<Manga> {
  final String id;
  final String title;
  final String? altTitles;
  final String? description;
  final String? status;
  final String? contentRating;
  final int? year;
  final String? coverUrl;
  final String? tags;
  final String? author;
  final String? artist;
  final DateTime? lastFetched;
  const Manga({
    required this.id,
    required this.title,
    this.altTitles,
    this.description,
    this.status,
    this.contentRating,
    this.year,
    this.coverUrl,
    this.tags,
    this.author,
    this.artist,
    this.lastFetched,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || altTitles != null) {
      map['alt_titles'] = Variable<String>(altTitles);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || contentRating != null) {
      map['content_rating'] = Variable<String>(contentRating);
    }
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    if (!nullToAbsent || coverUrl != null) {
      map['cover_url'] = Variable<String>(coverUrl);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    if (!nullToAbsent || artist != null) {
      map['artist'] = Variable<String>(artist);
    }
    if (!nullToAbsent || lastFetched != null) {
      map['last_fetched'] = Variable<DateTime>(lastFetched);
    }
    return map;
  }

  MangasCompanion toCompanion(bool nullToAbsent) {
    return MangasCompanion(
      id: Value(id),
      title: Value(title),
      altTitles: altTitles == null && nullToAbsent
          ? const Value.absent()
          : Value(altTitles),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      status: status == null && nullToAbsent
          ? const Value.absent()
          : Value(status),
      contentRating: contentRating == null && nullToAbsent
          ? const Value.absent()
          : Value(contentRating),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      coverUrl: coverUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(coverUrl),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      author: author == null && nullToAbsent
          ? const Value.absent()
          : Value(author),
      artist: artist == null && nullToAbsent
          ? const Value.absent()
          : Value(artist),
      lastFetched: lastFetched == null && nullToAbsent
          ? const Value.absent()
          : Value(lastFetched),
    );
  }

  factory Manga.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Manga(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      altTitles: serializer.fromJson<String?>(json['altTitles']),
      description: serializer.fromJson<String?>(json['description']),
      status: serializer.fromJson<String?>(json['status']),
      contentRating: serializer.fromJson<String?>(json['contentRating']),
      year: serializer.fromJson<int?>(json['year']),
      coverUrl: serializer.fromJson<String?>(json['coverUrl']),
      tags: serializer.fromJson<String?>(json['tags']),
      author: serializer.fromJson<String?>(json['author']),
      artist: serializer.fromJson<String?>(json['artist']),
      lastFetched: serializer.fromJson<DateTime?>(json['lastFetched']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'altTitles': serializer.toJson<String?>(altTitles),
      'description': serializer.toJson<String?>(description),
      'status': serializer.toJson<String?>(status),
      'contentRating': serializer.toJson<String?>(contentRating),
      'year': serializer.toJson<int?>(year),
      'coverUrl': serializer.toJson<String?>(coverUrl),
      'tags': serializer.toJson<String?>(tags),
      'author': serializer.toJson<String?>(author),
      'artist': serializer.toJson<String?>(artist),
      'lastFetched': serializer.toJson<DateTime?>(lastFetched),
    };
  }

  Manga copyWith({
    String? id,
    String? title,
    Value<String?> altTitles = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<String?> status = const Value.absent(),
    Value<String?> contentRating = const Value.absent(),
    Value<int?> year = const Value.absent(),
    Value<String?> coverUrl = const Value.absent(),
    Value<String?> tags = const Value.absent(),
    Value<String?> author = const Value.absent(),
    Value<String?> artist = const Value.absent(),
    Value<DateTime?> lastFetched = const Value.absent(),
  }) => Manga(
    id: id ?? this.id,
    title: title ?? this.title,
    altTitles: altTitles.present ? altTitles.value : this.altTitles,
    description: description.present ? description.value : this.description,
    status: status.present ? status.value : this.status,
    contentRating: contentRating.present
        ? contentRating.value
        : this.contentRating,
    year: year.present ? year.value : this.year,
    coverUrl: coverUrl.present ? coverUrl.value : this.coverUrl,
    tags: tags.present ? tags.value : this.tags,
    author: author.present ? author.value : this.author,
    artist: artist.present ? artist.value : this.artist,
    lastFetched: lastFetched.present ? lastFetched.value : this.lastFetched,
  );
  Manga copyWithCompanion(MangasCompanion data) {
    return Manga(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      altTitles: data.altTitles.present ? data.altTitles.value : this.altTitles,
      description: data.description.present
          ? data.description.value
          : this.description,
      status: data.status.present ? data.status.value : this.status,
      contentRating: data.contentRating.present
          ? data.contentRating.value
          : this.contentRating,
      year: data.year.present ? data.year.value : this.year,
      coverUrl: data.coverUrl.present ? data.coverUrl.value : this.coverUrl,
      tags: data.tags.present ? data.tags.value : this.tags,
      author: data.author.present ? data.author.value : this.author,
      artist: data.artist.present ? data.artist.value : this.artist,
      lastFetched: data.lastFetched.present
          ? data.lastFetched.value
          : this.lastFetched,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Manga(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('altTitles: $altTitles, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('contentRating: $contentRating, ')
          ..write('year: $year, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('tags: $tags, ')
          ..write('author: $author, ')
          ..write('artist: $artist, ')
          ..write('lastFetched: $lastFetched')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    altTitles,
    description,
    status,
    contentRating,
    year,
    coverUrl,
    tags,
    author,
    artist,
    lastFetched,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Manga &&
          other.id == this.id &&
          other.title == this.title &&
          other.altTitles == this.altTitles &&
          other.description == this.description &&
          other.status == this.status &&
          other.contentRating == this.contentRating &&
          other.year == this.year &&
          other.coverUrl == this.coverUrl &&
          other.tags == this.tags &&
          other.author == this.author &&
          other.artist == this.artist &&
          other.lastFetched == this.lastFetched);
}

class MangasCompanion extends UpdateCompanion<Manga> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> altTitles;
  final Value<String?> description;
  final Value<String?> status;
  final Value<String?> contentRating;
  final Value<int?> year;
  final Value<String?> coverUrl;
  final Value<String?> tags;
  final Value<String?> author;
  final Value<String?> artist;
  final Value<DateTime?> lastFetched;
  final Value<int> rowid;
  const MangasCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.altTitles = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.contentRating = const Value.absent(),
    this.year = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.tags = const Value.absent(),
    this.author = const Value.absent(),
    this.artist = const Value.absent(),
    this.lastFetched = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MangasCompanion.insert({
    required String id,
    required String title,
    this.altTitles = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.contentRating = const Value.absent(),
    this.year = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.tags = const Value.absent(),
    this.author = const Value.absent(),
    this.artist = const Value.absent(),
    this.lastFetched = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title);
  static Insertable<Manga> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? altTitles,
    Expression<String>? description,
    Expression<String>? status,
    Expression<String>? contentRating,
    Expression<int>? year,
    Expression<String>? coverUrl,
    Expression<String>? tags,
    Expression<String>? author,
    Expression<String>? artist,
    Expression<DateTime>? lastFetched,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (altTitles != null) 'alt_titles': altTitles,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (contentRating != null) 'content_rating': contentRating,
      if (year != null) 'year': year,
      if (coverUrl != null) 'cover_url': coverUrl,
      if (tags != null) 'tags': tags,
      if (author != null) 'author': author,
      if (artist != null) 'artist': artist,
      if (lastFetched != null) 'last_fetched': lastFetched,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MangasCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? altTitles,
    Value<String?>? description,
    Value<String?>? status,
    Value<String?>? contentRating,
    Value<int?>? year,
    Value<String?>? coverUrl,
    Value<String?>? tags,
    Value<String?>? author,
    Value<String?>? artist,
    Value<DateTime?>? lastFetched,
    Value<int>? rowid,
  }) {
    return MangasCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      altTitles: altTitles ?? this.altTitles,
      description: description ?? this.description,
      status: status ?? this.status,
      contentRating: contentRating ?? this.contentRating,
      year: year ?? this.year,
      coverUrl: coverUrl ?? this.coverUrl,
      tags: tags ?? this.tags,
      author: author ?? this.author,
      artist: artist ?? this.artist,
      lastFetched: lastFetched ?? this.lastFetched,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (altTitles.present) {
      map['alt_titles'] = Variable<String>(altTitles.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (contentRating.present) {
      map['content_rating'] = Variable<String>(contentRating.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (coverUrl.present) {
      map['cover_url'] = Variable<String>(coverUrl.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (artist.present) {
      map['artist'] = Variable<String>(artist.value);
    }
    if (lastFetched.present) {
      map['last_fetched'] = Variable<DateTime>(lastFetched.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MangasCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('altTitles: $altTitles, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('contentRating: $contentRating, ')
          ..write('year: $year, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('tags: $tags, ')
          ..write('author: $author, ')
          ..write('artist: $artist, ')
          ..write('lastFetched: $lastFetched, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChaptersTable extends Chapters with TableInfo<$ChaptersTable, Chapter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChaptersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mangaIdMeta = const VerificationMeta(
    'mangaId',
  );
  @override
  late final GeneratedColumn<String> mangaId = GeneratedColumn<String>(
    'manga_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES mangas (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chapterNoMeta = const VerificationMeta(
    'chapterNo',
  );
  @override
  late final GeneratedColumn<String> chapterNo = GeneratedColumn<String>(
    'chapter_no',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _volumeMeta = const VerificationMeta('volume');
  @override
  late final GeneratedColumn<String> volume = GeneratedColumn<String>(
    'volume',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('en'),
  );
  static const VerificationMeta _pagesMeta = const VerificationMeta('pages');
  @override
  late final GeneratedColumn<int> pages = GeneratedColumn<int>(
    'pages',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _readableAtMeta = const VerificationMeta(
    'readableAt',
  );
  @override
  late final GeneratedColumn<DateTime> readableAt = GeneratedColumn<DateTime>(
    'readable_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
    'is_read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastPageMeta = const VerificationMeta(
    'lastPage',
  );
  @override
  late final GeneratedColumn<int> lastPage = GeneratedColumn<int>(
    'last_page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mangaId,
    title,
    chapterNo,
    volume,
    language,
    pages,
    readableAt,
    isRead,
    lastPage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chapters';
  @override
  VerificationContext validateIntegrity(
    Insertable<Chapter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('manga_id')) {
      context.handle(
        _mangaIdMeta,
        mangaId.isAcceptableOrUnknown(data['manga_id']!, _mangaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mangaIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('chapter_no')) {
      context.handle(
        _chapterNoMeta,
        chapterNo.isAcceptableOrUnknown(data['chapter_no']!, _chapterNoMeta),
      );
    }
    if (data.containsKey('volume')) {
      context.handle(
        _volumeMeta,
        volume.isAcceptableOrUnknown(data['volume']!, _volumeMeta),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('pages')) {
      context.handle(
        _pagesMeta,
        pages.isAcceptableOrUnknown(data['pages']!, _pagesMeta),
      );
    }
    if (data.containsKey('readable_at')) {
      context.handle(
        _readableAtMeta,
        readableAt.isAcceptableOrUnknown(data['readable_at']!, _readableAtMeta),
      );
    }
    if (data.containsKey('is_read')) {
      context.handle(
        _isReadMeta,
        isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta),
      );
    }
    if (data.containsKey('last_page')) {
      context.handle(
        _lastPageMeta,
        lastPage.isAcceptableOrUnknown(data['last_page']!, _lastPageMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Chapter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chapter(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      mangaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manga_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      chapterNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_no'],
      ),
      volume: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}volume'],
      ),
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      pages: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pages'],
      )!,
      readableAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}readable_at'],
      ),
      isRead: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_read'],
      )!,
      lastPage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_page'],
      )!,
    );
  }

  @override
  $ChaptersTable createAlias(String alias) {
    return $ChaptersTable(attachedDatabase, alias);
  }
}

class Chapter extends DataClass implements Insertable<Chapter> {
  final String id;
  final String mangaId;
  final String? title;
  final String? chapterNo;
  final String? volume;
  final String language;
  final int pages;
  final DateTime? readableAt;
  final bool isRead;
  final int lastPage;
  const Chapter({
    required this.id,
    required this.mangaId,
    this.title,
    this.chapterNo,
    this.volume,
    required this.language,
    required this.pages,
    this.readableAt,
    required this.isRead,
    required this.lastPage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['manga_id'] = Variable<String>(mangaId);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || chapterNo != null) {
      map['chapter_no'] = Variable<String>(chapterNo);
    }
    if (!nullToAbsent || volume != null) {
      map['volume'] = Variable<String>(volume);
    }
    map['language'] = Variable<String>(language);
    map['pages'] = Variable<int>(pages);
    if (!nullToAbsent || readableAt != null) {
      map['readable_at'] = Variable<DateTime>(readableAt);
    }
    map['is_read'] = Variable<bool>(isRead);
    map['last_page'] = Variable<int>(lastPage);
    return map;
  }

  ChaptersCompanion toCompanion(bool nullToAbsent) {
    return ChaptersCompanion(
      id: Value(id),
      mangaId: Value(mangaId),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      chapterNo: chapterNo == null && nullToAbsent
          ? const Value.absent()
          : Value(chapterNo),
      volume: volume == null && nullToAbsent
          ? const Value.absent()
          : Value(volume),
      language: Value(language),
      pages: Value(pages),
      readableAt: readableAt == null && nullToAbsent
          ? const Value.absent()
          : Value(readableAt),
      isRead: Value(isRead),
      lastPage: Value(lastPage),
    );
  }

  factory Chapter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chapter(
      id: serializer.fromJson<String>(json['id']),
      mangaId: serializer.fromJson<String>(json['mangaId']),
      title: serializer.fromJson<String?>(json['title']),
      chapterNo: serializer.fromJson<String?>(json['chapterNo']),
      volume: serializer.fromJson<String?>(json['volume']),
      language: serializer.fromJson<String>(json['language']),
      pages: serializer.fromJson<int>(json['pages']),
      readableAt: serializer.fromJson<DateTime?>(json['readableAt']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      lastPage: serializer.fromJson<int>(json['lastPage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'mangaId': serializer.toJson<String>(mangaId),
      'title': serializer.toJson<String?>(title),
      'chapterNo': serializer.toJson<String?>(chapterNo),
      'volume': serializer.toJson<String?>(volume),
      'language': serializer.toJson<String>(language),
      'pages': serializer.toJson<int>(pages),
      'readableAt': serializer.toJson<DateTime?>(readableAt),
      'isRead': serializer.toJson<bool>(isRead),
      'lastPage': serializer.toJson<int>(lastPage),
    };
  }

  Chapter copyWith({
    String? id,
    String? mangaId,
    Value<String?> title = const Value.absent(),
    Value<String?> chapterNo = const Value.absent(),
    Value<String?> volume = const Value.absent(),
    String? language,
    int? pages,
    Value<DateTime?> readableAt = const Value.absent(),
    bool? isRead,
    int? lastPage,
  }) => Chapter(
    id: id ?? this.id,
    mangaId: mangaId ?? this.mangaId,
    title: title.present ? title.value : this.title,
    chapterNo: chapterNo.present ? chapterNo.value : this.chapterNo,
    volume: volume.present ? volume.value : this.volume,
    language: language ?? this.language,
    pages: pages ?? this.pages,
    readableAt: readableAt.present ? readableAt.value : this.readableAt,
    isRead: isRead ?? this.isRead,
    lastPage: lastPage ?? this.lastPage,
  );
  Chapter copyWithCompanion(ChaptersCompanion data) {
    return Chapter(
      id: data.id.present ? data.id.value : this.id,
      mangaId: data.mangaId.present ? data.mangaId.value : this.mangaId,
      title: data.title.present ? data.title.value : this.title,
      chapterNo: data.chapterNo.present ? data.chapterNo.value : this.chapterNo,
      volume: data.volume.present ? data.volume.value : this.volume,
      language: data.language.present ? data.language.value : this.language,
      pages: data.pages.present ? data.pages.value : this.pages,
      readableAt: data.readableAt.present
          ? data.readableAt.value
          : this.readableAt,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      lastPage: data.lastPage.present ? data.lastPage.value : this.lastPage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Chapter(')
          ..write('id: $id, ')
          ..write('mangaId: $mangaId, ')
          ..write('title: $title, ')
          ..write('chapterNo: $chapterNo, ')
          ..write('volume: $volume, ')
          ..write('language: $language, ')
          ..write('pages: $pages, ')
          ..write('readableAt: $readableAt, ')
          ..write('isRead: $isRead, ')
          ..write('lastPage: $lastPage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    mangaId,
    title,
    chapterNo,
    volume,
    language,
    pages,
    readableAt,
    isRead,
    lastPage,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chapter &&
          other.id == this.id &&
          other.mangaId == this.mangaId &&
          other.title == this.title &&
          other.chapterNo == this.chapterNo &&
          other.volume == this.volume &&
          other.language == this.language &&
          other.pages == this.pages &&
          other.readableAt == this.readableAt &&
          other.isRead == this.isRead &&
          other.lastPage == this.lastPage);
}

class ChaptersCompanion extends UpdateCompanion<Chapter> {
  final Value<String> id;
  final Value<String> mangaId;
  final Value<String?> title;
  final Value<String?> chapterNo;
  final Value<String?> volume;
  final Value<String> language;
  final Value<int> pages;
  final Value<DateTime?> readableAt;
  final Value<bool> isRead;
  final Value<int> lastPage;
  final Value<int> rowid;
  const ChaptersCompanion({
    this.id = const Value.absent(),
    this.mangaId = const Value.absent(),
    this.title = const Value.absent(),
    this.chapterNo = const Value.absent(),
    this.volume = const Value.absent(),
    this.language = const Value.absent(),
    this.pages = const Value.absent(),
    this.readableAt = const Value.absent(),
    this.isRead = const Value.absent(),
    this.lastPage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChaptersCompanion.insert({
    required String id,
    required String mangaId,
    this.title = const Value.absent(),
    this.chapterNo = const Value.absent(),
    this.volume = const Value.absent(),
    this.language = const Value.absent(),
    this.pages = const Value.absent(),
    this.readableAt = const Value.absent(),
    this.isRead = const Value.absent(),
    this.lastPage = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       mangaId = Value(mangaId);
  static Insertable<Chapter> custom({
    Expression<String>? id,
    Expression<String>? mangaId,
    Expression<String>? title,
    Expression<String>? chapterNo,
    Expression<String>? volume,
    Expression<String>? language,
    Expression<int>? pages,
    Expression<DateTime>? readableAt,
    Expression<bool>? isRead,
    Expression<int>? lastPage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mangaId != null) 'manga_id': mangaId,
      if (title != null) 'title': title,
      if (chapterNo != null) 'chapter_no': chapterNo,
      if (volume != null) 'volume': volume,
      if (language != null) 'language': language,
      if (pages != null) 'pages': pages,
      if (readableAt != null) 'readable_at': readableAt,
      if (isRead != null) 'is_read': isRead,
      if (lastPage != null) 'last_page': lastPage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChaptersCompanion copyWith({
    Value<String>? id,
    Value<String>? mangaId,
    Value<String?>? title,
    Value<String?>? chapterNo,
    Value<String?>? volume,
    Value<String>? language,
    Value<int>? pages,
    Value<DateTime?>? readableAt,
    Value<bool>? isRead,
    Value<int>? lastPage,
    Value<int>? rowid,
  }) {
    return ChaptersCompanion(
      id: id ?? this.id,
      mangaId: mangaId ?? this.mangaId,
      title: title ?? this.title,
      chapterNo: chapterNo ?? this.chapterNo,
      volume: volume ?? this.volume,
      language: language ?? this.language,
      pages: pages ?? this.pages,
      readableAt: readableAt ?? this.readableAt,
      isRead: isRead ?? this.isRead,
      lastPage: lastPage ?? this.lastPage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (mangaId.present) {
      map['manga_id'] = Variable<String>(mangaId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (chapterNo.present) {
      map['chapter_no'] = Variable<String>(chapterNo.value);
    }
    if (volume.present) {
      map['volume'] = Variable<String>(volume.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (pages.present) {
      map['pages'] = Variable<int>(pages.value);
    }
    if (readableAt.present) {
      map['readable_at'] = Variable<DateTime>(readableAt.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (lastPage.present) {
      map['last_page'] = Variable<int>(lastPage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChaptersCompanion(')
          ..write('id: $id, ')
          ..write('mangaId: $mangaId, ')
          ..write('title: $title, ')
          ..write('chapterNo: $chapterNo, ')
          ..write('volume: $volume, ')
          ..write('language: $language, ')
          ..write('pages: $pages, ')
          ..write('readableAt: $readableAt, ')
          ..write('isRead: $isRead, ')
          ..write('lastPage: $lastPage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LibraryEntriesTable extends LibraryEntries
    with TableInfo<$LibraryEntriesTable, LibraryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LibraryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _mangaIdMeta = const VerificationMeta(
    'mangaId',
  );
  @override
  late final GeneratedColumn<String> mangaId = GeneratedColumn<String>(
    'manga_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES mangas (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _listTypeMeta = const VerificationMeta(
    'listType',
  );
  @override
  late final GeneratedColumn<String> listType = GeneratedColumn<String>(
    'list_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _lastOpenedMeta = const VerificationMeta(
    'lastOpened',
  );
  @override
  late final GeneratedColumn<DateTime> lastOpened = GeneratedColumn<DateTime>(
    'last_opened',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mangaId,
    listType,
    addedAt,
    lastOpened,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'library_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<LibraryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('manga_id')) {
      context.handle(
        _mangaIdMeta,
        mangaId.isAcceptableOrUnknown(data['manga_id']!, _mangaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mangaIdMeta);
    }
    if (data.containsKey('list_type')) {
      context.handle(
        _listTypeMeta,
        listType.isAcceptableOrUnknown(data['list_type']!, _listTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_listTypeMeta);
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    }
    if (data.containsKey('last_opened')) {
      context.handle(
        _lastOpenedMeta,
        lastOpened.isAcceptableOrUnknown(data['last_opened']!, _lastOpenedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {mangaId, listType},
  ];
  @override
  LibraryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LibraryEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      mangaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manga_id'],
      )!,
      listType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}list_type'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
      lastOpened: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_opened'],
      ),
    );
  }

  @override
  $LibraryEntriesTable createAlias(String alias) {
    return $LibraryEntriesTable(attachedDatabase, alias);
  }
}

class LibraryEntry extends DataClass implements Insertable<LibraryEntry> {
  final int id;
  final String mangaId;
  final String listType;
  final DateTime addedAt;
  final DateTime? lastOpened;
  const LibraryEntry({
    required this.id,
    required this.mangaId,
    required this.listType,
    required this.addedAt,
    this.lastOpened,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['manga_id'] = Variable<String>(mangaId);
    map['list_type'] = Variable<String>(listType);
    map['added_at'] = Variable<DateTime>(addedAt);
    if (!nullToAbsent || lastOpened != null) {
      map['last_opened'] = Variable<DateTime>(lastOpened);
    }
    return map;
  }

  LibraryEntriesCompanion toCompanion(bool nullToAbsent) {
    return LibraryEntriesCompanion(
      id: Value(id),
      mangaId: Value(mangaId),
      listType: Value(listType),
      addedAt: Value(addedAt),
      lastOpened: lastOpened == null && nullToAbsent
          ? const Value.absent()
          : Value(lastOpened),
    );
  }

  factory LibraryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LibraryEntry(
      id: serializer.fromJson<int>(json['id']),
      mangaId: serializer.fromJson<String>(json['mangaId']),
      listType: serializer.fromJson<String>(json['listType']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
      lastOpened: serializer.fromJson<DateTime?>(json['lastOpened']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mangaId': serializer.toJson<String>(mangaId),
      'listType': serializer.toJson<String>(listType),
      'addedAt': serializer.toJson<DateTime>(addedAt),
      'lastOpened': serializer.toJson<DateTime?>(lastOpened),
    };
  }

  LibraryEntry copyWith({
    int? id,
    String? mangaId,
    String? listType,
    DateTime? addedAt,
    Value<DateTime?> lastOpened = const Value.absent(),
  }) => LibraryEntry(
    id: id ?? this.id,
    mangaId: mangaId ?? this.mangaId,
    listType: listType ?? this.listType,
    addedAt: addedAt ?? this.addedAt,
    lastOpened: lastOpened.present ? lastOpened.value : this.lastOpened,
  );
  LibraryEntry copyWithCompanion(LibraryEntriesCompanion data) {
    return LibraryEntry(
      id: data.id.present ? data.id.value : this.id,
      mangaId: data.mangaId.present ? data.mangaId.value : this.mangaId,
      listType: data.listType.present ? data.listType.value : this.listType,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      lastOpened: data.lastOpened.present
          ? data.lastOpened.value
          : this.lastOpened,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LibraryEntry(')
          ..write('id: $id, ')
          ..write('mangaId: $mangaId, ')
          ..write('listType: $listType, ')
          ..write('addedAt: $addedAt, ')
          ..write('lastOpened: $lastOpened')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, mangaId, listType, addedAt, lastOpened);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LibraryEntry &&
          other.id == this.id &&
          other.mangaId == this.mangaId &&
          other.listType == this.listType &&
          other.addedAt == this.addedAt &&
          other.lastOpened == this.lastOpened);
}

class LibraryEntriesCompanion extends UpdateCompanion<LibraryEntry> {
  final Value<int> id;
  final Value<String> mangaId;
  final Value<String> listType;
  final Value<DateTime> addedAt;
  final Value<DateTime?> lastOpened;
  const LibraryEntriesCompanion({
    this.id = const Value.absent(),
    this.mangaId = const Value.absent(),
    this.listType = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.lastOpened = const Value.absent(),
  });
  LibraryEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String mangaId,
    required String listType,
    this.addedAt = const Value.absent(),
    this.lastOpened = const Value.absent(),
  }) : mangaId = Value(mangaId),
       listType = Value(listType);
  static Insertable<LibraryEntry> custom({
    Expression<int>? id,
    Expression<String>? mangaId,
    Expression<String>? listType,
    Expression<DateTime>? addedAt,
    Expression<DateTime>? lastOpened,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mangaId != null) 'manga_id': mangaId,
      if (listType != null) 'list_type': listType,
      if (addedAt != null) 'added_at': addedAt,
      if (lastOpened != null) 'last_opened': lastOpened,
    });
  }

  LibraryEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? mangaId,
    Value<String>? listType,
    Value<DateTime>? addedAt,
    Value<DateTime?>? lastOpened,
  }) {
    return LibraryEntriesCompanion(
      id: id ?? this.id,
      mangaId: mangaId ?? this.mangaId,
      listType: listType ?? this.listType,
      addedAt: addedAt ?? this.addedAt,
      lastOpened: lastOpened ?? this.lastOpened,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mangaId.present) {
      map['manga_id'] = Variable<String>(mangaId.value);
    }
    if (listType.present) {
      map['list_type'] = Variable<String>(listType.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (lastOpened.present) {
      map['last_opened'] = Variable<DateTime>(lastOpened.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LibraryEntriesCompanion(')
          ..write('id: $id, ')
          ..write('mangaId: $mangaId, ')
          ..write('listType: $listType, ')
          ..write('addedAt: $addedAt, ')
          ..write('lastOpened: $lastOpened')
          ..write(')'))
        .toString();
  }
}

class $ReadingHistoryTable extends ReadingHistory
    with TableInfo<$ReadingHistoryTable, ReadingHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _mangaIdMeta = const VerificationMeta(
    'mangaId',
  );
  @override
  late final GeneratedColumn<String> mangaId = GeneratedColumn<String>(
    'manga_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES mangas (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _chapterIdMeta = const VerificationMeta(
    'chapterId',
  );
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
    'chapter_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES chapters (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _pageMeta = const VerificationMeta('page');
  @override
  late final GeneratedColumn<int> page = GeneratedColumn<int>(
    'page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  @override
  late final GeneratedColumn<DateTime> readAt = GeneratedColumn<DateTime>(
    'read_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, mangaId, chapterId, page, readAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReadingHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('manga_id')) {
      context.handle(
        _mangaIdMeta,
        mangaId.isAcceptableOrUnknown(data['manga_id']!, _mangaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mangaIdMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(
        _chapterIdMeta,
        chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('page')) {
      context.handle(
        _pageMeta,
        page.isAcceptableOrUnknown(data['page']!, _pageMeta),
      );
    }
    if (data.containsKey('read_at')) {
      context.handle(
        _readAtMeta,
        readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReadingHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      mangaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manga_id'],
      )!,
      chapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_id'],
      )!,
      page: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page'],
      )!,
      readAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}read_at'],
      )!,
    );
  }

  @override
  $ReadingHistoryTable createAlias(String alias) {
    return $ReadingHistoryTable(attachedDatabase, alias);
  }
}

class ReadingHistoryData extends DataClass
    implements Insertable<ReadingHistoryData> {
  final int id;
  final String mangaId;
  final String chapterId;
  final int page;
  final DateTime readAt;
  const ReadingHistoryData({
    required this.id,
    required this.mangaId,
    required this.chapterId,
    required this.page,
    required this.readAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['manga_id'] = Variable<String>(mangaId);
    map['chapter_id'] = Variable<String>(chapterId);
    map['page'] = Variable<int>(page);
    map['read_at'] = Variable<DateTime>(readAt);
    return map;
  }

  ReadingHistoryCompanion toCompanion(bool nullToAbsent) {
    return ReadingHistoryCompanion(
      id: Value(id),
      mangaId: Value(mangaId),
      chapterId: Value(chapterId),
      page: Value(page),
      readAt: Value(readAt),
    );
  }

  factory ReadingHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingHistoryData(
      id: serializer.fromJson<int>(json['id']),
      mangaId: serializer.fromJson<String>(json['mangaId']),
      chapterId: serializer.fromJson<String>(json['chapterId']),
      page: serializer.fromJson<int>(json['page']),
      readAt: serializer.fromJson<DateTime>(json['readAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mangaId': serializer.toJson<String>(mangaId),
      'chapterId': serializer.toJson<String>(chapterId),
      'page': serializer.toJson<int>(page),
      'readAt': serializer.toJson<DateTime>(readAt),
    };
  }

  ReadingHistoryData copyWith({
    int? id,
    String? mangaId,
    String? chapterId,
    int? page,
    DateTime? readAt,
  }) => ReadingHistoryData(
    id: id ?? this.id,
    mangaId: mangaId ?? this.mangaId,
    chapterId: chapterId ?? this.chapterId,
    page: page ?? this.page,
    readAt: readAt ?? this.readAt,
  );
  ReadingHistoryData copyWithCompanion(ReadingHistoryCompanion data) {
    return ReadingHistoryData(
      id: data.id.present ? data.id.value : this.id,
      mangaId: data.mangaId.present ? data.mangaId.value : this.mangaId,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      page: data.page.present ? data.page.value : this.page,
      readAt: data.readAt.present ? data.readAt.value : this.readAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingHistoryData(')
          ..write('id: $id, ')
          ..write('mangaId: $mangaId, ')
          ..write('chapterId: $chapterId, ')
          ..write('page: $page, ')
          ..write('readAt: $readAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, mangaId, chapterId, page, readAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingHistoryData &&
          other.id == this.id &&
          other.mangaId == this.mangaId &&
          other.chapterId == this.chapterId &&
          other.page == this.page &&
          other.readAt == this.readAt);
}

class ReadingHistoryCompanion extends UpdateCompanion<ReadingHistoryData> {
  final Value<int> id;
  final Value<String> mangaId;
  final Value<String> chapterId;
  final Value<int> page;
  final Value<DateTime> readAt;
  const ReadingHistoryCompanion({
    this.id = const Value.absent(),
    this.mangaId = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.page = const Value.absent(),
    this.readAt = const Value.absent(),
  });
  ReadingHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String mangaId,
    required String chapterId,
    this.page = const Value.absent(),
    this.readAt = const Value.absent(),
  }) : mangaId = Value(mangaId),
       chapterId = Value(chapterId);
  static Insertable<ReadingHistoryData> custom({
    Expression<int>? id,
    Expression<String>? mangaId,
    Expression<String>? chapterId,
    Expression<int>? page,
    Expression<DateTime>? readAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mangaId != null) 'manga_id': mangaId,
      if (chapterId != null) 'chapter_id': chapterId,
      if (page != null) 'page': page,
      if (readAt != null) 'read_at': readAt,
    });
  }

  ReadingHistoryCompanion copyWith({
    Value<int>? id,
    Value<String>? mangaId,
    Value<String>? chapterId,
    Value<int>? page,
    Value<DateTime>? readAt,
  }) {
    return ReadingHistoryCompanion(
      id: id ?? this.id,
      mangaId: mangaId ?? this.mangaId,
      chapterId: chapterId ?? this.chapterId,
      page: page ?? this.page,
      readAt: readAt ?? this.readAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mangaId.present) {
      map['manga_id'] = Variable<String>(mangaId.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (page.present) {
      map['page'] = Variable<int>(page.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<DateTime>(readAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingHistoryCompanion(')
          ..write('id: $id, ')
          ..write('mangaId: $mangaId, ')
          ..write('chapterId: $chapterId, ')
          ..write('page: $page, ')
          ..write('readAt: $readAt')
          ..write(')'))
        .toString();
  }
}

class $DownloadsTable extends Downloads
    with TableInfo<$DownloadsTable, Download> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _mangaIdMeta = const VerificationMeta(
    'mangaId',
  );
  @override
  late final GeneratedColumn<String> mangaId = GeneratedColumn<String>(
    'manga_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES mangas (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _chapterIdMeta = const VerificationMeta(
    'chapterId',
  );
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
    'chapter_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES chapters (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('queue'),
  );
  static const VerificationMeta _totalPagesMeta = const VerificationMeta(
    'totalPages',
  );
  @override
  late final GeneratedColumn<int> totalPages = GeneratedColumn<int>(
    'total_pages',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _donePagesMeta = const VerificationMeta(
    'donePages',
  );
  @override
  late final GeneratedColumn<int> donePages = GeneratedColumn<int>(
    'done_pages',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mangaId,
    chapterId,
    status,
    totalPages,
    donePages,
    sizeBytes,
    localPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'downloads';
  @override
  VerificationContext validateIntegrity(
    Insertable<Download> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('manga_id')) {
      context.handle(
        _mangaIdMeta,
        mangaId.isAcceptableOrUnknown(data['manga_id']!, _mangaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mangaIdMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(
        _chapterIdMeta,
        chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('total_pages')) {
      context.handle(
        _totalPagesMeta,
        totalPages.isAcceptableOrUnknown(data['total_pages']!, _totalPagesMeta),
      );
    }
    if (data.containsKey('done_pages')) {
      context.handle(
        _donePagesMeta,
        donePages.isAcceptableOrUnknown(data['done_pages']!, _donePagesMeta),
      );
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
      );
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {chapterId},
  ];
  @override
  Download map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Download(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      mangaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manga_id'],
      )!,
      chapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      totalPages: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_pages'],
      )!,
      donePages: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}done_pages'],
      )!,
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      ),
    );
  }

  @override
  $DownloadsTable createAlias(String alias) {
    return $DownloadsTable(attachedDatabase, alias);
  }
}

class Download extends DataClass implements Insertable<Download> {
  final int id;
  final String mangaId;
  final String chapterId;
  final String status;
  final int totalPages;
  final int donePages;
  final int sizeBytes;
  final String? localPath;
  const Download({
    required this.id,
    required this.mangaId,
    required this.chapterId,
    required this.status,
    required this.totalPages,
    required this.donePages,
    required this.sizeBytes,
    this.localPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['manga_id'] = Variable<String>(mangaId);
    map['chapter_id'] = Variable<String>(chapterId);
    map['status'] = Variable<String>(status);
    map['total_pages'] = Variable<int>(totalPages);
    map['done_pages'] = Variable<int>(donePages);
    map['size_bytes'] = Variable<int>(sizeBytes);
    if (!nullToAbsent || localPath != null) {
      map['local_path'] = Variable<String>(localPath);
    }
    return map;
  }

  DownloadsCompanion toCompanion(bool nullToAbsent) {
    return DownloadsCompanion(
      id: Value(id),
      mangaId: Value(mangaId),
      chapterId: Value(chapterId),
      status: Value(status),
      totalPages: Value(totalPages),
      donePages: Value(donePages),
      sizeBytes: Value(sizeBytes),
      localPath: localPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localPath),
    );
  }

  factory Download.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Download(
      id: serializer.fromJson<int>(json['id']),
      mangaId: serializer.fromJson<String>(json['mangaId']),
      chapterId: serializer.fromJson<String>(json['chapterId']),
      status: serializer.fromJson<String>(json['status']),
      totalPages: serializer.fromJson<int>(json['totalPages']),
      donePages: serializer.fromJson<int>(json['donePages']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
      localPath: serializer.fromJson<String?>(json['localPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mangaId': serializer.toJson<String>(mangaId),
      'chapterId': serializer.toJson<String>(chapterId),
      'status': serializer.toJson<String>(status),
      'totalPages': serializer.toJson<int>(totalPages),
      'donePages': serializer.toJson<int>(donePages),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
      'localPath': serializer.toJson<String?>(localPath),
    };
  }

  Download copyWith({
    int? id,
    String? mangaId,
    String? chapterId,
    String? status,
    int? totalPages,
    int? donePages,
    int? sizeBytes,
    Value<String?> localPath = const Value.absent(),
  }) => Download(
    id: id ?? this.id,
    mangaId: mangaId ?? this.mangaId,
    chapterId: chapterId ?? this.chapterId,
    status: status ?? this.status,
    totalPages: totalPages ?? this.totalPages,
    donePages: donePages ?? this.donePages,
    sizeBytes: sizeBytes ?? this.sizeBytes,
    localPath: localPath.present ? localPath.value : this.localPath,
  );
  Download copyWithCompanion(DownloadsCompanion data) {
    return Download(
      id: data.id.present ? data.id.value : this.id,
      mangaId: data.mangaId.present ? data.mangaId.value : this.mangaId,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      status: data.status.present ? data.status.value : this.status,
      totalPages: data.totalPages.present
          ? data.totalPages.value
          : this.totalPages,
      donePages: data.donePages.present ? data.donePages.value : this.donePages,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Download(')
          ..write('id: $id, ')
          ..write('mangaId: $mangaId, ')
          ..write('chapterId: $chapterId, ')
          ..write('status: $status, ')
          ..write('totalPages: $totalPages, ')
          ..write('donePages: $donePages, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('localPath: $localPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    mangaId,
    chapterId,
    status,
    totalPages,
    donePages,
    sizeBytes,
    localPath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Download &&
          other.id == this.id &&
          other.mangaId == this.mangaId &&
          other.chapterId == this.chapterId &&
          other.status == this.status &&
          other.totalPages == this.totalPages &&
          other.donePages == this.donePages &&
          other.sizeBytes == this.sizeBytes &&
          other.localPath == this.localPath);
}

class DownloadsCompanion extends UpdateCompanion<Download> {
  final Value<int> id;
  final Value<String> mangaId;
  final Value<String> chapterId;
  final Value<String> status;
  final Value<int> totalPages;
  final Value<int> donePages;
  final Value<int> sizeBytes;
  final Value<String?> localPath;
  const DownloadsCompanion({
    this.id = const Value.absent(),
    this.mangaId = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.status = const Value.absent(),
    this.totalPages = const Value.absent(),
    this.donePages = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.localPath = const Value.absent(),
  });
  DownloadsCompanion.insert({
    this.id = const Value.absent(),
    required String mangaId,
    required String chapterId,
    this.status = const Value.absent(),
    this.totalPages = const Value.absent(),
    this.donePages = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.localPath = const Value.absent(),
  }) : mangaId = Value(mangaId),
       chapterId = Value(chapterId);
  static Insertable<Download> custom({
    Expression<int>? id,
    Expression<String>? mangaId,
    Expression<String>? chapterId,
    Expression<String>? status,
    Expression<int>? totalPages,
    Expression<int>? donePages,
    Expression<int>? sizeBytes,
    Expression<String>? localPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mangaId != null) 'manga_id': mangaId,
      if (chapterId != null) 'chapter_id': chapterId,
      if (status != null) 'status': status,
      if (totalPages != null) 'total_pages': totalPages,
      if (donePages != null) 'done_pages': donePages,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (localPath != null) 'local_path': localPath,
    });
  }

  DownloadsCompanion copyWith({
    Value<int>? id,
    Value<String>? mangaId,
    Value<String>? chapterId,
    Value<String>? status,
    Value<int>? totalPages,
    Value<int>? donePages,
    Value<int>? sizeBytes,
    Value<String?>? localPath,
  }) {
    return DownloadsCompanion(
      id: id ?? this.id,
      mangaId: mangaId ?? this.mangaId,
      chapterId: chapterId ?? this.chapterId,
      status: status ?? this.status,
      totalPages: totalPages ?? this.totalPages,
      donePages: donePages ?? this.donePages,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      localPath: localPath ?? this.localPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mangaId.present) {
      map['manga_id'] = Variable<String>(mangaId.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (totalPages.present) {
      map['total_pages'] = Variable<int>(totalPages.value);
    }
    if (donePages.present) {
      map['done_pages'] = Variable<int>(donePages.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadsCompanion(')
          ..write('id: $id, ')
          ..write('mangaId: $mangaId, ')
          ..write('chapterId: $chapterId, ')
          ..write('status: $status, ')
          ..write('totalPages: $totalPages, ')
          ..write('donePages: $donePages, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('localPath: $localPath')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _themeMeta = const VerificationMeta('theme');
  @override
  late final GeneratedColumn<String> theme = GeneratedColumn<String>(
    'theme',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _chapterLangMeta = const VerificationMeta(
    'chapterLang',
  );
  @override
  late final GeneratedColumn<String> chapterLang = GeneratedColumn<String>(
    'chapter_lang',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('id'),
  );
  static const VerificationMeta _adultFilterMeta = const VerificationMeta(
    'adultFilter',
  );
  @override
  late final GeneratedColumn<bool> adultFilter = GeneratedColumn<bool>(
    'adult_filter',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("adult_filter" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _dataSaverMeta = const VerificationMeta(
    'dataSaver',
  );
  @override
  late final GeneratedColumn<bool> dataSaver = GeneratedColumn<bool>(
    'data_saver',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("data_saver" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _readDirectionMeta = const VerificationMeta(
    'readDirection',
  );
  @override
  late final GeneratedColumn<String> readDirection = GeneratedColumn<String>(
    'read_direction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('vertical'),
  );
  static const VerificationMeta _brightnessMeta = const VerificationMeta(
    'brightness',
  );
  @override
  late final GeneratedColumn<double> brightness = GeneratedColumn<double>(
    'brightness',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('komiku'),
  );
  static const VerificationMeta _recentSearchesMeta = const VerificationMeta(
    'recentSearches',
  );
  @override
  late final GeneratedColumn<String> recentSearches = GeneratedColumn<String>(
    'recent_searches',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _autoScrollSpeedMeta = const VerificationMeta(
    'autoScrollSpeed',
  );
  @override
  late final GeneratedColumn<double> autoScrollSpeed = GeneratedColumn<double>(
    'auto_scroll_speed',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(4.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    theme,
    chapterLang,
    adultFilter,
    dataSaver,
    readDirection,
    brightness,
    source,
    recentSearches,
    autoScrollSpeed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('theme')) {
      context.handle(
        _themeMeta,
        theme.isAcceptableOrUnknown(data['theme']!, _themeMeta),
      );
    }
    if (data.containsKey('chapter_lang')) {
      context.handle(
        _chapterLangMeta,
        chapterLang.isAcceptableOrUnknown(
          data['chapter_lang']!,
          _chapterLangMeta,
        ),
      );
    }
    if (data.containsKey('adult_filter')) {
      context.handle(
        _adultFilterMeta,
        adultFilter.isAcceptableOrUnknown(
          data['adult_filter']!,
          _adultFilterMeta,
        ),
      );
    }
    if (data.containsKey('data_saver')) {
      context.handle(
        _dataSaverMeta,
        dataSaver.isAcceptableOrUnknown(data['data_saver']!, _dataSaverMeta),
      );
    }
    if (data.containsKey('read_direction')) {
      context.handle(
        _readDirectionMeta,
        readDirection.isAcceptableOrUnknown(
          data['read_direction']!,
          _readDirectionMeta,
        ),
      );
    }
    if (data.containsKey('brightness')) {
      context.handle(
        _brightnessMeta,
        brightness.isAcceptableOrUnknown(data['brightness']!, _brightnessMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('recent_searches')) {
      context.handle(
        _recentSearchesMeta,
        recentSearches.isAcceptableOrUnknown(
          data['recent_searches']!,
          _recentSearchesMeta,
        ),
      );
    }
    if (data.containsKey('auto_scroll_speed')) {
      context.handle(
        _autoScrollSpeedMeta,
        autoScrollSpeed.isAcceptableOrUnknown(
          data['auto_scroll_speed']!,
          _autoScrollSpeedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      theme: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme'],
      )!,
      chapterLang: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_lang'],
      )!,
      adultFilter: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}adult_filter'],
      )!,
      dataSaver: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}data_saver'],
      )!,
      readDirection: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}read_direction'],
      )!,
      brightness: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}brightness'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      recentSearches: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recent_searches'],
      )!,
      autoScrollSpeed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}auto_scroll_speed'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final String theme;
  final String chapterLang;
  final bool adultFilter;
  final bool dataSaver;
  final String readDirection;
  final double? brightness;
  final String source;
  final String recentSearches;
  final double autoScrollSpeed;
  const AppSetting({
    required this.id,
    required this.theme,
    required this.chapterLang,
    required this.adultFilter,
    required this.dataSaver,
    required this.readDirection,
    this.brightness,
    required this.source,
    required this.recentSearches,
    required this.autoScrollSpeed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['theme'] = Variable<String>(theme);
    map['chapter_lang'] = Variable<String>(chapterLang);
    map['adult_filter'] = Variable<bool>(adultFilter);
    map['data_saver'] = Variable<bool>(dataSaver);
    map['read_direction'] = Variable<String>(readDirection);
    if (!nullToAbsent || brightness != null) {
      map['brightness'] = Variable<double>(brightness);
    }
    map['source'] = Variable<String>(source);
    map['recent_searches'] = Variable<String>(recentSearches);
    map['auto_scroll_speed'] = Variable<double>(autoScrollSpeed);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      theme: Value(theme),
      chapterLang: Value(chapterLang),
      adultFilter: Value(adultFilter),
      dataSaver: Value(dataSaver),
      readDirection: Value(readDirection),
      brightness: brightness == null && nullToAbsent
          ? const Value.absent()
          : Value(brightness),
      source: Value(source),
      recentSearches: Value(recentSearches),
      autoScrollSpeed: Value(autoScrollSpeed),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      theme: serializer.fromJson<String>(json['theme']),
      chapterLang: serializer.fromJson<String>(json['chapterLang']),
      adultFilter: serializer.fromJson<bool>(json['adultFilter']),
      dataSaver: serializer.fromJson<bool>(json['dataSaver']),
      readDirection: serializer.fromJson<String>(json['readDirection']),
      brightness: serializer.fromJson<double?>(json['brightness']),
      source: serializer.fromJson<String>(json['source']),
      recentSearches: serializer.fromJson<String>(json['recentSearches']),
      autoScrollSpeed: serializer.fromJson<double>(json['autoScrollSpeed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'theme': serializer.toJson<String>(theme),
      'chapterLang': serializer.toJson<String>(chapterLang),
      'adultFilter': serializer.toJson<bool>(adultFilter),
      'dataSaver': serializer.toJson<bool>(dataSaver),
      'readDirection': serializer.toJson<String>(readDirection),
      'brightness': serializer.toJson<double?>(brightness),
      'source': serializer.toJson<String>(source),
      'recentSearches': serializer.toJson<String>(recentSearches),
      'autoScrollSpeed': serializer.toJson<double>(autoScrollSpeed),
    };
  }

  AppSetting copyWith({
    int? id,
    String? theme,
    String? chapterLang,
    bool? adultFilter,
    bool? dataSaver,
    String? readDirection,
    Value<double?> brightness = const Value.absent(),
    String? source,
    String? recentSearches,
    double? autoScrollSpeed,
  }) => AppSetting(
    id: id ?? this.id,
    theme: theme ?? this.theme,
    chapterLang: chapterLang ?? this.chapterLang,
    adultFilter: adultFilter ?? this.adultFilter,
    dataSaver: dataSaver ?? this.dataSaver,
    readDirection: readDirection ?? this.readDirection,
    brightness: brightness.present ? brightness.value : this.brightness,
    source: source ?? this.source,
    recentSearches: recentSearches ?? this.recentSearches,
    autoScrollSpeed: autoScrollSpeed ?? this.autoScrollSpeed,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      theme: data.theme.present ? data.theme.value : this.theme,
      chapterLang: data.chapterLang.present
          ? data.chapterLang.value
          : this.chapterLang,
      adultFilter: data.adultFilter.present
          ? data.adultFilter.value
          : this.adultFilter,
      dataSaver: data.dataSaver.present ? data.dataSaver.value : this.dataSaver,
      readDirection: data.readDirection.present
          ? data.readDirection.value
          : this.readDirection,
      brightness: data.brightness.present
          ? data.brightness.value
          : this.brightness,
      source: data.source.present ? data.source.value : this.source,
      recentSearches: data.recentSearches.present
          ? data.recentSearches.value
          : this.recentSearches,
      autoScrollSpeed: data.autoScrollSpeed.present
          ? data.autoScrollSpeed.value
          : this.autoScrollSpeed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('theme: $theme, ')
          ..write('chapterLang: $chapterLang, ')
          ..write('adultFilter: $adultFilter, ')
          ..write('dataSaver: $dataSaver, ')
          ..write('readDirection: $readDirection, ')
          ..write('brightness: $brightness, ')
          ..write('source: $source, ')
          ..write('recentSearches: $recentSearches, ')
          ..write('autoScrollSpeed: $autoScrollSpeed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    theme,
    chapterLang,
    adultFilter,
    dataSaver,
    readDirection,
    brightness,
    source,
    recentSearches,
    autoScrollSpeed,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.theme == this.theme &&
          other.chapterLang == this.chapterLang &&
          other.adultFilter == this.adultFilter &&
          other.dataSaver == this.dataSaver &&
          other.readDirection == this.readDirection &&
          other.brightness == this.brightness &&
          other.source == this.source &&
          other.recentSearches == this.recentSearches &&
          other.autoScrollSpeed == this.autoScrollSpeed);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<String> theme;
  final Value<String> chapterLang;
  final Value<bool> adultFilter;
  final Value<bool> dataSaver;
  final Value<String> readDirection;
  final Value<double?> brightness;
  final Value<String> source;
  final Value<String> recentSearches;
  final Value<double> autoScrollSpeed;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.theme = const Value.absent(),
    this.chapterLang = const Value.absent(),
    this.adultFilter = const Value.absent(),
    this.dataSaver = const Value.absent(),
    this.readDirection = const Value.absent(),
    this.brightness = const Value.absent(),
    this.source = const Value.absent(),
    this.recentSearches = const Value.absent(),
    this.autoScrollSpeed = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.theme = const Value.absent(),
    this.chapterLang = const Value.absent(),
    this.adultFilter = const Value.absent(),
    this.dataSaver = const Value.absent(),
    this.readDirection = const Value.absent(),
    this.brightness = const Value.absent(),
    this.source = const Value.absent(),
    this.recentSearches = const Value.absent(),
    this.autoScrollSpeed = const Value.absent(),
  });
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<String>? theme,
    Expression<String>? chapterLang,
    Expression<bool>? adultFilter,
    Expression<bool>? dataSaver,
    Expression<String>? readDirection,
    Expression<double>? brightness,
    Expression<String>? source,
    Expression<String>? recentSearches,
    Expression<double>? autoScrollSpeed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (theme != null) 'theme': theme,
      if (chapterLang != null) 'chapter_lang': chapterLang,
      if (adultFilter != null) 'adult_filter': adultFilter,
      if (dataSaver != null) 'data_saver': dataSaver,
      if (readDirection != null) 'read_direction': readDirection,
      if (brightness != null) 'brightness': brightness,
      if (source != null) 'source': source,
      if (recentSearches != null) 'recent_searches': recentSearches,
      if (autoScrollSpeed != null) 'auto_scroll_speed': autoScrollSpeed,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? theme,
    Value<String>? chapterLang,
    Value<bool>? adultFilter,
    Value<bool>? dataSaver,
    Value<String>? readDirection,
    Value<double?>? brightness,
    Value<String>? source,
    Value<String>? recentSearches,
    Value<double>? autoScrollSpeed,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      theme: theme ?? this.theme,
      chapterLang: chapterLang ?? this.chapterLang,
      adultFilter: adultFilter ?? this.adultFilter,
      dataSaver: dataSaver ?? this.dataSaver,
      readDirection: readDirection ?? this.readDirection,
      brightness: brightness ?? this.brightness,
      source: source ?? this.source,
      recentSearches: recentSearches ?? this.recentSearches,
      autoScrollSpeed: autoScrollSpeed ?? this.autoScrollSpeed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (theme.present) {
      map['theme'] = Variable<String>(theme.value);
    }
    if (chapterLang.present) {
      map['chapter_lang'] = Variable<String>(chapterLang.value);
    }
    if (adultFilter.present) {
      map['adult_filter'] = Variable<bool>(adultFilter.value);
    }
    if (dataSaver.present) {
      map['data_saver'] = Variable<bool>(dataSaver.value);
    }
    if (readDirection.present) {
      map['read_direction'] = Variable<String>(readDirection.value);
    }
    if (brightness.present) {
      map['brightness'] = Variable<double>(brightness.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (recentSearches.present) {
      map['recent_searches'] = Variable<String>(recentSearches.value);
    }
    if (autoScrollSpeed.present) {
      map['auto_scroll_speed'] = Variable<double>(autoScrollSpeed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('theme: $theme, ')
          ..write('chapterLang: $chapterLang, ')
          ..write('adultFilter: $adultFilter, ')
          ..write('dataSaver: $dataSaver, ')
          ..write('readDirection: $readDirection, ')
          ..write('brightness: $brightness, ')
          ..write('source: $source, ')
          ..write('recentSearches: $recentSearches, ')
          ..write('autoScrollSpeed: $autoScrollSpeed')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MangasTable mangas = $MangasTable(this);
  late final $ChaptersTable chapters = $ChaptersTable(this);
  late final $LibraryEntriesTable libraryEntries = $LibraryEntriesTable(this);
  late final $ReadingHistoryTable readingHistory = $ReadingHistoryTable(this);
  late final $DownloadsTable downloads = $DownloadsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    mangas,
    chapters,
    libraryEntries,
    readingHistory,
    downloads,
    appSettings,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'mangas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('chapters', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'mangas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('library_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'mangas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reading_history', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'chapters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reading_history', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'mangas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('downloads', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'chapters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('downloads', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$MangasTableCreateCompanionBuilder =
    MangasCompanion Function({
      required String id,
      required String title,
      Value<String?> altTitles,
      Value<String?> description,
      Value<String?> status,
      Value<String?> contentRating,
      Value<int?> year,
      Value<String?> coverUrl,
      Value<String?> tags,
      Value<String?> author,
      Value<String?> artist,
      Value<DateTime?> lastFetched,
      Value<int> rowid,
    });
typedef $$MangasTableUpdateCompanionBuilder =
    MangasCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> altTitles,
      Value<String?> description,
      Value<String?> status,
      Value<String?> contentRating,
      Value<int?> year,
      Value<String?> coverUrl,
      Value<String?> tags,
      Value<String?> author,
      Value<String?> artist,
      Value<DateTime?> lastFetched,
      Value<int> rowid,
    });

final class $$MangasTableReferences
    extends BaseReferences<_$AppDatabase, $MangasTable, Manga> {
  $$MangasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ChaptersTable, List<Chapter>> _chaptersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.chapters,
    aliasName: 'mangas__id__chapters__manga_id',
  );

  $$ChaptersTableProcessedTableManager get chaptersRefs {
    final manager = $$ChaptersTableTableManager(
      $_db,
      $_db.chapters,
    ).filter((f) => f.mangaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_chaptersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LibraryEntriesTable, List<LibraryEntry>>
  _libraryEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.libraryEntries,
    aliasName: 'mangas__id__library_entries__manga_id',
  );

  $$LibraryEntriesTableProcessedTableManager get libraryEntriesRefs {
    final manager = $$LibraryEntriesTableTableManager(
      $_db,
      $_db.libraryEntries,
    ).filter((f) => f.mangaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_libraryEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReadingHistoryTable, List<ReadingHistoryData>>
  _readingHistoryRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.readingHistory,
    aliasName: 'mangas__id__reading_history__manga_id',
  );

  $$ReadingHistoryTableProcessedTableManager get readingHistoryRefs {
    final manager = $$ReadingHistoryTableTableManager(
      $_db,
      $_db.readingHistory,
    ).filter((f) => f.mangaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_readingHistoryRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DownloadsTable, List<Download>>
  _downloadsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.downloads,
    aliasName: 'mangas__id__downloads__manga_id',
  );

  $$DownloadsTableProcessedTableManager get downloadsRefs {
    final manager = $$DownloadsTableTableManager(
      $_db,
      $_db.downloads,
    ).filter((f) => f.mangaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_downloadsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MangasTableFilterComposer
    extends Composer<_$AppDatabase, $MangasTable> {
  $$MangasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get altTitles => $composableBuilder(
    column: $table.altTitles,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentRating => $composableBuilder(
    column: $table.contentRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artist => $composableBuilder(
    column: $table.artist,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastFetched => $composableBuilder(
    column: $table.lastFetched,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> chaptersRefs(
    Expression<bool> Function($$ChaptersTableFilterComposer f) f,
  ) {
    final $$ChaptersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.mangaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableFilterComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> libraryEntriesRefs(
    Expression<bool> Function($$LibraryEntriesTableFilterComposer f) f,
  ) {
    final $$LibraryEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.libraryEntries,
      getReferencedColumn: (t) => t.mangaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LibraryEntriesTableFilterComposer(
            $db: $db,
            $table: $db.libraryEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> readingHistoryRefs(
    Expression<bool> Function($$ReadingHistoryTableFilterComposer f) f,
  ) {
    final $$ReadingHistoryTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingHistory,
      getReferencedColumn: (t) => t.mangaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingHistoryTableFilterComposer(
            $db: $db,
            $table: $db.readingHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> downloadsRefs(
    Expression<bool> Function($$DownloadsTableFilterComposer f) f,
  ) {
    final $$DownloadsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.downloads,
      getReferencedColumn: (t) => t.mangaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DownloadsTableFilterComposer(
            $db: $db,
            $table: $db.downloads,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MangasTableOrderingComposer
    extends Composer<_$AppDatabase, $MangasTable> {
  $$MangasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get altTitles => $composableBuilder(
    column: $table.altTitles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentRating => $composableBuilder(
    column: $table.contentRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artist => $composableBuilder(
    column: $table.artist,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastFetched => $composableBuilder(
    column: $table.lastFetched,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MangasTableAnnotationComposer
    extends Composer<_$AppDatabase, $MangasTable> {
  $$MangasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get altTitles =>
      $composableBuilder(column: $table.altTitles, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get contentRating => $composableBuilder(
    column: $table.contentRating,
    builder: (column) => column,
  );

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get coverUrl =>
      $composableBuilder(column: $table.coverUrl, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get artist =>
      $composableBuilder(column: $table.artist, builder: (column) => column);

  GeneratedColumn<DateTime> get lastFetched => $composableBuilder(
    column: $table.lastFetched,
    builder: (column) => column,
  );

  Expression<T> chaptersRefs<T extends Object>(
    Expression<T> Function($$ChaptersTableAnnotationComposer a) f,
  ) {
    final $$ChaptersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.mangaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableAnnotationComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> libraryEntriesRefs<T extends Object>(
    Expression<T> Function($$LibraryEntriesTableAnnotationComposer a) f,
  ) {
    final $$LibraryEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.libraryEntries,
      getReferencedColumn: (t) => t.mangaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LibraryEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.libraryEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> readingHistoryRefs<T extends Object>(
    Expression<T> Function($$ReadingHistoryTableAnnotationComposer a) f,
  ) {
    final $$ReadingHistoryTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingHistory,
      getReferencedColumn: (t) => t.mangaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingHistoryTableAnnotationComposer(
            $db: $db,
            $table: $db.readingHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> downloadsRefs<T extends Object>(
    Expression<T> Function($$DownloadsTableAnnotationComposer a) f,
  ) {
    final $$DownloadsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.downloads,
      getReferencedColumn: (t) => t.mangaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DownloadsTableAnnotationComposer(
            $db: $db,
            $table: $db.downloads,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MangasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MangasTable,
          Manga,
          $$MangasTableFilterComposer,
          $$MangasTableOrderingComposer,
          $$MangasTableAnnotationComposer,
          $$MangasTableCreateCompanionBuilder,
          $$MangasTableUpdateCompanionBuilder,
          (Manga, $$MangasTableReferences),
          Manga,
          PrefetchHooks Function({
            bool chaptersRefs,
            bool libraryEntriesRefs,
            bool readingHistoryRefs,
            bool downloadsRefs,
          })
        > {
  $$MangasTableTableManager(_$AppDatabase db, $MangasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MangasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MangasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MangasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> altTitles = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<String?> contentRating = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String?> coverUrl = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<String?> artist = const Value.absent(),
                Value<DateTime?> lastFetched = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MangasCompanion(
                id: id,
                title: title,
                altTitles: altTitles,
                description: description,
                status: status,
                contentRating: contentRating,
                year: year,
                coverUrl: coverUrl,
                tags: tags,
                author: author,
                artist: artist,
                lastFetched: lastFetched,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> altTitles = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<String?> contentRating = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String?> coverUrl = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<String?> artist = const Value.absent(),
                Value<DateTime?> lastFetched = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MangasCompanion.insert(
                id: id,
                title: title,
                altTitles: altTitles,
                description: description,
                status: status,
                contentRating: contentRating,
                year: year,
                coverUrl: coverUrl,
                tags: tags,
                author: author,
                artist: artist,
                lastFetched: lastFetched,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MangasTable, Manga>(table),
                  $$MangasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                chaptersRefs = false,
                libraryEntriesRefs = false,
                readingHistoryRefs = false,
                downloadsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (chaptersRefs) db.chapters,
                    if (libraryEntriesRefs) db.libraryEntries,
                    if (readingHistoryRefs) db.readingHistory,
                    if (downloadsRefs) db.downloads,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (chaptersRefs)
                        await $_getPrefetchedData<Manga, $MangasTable, Chapter>(
                          currentTable: table,
                          referencedTable: $$MangasTableReferences
                              ._chaptersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MangasTableReferences(
                                db,
                                table,
                                p0,
                              ).chaptersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.mangaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (libraryEntriesRefs)
                        await $_getPrefetchedData<
                          Manga,
                          $MangasTable,
                          LibraryEntry
                        >(
                          currentTable: table,
                          referencedTable: $$MangasTableReferences
                              ._libraryEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MangasTableReferences(
                                db,
                                table,
                                p0,
                              ).libraryEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.mangaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (readingHistoryRefs)
                        await $_getPrefetchedData<
                          Manga,
                          $MangasTable,
                          ReadingHistoryData
                        >(
                          currentTable: table,
                          referencedTable: $$MangasTableReferences
                              ._readingHistoryRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MangasTableReferences(
                                db,
                                table,
                                p0,
                              ).readingHistoryRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.mangaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (downloadsRefs)
                        await $_getPrefetchedData<
                          Manga,
                          $MangasTable,
                          Download
                        >(
                          currentTable: table,
                          referencedTable: $$MangasTableReferences
                              ._downloadsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MangasTableReferences(
                                db,
                                table,
                                p0,
                              ).downloadsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.mangaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MangasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MangasTable,
      Manga,
      $$MangasTableFilterComposer,
      $$MangasTableOrderingComposer,
      $$MangasTableAnnotationComposer,
      $$MangasTableCreateCompanionBuilder,
      $$MangasTableUpdateCompanionBuilder,
      (Manga, $$MangasTableReferences),
      Manga,
      PrefetchHooks Function({
        bool chaptersRefs,
        bool libraryEntriesRefs,
        bool readingHistoryRefs,
        bool downloadsRefs,
      })
    >;
typedef $$ChaptersTableCreateCompanionBuilder =
    ChaptersCompanion Function({
      required String id,
      required String mangaId,
      Value<String?> title,
      Value<String?> chapterNo,
      Value<String?> volume,
      Value<String> language,
      Value<int> pages,
      Value<DateTime?> readableAt,
      Value<bool> isRead,
      Value<int> lastPage,
      Value<int> rowid,
    });
typedef $$ChaptersTableUpdateCompanionBuilder =
    ChaptersCompanion Function({
      Value<String> id,
      Value<String> mangaId,
      Value<String?> title,
      Value<String?> chapterNo,
      Value<String?> volume,
      Value<String> language,
      Value<int> pages,
      Value<DateTime?> readableAt,
      Value<bool> isRead,
      Value<int> lastPage,
      Value<int> rowid,
    });

final class $$ChaptersTableReferences
    extends BaseReferences<_$AppDatabase, $ChaptersTable, Chapter> {
  $$ChaptersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MangasTable _mangaIdTable(_$AppDatabase db) =>
      db.mangas.createAlias('chapters__manga_id__mangas__id');

  $$MangasTableProcessedTableManager get mangaId {
    final $_column = $_itemColumn<String>('manga_id')!;

    final manager = $$MangasTableTableManager(
      $_db,
      $_db.mangas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mangaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ReadingHistoryTable, List<ReadingHistoryData>>
  _readingHistoryRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.readingHistory,
    aliasName: 'chapters__id__reading_history__chapter_id',
  );

  $$ReadingHistoryTableProcessedTableManager get readingHistoryRefs {
    final manager = $$ReadingHistoryTableTableManager(
      $_db,
      $_db.readingHistory,
    ).filter((f) => f.chapterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_readingHistoryRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DownloadsTable, List<Download>>
  _downloadsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.downloads,
    aliasName: 'chapters__id__downloads__chapter_id',
  );

  $$DownloadsTableProcessedTableManager get downloadsRefs {
    final manager = $$DownloadsTableTableManager(
      $_db,
      $_db.downloads,
    ).filter((f) => f.chapterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_downloadsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ChaptersTableFilterComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chapterNo => $composableBuilder(
    column: $table.chapterNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get volume => $composableBuilder(
    column: $table.volume,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pages => $composableBuilder(
    column: $table.pages,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get readableAt => $composableBuilder(
    column: $table.readableAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastPage => $composableBuilder(
    column: $table.lastPage,
    builder: (column) => ColumnFilters(column),
  );

  $$MangasTableFilterComposer get mangaId {
    final $$MangasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mangaId,
      referencedTable: $db.mangas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MangasTableFilterComposer(
            $db: $db,
            $table: $db.mangas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> readingHistoryRefs(
    Expression<bool> Function($$ReadingHistoryTableFilterComposer f) f,
  ) {
    final $$ReadingHistoryTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingHistory,
      getReferencedColumn: (t) => t.chapterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingHistoryTableFilterComposer(
            $db: $db,
            $table: $db.readingHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> downloadsRefs(
    Expression<bool> Function($$DownloadsTableFilterComposer f) f,
  ) {
    final $$DownloadsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.downloads,
      getReferencedColumn: (t) => t.chapterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DownloadsTableFilterComposer(
            $db: $db,
            $table: $db.downloads,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChaptersTableOrderingComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chapterNo => $composableBuilder(
    column: $table.chapterNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get volume => $composableBuilder(
    column: $table.volume,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pages => $composableBuilder(
    column: $table.pages,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get readableAt => $composableBuilder(
    column: $table.readableAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastPage => $composableBuilder(
    column: $table.lastPage,
    builder: (column) => ColumnOrderings(column),
  );

  $$MangasTableOrderingComposer get mangaId {
    final $$MangasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mangaId,
      referencedTable: $db.mangas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MangasTableOrderingComposer(
            $db: $db,
            $table: $db.mangas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChaptersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get chapterNo =>
      $composableBuilder(column: $table.chapterNo, builder: (column) => column);

  GeneratedColumn<String> get volume =>
      $composableBuilder(column: $table.volume, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<int> get pages =>
      $composableBuilder(column: $table.pages, builder: (column) => column);

  GeneratedColumn<DateTime> get readableAt => $composableBuilder(
    column: $table.readableAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);

  GeneratedColumn<int> get lastPage =>
      $composableBuilder(column: $table.lastPage, builder: (column) => column);

  $$MangasTableAnnotationComposer get mangaId {
    final $$MangasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mangaId,
      referencedTable: $db.mangas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MangasTableAnnotationComposer(
            $db: $db,
            $table: $db.mangas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> readingHistoryRefs<T extends Object>(
    Expression<T> Function($$ReadingHistoryTableAnnotationComposer a) f,
  ) {
    final $$ReadingHistoryTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingHistory,
      getReferencedColumn: (t) => t.chapterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingHistoryTableAnnotationComposer(
            $db: $db,
            $table: $db.readingHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> downloadsRefs<T extends Object>(
    Expression<T> Function($$DownloadsTableAnnotationComposer a) f,
  ) {
    final $$DownloadsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.downloads,
      getReferencedColumn: (t) => t.chapterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DownloadsTableAnnotationComposer(
            $db: $db,
            $table: $db.downloads,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChaptersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChaptersTable,
          Chapter,
          $$ChaptersTableFilterComposer,
          $$ChaptersTableOrderingComposer,
          $$ChaptersTableAnnotationComposer,
          $$ChaptersTableCreateCompanionBuilder,
          $$ChaptersTableUpdateCompanionBuilder,
          (Chapter, $$ChaptersTableReferences),
          Chapter,
          PrefetchHooks Function({
            bool mangaId,
            bool readingHistoryRefs,
            bool downloadsRefs,
          })
        > {
  $$ChaptersTableTableManager(_$AppDatabase db, $ChaptersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChaptersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChaptersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChaptersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> mangaId = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> chapterNo = const Value.absent(),
                Value<String?> volume = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<int> pages = const Value.absent(),
                Value<DateTime?> readableAt = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<int> lastPage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChaptersCompanion(
                id: id,
                mangaId: mangaId,
                title: title,
                chapterNo: chapterNo,
                volume: volume,
                language: language,
                pages: pages,
                readableAt: readableAt,
                isRead: isRead,
                lastPage: lastPage,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String mangaId,
                Value<String?> title = const Value.absent(),
                Value<String?> chapterNo = const Value.absent(),
                Value<String?> volume = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<int> pages = const Value.absent(),
                Value<DateTime?> readableAt = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<int> lastPage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChaptersCompanion.insert(
                id: id,
                mangaId: mangaId,
                title: title,
                chapterNo: chapterNo,
                volume: volume,
                language: language,
                pages: pages,
                readableAt: readableAt,
                isRead: isRead,
                lastPage: lastPage,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChaptersTable, Chapter>(table),
                  $$ChaptersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                mangaId = false,
                readingHistoryRefs = false,
                downloadsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (readingHistoryRefs) db.readingHistory,
                    if (downloadsRefs) db.downloads,
                  ],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (mangaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.mangaId,
                                    referencedTable: $$ChaptersTableReferences
                                        ._mangaIdTable(db),
                                    referencedColumn: $$ChaptersTableReferences
                                        ._mangaIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (readingHistoryRefs)
                        await $_getPrefetchedData<
                          Chapter,
                          $ChaptersTable,
                          ReadingHistoryData
                        >(
                          currentTable: table,
                          referencedTable: $$ChaptersTableReferences
                              ._readingHistoryRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChaptersTableReferences(
                                db,
                                table,
                                p0,
                              ).readingHistoryRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.chapterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (downloadsRefs)
                        await $_getPrefetchedData<
                          Chapter,
                          $ChaptersTable,
                          Download
                        >(
                          currentTable: table,
                          referencedTable: $$ChaptersTableReferences
                              ._downloadsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChaptersTableReferences(
                                db,
                                table,
                                p0,
                              ).downloadsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.chapterId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ChaptersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChaptersTable,
      Chapter,
      $$ChaptersTableFilterComposer,
      $$ChaptersTableOrderingComposer,
      $$ChaptersTableAnnotationComposer,
      $$ChaptersTableCreateCompanionBuilder,
      $$ChaptersTableUpdateCompanionBuilder,
      (Chapter, $$ChaptersTableReferences),
      Chapter,
      PrefetchHooks Function({
        bool mangaId,
        bool readingHistoryRefs,
        bool downloadsRefs,
      })
    >;
typedef $$LibraryEntriesTableCreateCompanionBuilder =
    LibraryEntriesCompanion Function({
      Value<int> id,
      required String mangaId,
      required String listType,
      Value<DateTime> addedAt,
      Value<DateTime?> lastOpened,
    });
typedef $$LibraryEntriesTableUpdateCompanionBuilder =
    LibraryEntriesCompanion Function({
      Value<int> id,
      Value<String> mangaId,
      Value<String> listType,
      Value<DateTime> addedAt,
      Value<DateTime?> lastOpened,
    });

final class $$LibraryEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $LibraryEntriesTable, LibraryEntry> {
  $$LibraryEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MangasTable _mangaIdTable(_$AppDatabase db) =>
      db.mangas.createAlias('library_entries__manga_id__mangas__id');

  $$MangasTableProcessedTableManager get mangaId {
    final $_column = $_itemColumn<String>('manga_id')!;

    final manager = $$MangasTableTableManager(
      $_db,
      $_db.mangas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mangaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LibraryEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $LibraryEntriesTable> {
  $$LibraryEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get listType => $composableBuilder(
    column: $table.listType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastOpened => $composableBuilder(
    column: $table.lastOpened,
    builder: (column) => ColumnFilters(column),
  );

  $$MangasTableFilterComposer get mangaId {
    final $$MangasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mangaId,
      referencedTable: $db.mangas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MangasTableFilterComposer(
            $db: $db,
            $table: $db.mangas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LibraryEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $LibraryEntriesTable> {
  $$LibraryEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get listType => $composableBuilder(
    column: $table.listType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastOpened => $composableBuilder(
    column: $table.lastOpened,
    builder: (column) => ColumnOrderings(column),
  );

  $$MangasTableOrderingComposer get mangaId {
    final $$MangasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mangaId,
      referencedTable: $db.mangas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MangasTableOrderingComposer(
            $db: $db,
            $table: $db.mangas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LibraryEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LibraryEntriesTable> {
  $$LibraryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get listType =>
      $composableBuilder(column: $table.listType, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastOpened => $composableBuilder(
    column: $table.lastOpened,
    builder: (column) => column,
  );

  $$MangasTableAnnotationComposer get mangaId {
    final $$MangasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mangaId,
      referencedTable: $db.mangas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MangasTableAnnotationComposer(
            $db: $db,
            $table: $db.mangas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LibraryEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LibraryEntriesTable,
          LibraryEntry,
          $$LibraryEntriesTableFilterComposer,
          $$LibraryEntriesTableOrderingComposer,
          $$LibraryEntriesTableAnnotationComposer,
          $$LibraryEntriesTableCreateCompanionBuilder,
          $$LibraryEntriesTableUpdateCompanionBuilder,
          (LibraryEntry, $$LibraryEntriesTableReferences),
          LibraryEntry,
          PrefetchHooks Function({bool mangaId})
        > {
  $$LibraryEntriesTableTableManager(
    _$AppDatabase db,
    $LibraryEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LibraryEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LibraryEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LibraryEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> mangaId = const Value.absent(),
                Value<String> listType = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<DateTime?> lastOpened = const Value.absent(),
              }) => LibraryEntriesCompanion(
                id: id,
                mangaId: mangaId,
                listType: listType,
                addedAt: addedAt,
                lastOpened: lastOpened,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String mangaId,
                required String listType,
                Value<DateTime> addedAt = const Value.absent(),
                Value<DateTime?> lastOpened = const Value.absent(),
              }) => LibraryEntriesCompanion.insert(
                id: id,
                mangaId: mangaId,
                listType: listType,
                addedAt: addedAt,
                lastOpened: lastOpened,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LibraryEntriesTable, LibraryEntry>(table),
                  $$LibraryEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mangaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (mangaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.mangaId,
                                referencedTable: $$LibraryEntriesTableReferences
                                    ._mangaIdTable(db),
                                referencedColumn:
                                    $$LibraryEntriesTableReferences
                                        ._mangaIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LibraryEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LibraryEntriesTable,
      LibraryEntry,
      $$LibraryEntriesTableFilterComposer,
      $$LibraryEntriesTableOrderingComposer,
      $$LibraryEntriesTableAnnotationComposer,
      $$LibraryEntriesTableCreateCompanionBuilder,
      $$LibraryEntriesTableUpdateCompanionBuilder,
      (LibraryEntry, $$LibraryEntriesTableReferences),
      LibraryEntry,
      PrefetchHooks Function({bool mangaId})
    >;
typedef $$ReadingHistoryTableCreateCompanionBuilder =
    ReadingHistoryCompanion Function({
      Value<int> id,
      required String mangaId,
      required String chapterId,
      Value<int> page,
      Value<DateTime> readAt,
    });
typedef $$ReadingHistoryTableUpdateCompanionBuilder =
    ReadingHistoryCompanion Function({
      Value<int> id,
      Value<String> mangaId,
      Value<String> chapterId,
      Value<int> page,
      Value<DateTime> readAt,
    });

final class $$ReadingHistoryTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ReadingHistoryTable,
          ReadingHistoryData
        > {
  $$ReadingHistoryTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MangasTable _mangaIdTable(_$AppDatabase db) =>
      db.mangas.createAlias('reading_history__manga_id__mangas__id');

  $$MangasTableProcessedTableManager get mangaId {
    final $_column = $_itemColumn<String>('manga_id')!;

    final manager = $$MangasTableTableManager(
      $_db,
      $_db.mangas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mangaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ChaptersTable _chapterIdTable(_$AppDatabase db) =>
      db.chapters.createAlias('reading_history__chapter_id__chapters__id');

  $$ChaptersTableProcessedTableManager get chapterId {
    final $_column = $_itemColumn<String>('chapter_id')!;

    final manager = $$ChaptersTableTableManager(
      $_db,
      $_db.chapters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chapterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReadingHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingHistoryTable> {
  $$ReadingHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MangasTableFilterComposer get mangaId {
    final $$MangasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mangaId,
      referencedTable: $db.mangas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MangasTableFilterComposer(
            $db: $db,
            $table: $db.mangas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChaptersTableFilterComposer get chapterId {
    final $$ChaptersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableFilterComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingHistoryTable> {
  $$ReadingHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MangasTableOrderingComposer get mangaId {
    final $$MangasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mangaId,
      referencedTable: $db.mangas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MangasTableOrderingComposer(
            $db: $db,
            $table: $db.mangas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChaptersTableOrderingComposer get chapterId {
    final $$ChaptersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableOrderingComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingHistoryTable> {
  $$ReadingHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get page =>
      $composableBuilder(column: $table.page, builder: (column) => column);

  GeneratedColumn<DateTime> get readAt =>
      $composableBuilder(column: $table.readAt, builder: (column) => column);

  $$MangasTableAnnotationComposer get mangaId {
    final $$MangasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mangaId,
      referencedTable: $db.mangas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MangasTableAnnotationComposer(
            $db: $db,
            $table: $db.mangas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChaptersTableAnnotationComposer get chapterId {
    final $$ChaptersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableAnnotationComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadingHistoryTable,
          ReadingHistoryData,
          $$ReadingHistoryTableFilterComposer,
          $$ReadingHistoryTableOrderingComposer,
          $$ReadingHistoryTableAnnotationComposer,
          $$ReadingHistoryTableCreateCompanionBuilder,
          $$ReadingHistoryTableUpdateCompanionBuilder,
          (ReadingHistoryData, $$ReadingHistoryTableReferences),
          ReadingHistoryData,
          PrefetchHooks Function({bool mangaId, bool chapterId})
        > {
  $$ReadingHistoryTableTableManager(
    _$AppDatabase db,
    $ReadingHistoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> mangaId = const Value.absent(),
                Value<String> chapterId = const Value.absent(),
                Value<int> page = const Value.absent(),
                Value<DateTime> readAt = const Value.absent(),
              }) => ReadingHistoryCompanion(
                id: id,
                mangaId: mangaId,
                chapterId: chapterId,
                page: page,
                readAt: readAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String mangaId,
                required String chapterId,
                Value<int> page = const Value.absent(),
                Value<DateTime> readAt = const Value.absent(),
              }) => ReadingHistoryCompanion.insert(
                id: id,
                mangaId: mangaId,
                chapterId: chapterId,
                page: page,
                readAt: readAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReadingHistoryTable, ReadingHistoryData>(table),
                  $$ReadingHistoryTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mangaId = false, chapterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (mangaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.mangaId,
                                referencedTable: $$ReadingHistoryTableReferences
                                    ._mangaIdTable(db),
                                referencedColumn:
                                    $$ReadingHistoryTableReferences
                                        ._mangaIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (chapterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.chapterId,
                                referencedTable: $$ReadingHistoryTableReferences
                                    ._chapterIdTable(db),
                                referencedColumn:
                                    $$ReadingHistoryTableReferences
                                        ._chapterIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReadingHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadingHistoryTable,
      ReadingHistoryData,
      $$ReadingHistoryTableFilterComposer,
      $$ReadingHistoryTableOrderingComposer,
      $$ReadingHistoryTableAnnotationComposer,
      $$ReadingHistoryTableCreateCompanionBuilder,
      $$ReadingHistoryTableUpdateCompanionBuilder,
      (ReadingHistoryData, $$ReadingHistoryTableReferences),
      ReadingHistoryData,
      PrefetchHooks Function({bool mangaId, bool chapterId})
    >;
typedef $$DownloadsTableCreateCompanionBuilder =
    DownloadsCompanion Function({
      Value<int> id,
      required String mangaId,
      required String chapterId,
      Value<String> status,
      Value<int> totalPages,
      Value<int> donePages,
      Value<int> sizeBytes,
      Value<String?> localPath,
    });
typedef $$DownloadsTableUpdateCompanionBuilder =
    DownloadsCompanion Function({
      Value<int> id,
      Value<String> mangaId,
      Value<String> chapterId,
      Value<String> status,
      Value<int> totalPages,
      Value<int> donePages,
      Value<int> sizeBytes,
      Value<String?> localPath,
    });

final class $$DownloadsTableReferences
    extends BaseReferences<_$AppDatabase, $DownloadsTable, Download> {
  $$DownloadsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MangasTable _mangaIdTable(_$AppDatabase db) =>
      db.mangas.createAlias('downloads__manga_id__mangas__id');

  $$MangasTableProcessedTableManager get mangaId {
    final $_column = $_itemColumn<String>('manga_id')!;

    final manager = $$MangasTableTableManager(
      $_db,
      $_db.mangas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mangaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ChaptersTable _chapterIdTable(_$AppDatabase db) =>
      db.chapters.createAlias('downloads__chapter_id__chapters__id');

  $$ChaptersTableProcessedTableManager get chapterId {
    final $_column = $_itemColumn<String>('chapter_id')!;

    final manager = $$ChaptersTableTableManager(
      $_db,
      $_db.chapters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chapterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DownloadsTableFilterComposer
    extends Composer<_$AppDatabase, $DownloadsTable> {
  $$DownloadsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalPages => $composableBuilder(
    column: $table.totalPages,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get donePages => $composableBuilder(
    column: $table.donePages,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  $$MangasTableFilterComposer get mangaId {
    final $$MangasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mangaId,
      referencedTable: $db.mangas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MangasTableFilterComposer(
            $db: $db,
            $table: $db.mangas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChaptersTableFilterComposer get chapterId {
    final $$ChaptersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableFilterComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DownloadsTableOrderingComposer
    extends Composer<_$AppDatabase, $DownloadsTable> {
  $$DownloadsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalPages => $composableBuilder(
    column: $table.totalPages,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get donePages => $composableBuilder(
    column: $table.donePages,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  $$MangasTableOrderingComposer get mangaId {
    final $$MangasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mangaId,
      referencedTable: $db.mangas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MangasTableOrderingComposer(
            $db: $db,
            $table: $db.mangas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChaptersTableOrderingComposer get chapterId {
    final $$ChaptersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableOrderingComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DownloadsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DownloadsTable> {
  $$DownloadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get totalPages => $composableBuilder(
    column: $table.totalPages,
    builder: (column) => column,
  );

  GeneratedColumn<int> get donePages =>
      $composableBuilder(column: $table.donePages, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  $$MangasTableAnnotationComposer get mangaId {
    final $$MangasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mangaId,
      referencedTable: $db.mangas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MangasTableAnnotationComposer(
            $db: $db,
            $table: $db.mangas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChaptersTableAnnotationComposer get chapterId {
    final $$ChaptersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableAnnotationComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DownloadsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DownloadsTable,
          Download,
          $$DownloadsTableFilterComposer,
          $$DownloadsTableOrderingComposer,
          $$DownloadsTableAnnotationComposer,
          $$DownloadsTableCreateCompanionBuilder,
          $$DownloadsTableUpdateCompanionBuilder,
          (Download, $$DownloadsTableReferences),
          Download,
          PrefetchHooks Function({bool mangaId, bool chapterId})
        > {
  $$DownloadsTableTableManager(_$AppDatabase db, $DownloadsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DownloadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DownloadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DownloadsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> mangaId = const Value.absent(),
                Value<String> chapterId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> totalPages = const Value.absent(),
                Value<int> donePages = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<String?> localPath = const Value.absent(),
              }) => DownloadsCompanion(
                id: id,
                mangaId: mangaId,
                chapterId: chapterId,
                status: status,
                totalPages: totalPages,
                donePages: donePages,
                sizeBytes: sizeBytes,
                localPath: localPath,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String mangaId,
                required String chapterId,
                Value<String> status = const Value.absent(),
                Value<int> totalPages = const Value.absent(),
                Value<int> donePages = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<String?> localPath = const Value.absent(),
              }) => DownloadsCompanion.insert(
                id: id,
                mangaId: mangaId,
                chapterId: chapterId,
                status: status,
                totalPages: totalPages,
                donePages: donePages,
                sizeBytes: sizeBytes,
                localPath: localPath,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DownloadsTable, Download>(table),
                  $$DownloadsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mangaId = false, chapterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (mangaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.mangaId,
                                referencedTable: $$DownloadsTableReferences
                                    ._mangaIdTable(db),
                                referencedColumn: $$DownloadsTableReferences
                                    ._mangaIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (chapterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.chapterId,
                                referencedTable: $$DownloadsTableReferences
                                    ._chapterIdTable(db),
                                referencedColumn: $$DownloadsTableReferences
                                    ._chapterIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DownloadsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DownloadsTable,
      Download,
      $$DownloadsTableFilterComposer,
      $$DownloadsTableOrderingComposer,
      $$DownloadsTableAnnotationComposer,
      $$DownloadsTableCreateCompanionBuilder,
      $$DownloadsTableUpdateCompanionBuilder,
      (Download, $$DownloadsTableReferences),
      Download,
      PrefetchHooks Function({bool mangaId, bool chapterId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String> theme,
      Value<String> chapterLang,
      Value<bool> adultFilter,
      Value<bool> dataSaver,
      Value<String> readDirection,
      Value<double?> brightness,
      Value<String> source,
      Value<String> recentSearches,
      Value<double> autoScrollSpeed,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String> theme,
      Value<String> chapterLang,
      Value<bool> adultFilter,
      Value<bool> dataSaver,
      Value<String> readDirection,
      Value<double?> brightness,
      Value<String> source,
      Value<String> recentSearches,
      Value<double> autoScrollSpeed,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chapterLang => $composableBuilder(
    column: $table.chapterLang,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get adultFilter => $composableBuilder(
    column: $table.adultFilter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dataSaver => $composableBuilder(
    column: $table.dataSaver,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get readDirection => $composableBuilder(
    column: $table.readDirection,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get brightness => $composableBuilder(
    column: $table.brightness,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recentSearches => $composableBuilder(
    column: $table.recentSearches,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get autoScrollSpeed => $composableBuilder(
    column: $table.autoScrollSpeed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chapterLang => $composableBuilder(
    column: $table.chapterLang,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get adultFilter => $composableBuilder(
    column: $table.adultFilter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dataSaver => $composableBuilder(
    column: $table.dataSaver,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get readDirection => $composableBuilder(
    column: $table.readDirection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get brightness => $composableBuilder(
    column: $table.brightness,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recentSearches => $composableBuilder(
    column: $table.recentSearches,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get autoScrollSpeed => $composableBuilder(
    column: $table.autoScrollSpeed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get theme =>
      $composableBuilder(column: $table.theme, builder: (column) => column);

  GeneratedColumn<String> get chapterLang => $composableBuilder(
    column: $table.chapterLang,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get adultFilter => $composableBuilder(
    column: $table.adultFilter,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get dataSaver =>
      $composableBuilder(column: $table.dataSaver, builder: (column) => column);

  GeneratedColumn<String> get readDirection => $composableBuilder(
    column: $table.readDirection,
    builder: (column) => column,
  );

  GeneratedColumn<double> get brightness => $composableBuilder(
    column: $table.brightness,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get recentSearches => $composableBuilder(
    column: $table.recentSearches,
    builder: (column) => column,
  );

  GeneratedColumn<double> get autoScrollSpeed => $composableBuilder(
    column: $table.autoScrollSpeed,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> theme = const Value.absent(),
                Value<String> chapterLang = const Value.absent(),
                Value<bool> adultFilter = const Value.absent(),
                Value<bool> dataSaver = const Value.absent(),
                Value<String> readDirection = const Value.absent(),
                Value<double?> brightness = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> recentSearches = const Value.absent(),
                Value<double> autoScrollSpeed = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                theme: theme,
                chapterLang: chapterLang,
                adultFilter: adultFilter,
                dataSaver: dataSaver,
                readDirection: readDirection,
                brightness: brightness,
                source: source,
                recentSearches: recentSearches,
                autoScrollSpeed: autoScrollSpeed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> theme = const Value.absent(),
                Value<String> chapterLang = const Value.absent(),
                Value<bool> adultFilter = const Value.absent(),
                Value<bool> dataSaver = const Value.absent(),
                Value<String> readDirection = const Value.absent(),
                Value<double?> brightness = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> recentSearches = const Value.absent(),
                Value<double> autoScrollSpeed = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                theme: theme,
                chapterLang: chapterLang,
                adultFilter: adultFilter,
                dataSaver: dataSaver,
                readDirection: readDirection,
                brightness: brightness,
                source: source,
                recentSearches: recentSearches,
                autoScrollSpeed: autoScrollSpeed,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSetting>(table),
                  BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MangasTableTableManager get mangas =>
      $$MangasTableTableManager(_db, _db.mangas);
  $$ChaptersTableTableManager get chapters =>
      $$ChaptersTableTableManager(_db, _db.chapters);
  $$LibraryEntriesTableTableManager get libraryEntries =>
      $$LibraryEntriesTableTableManager(_db, _db.libraryEntries);
  $$ReadingHistoryTableTableManager get readingHistory =>
      $$ReadingHistoryTableTableManager(_db, _db.readingHistory);
  $$DownloadsTableTableManager get downloads =>
      $$DownloadsTableTableManager(_db, _db.downloads);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
