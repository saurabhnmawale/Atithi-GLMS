// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $EventsTable extends Events with TableInfo<$EventsTable, Event> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _isArchivedMeta =
      const VerificationMeta('isArchived');
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, type, startDate, endDate, createdAt, isArchived];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(Insertable<Event> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('is_archived')) {
      context.handle(
          _isArchivedMeta,
          isArchived.isAcceptableOrUnknown(
              data['is_archived']!, _isArchivedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Event map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Event(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
    );
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(attachedDatabase, alias);
  }
}

class Event extends DataClass implements Insertable<Event> {
  final int id;
  final String name;
  final String type;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final bool isArchived;
  const Event(
      {required this.id,
      required this.name,
      required this.type,
      required this.startDate,
      required this.endDate,
      required this.createdAt,
      required this.isArchived});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      startDate: Value(startDate),
      endDate: Value(endDate),
      createdAt: Value(createdAt),
      isArchived: Value(isArchived),
    );
  }

  factory Event.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Event(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  Event copyWith(
          {int? id,
          String? name,
          String? type,
          DateTime? startDate,
          DateTime? endDate,
          DateTime? createdAt,
          bool? isArchived}) =>
      Event(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        createdAt: createdAt ?? this.createdAt,
        isArchived: isArchived ?? this.isArchived,
      );
  Event copyWithCompanion(EventsCompanion data) {
    return Event(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Event(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, type, startDate, endDate, createdAt, isArchived);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.createdAt == this.createdAt &&
          other.isArchived == this.isArchived);
}

class EventsCompanion extends UpdateCompanion<Event> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> type;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<DateTime> createdAt;
  final Value<bool> isArchived;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isArchived = const Value.absent(),
  });
  EventsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String type,
    required DateTime startDate,
    required DateTime endDate,
    this.createdAt = const Value.absent(),
    this.isArchived = const Value.absent(),
  })  : name = Value(name),
        type = Value(type),
        startDate = Value(startDate),
        endDate = Value(endDate);
  static Insertable<Event> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<DateTime>? createdAt,
    Expression<bool>? isArchived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (createdAt != null) 'created_at': createdAt,
      if (isArchived != null) 'is_archived': isArchived,
    });
  }

  EventsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? type,
      Value<DateTime>? startDate,
      Value<DateTime>? endDate,
      Value<DateTime>? createdAt,
      Value<bool>? isArchived}) {
    return EventsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }
}

class $HotelsTable extends Hotels with TableInfo<$HotelsTable, Hotel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HotelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _eventIdMeta =
      const VerificationMeta('eventId');
  @override
  late final GeneratedColumn<int> eventId = GeneratedColumn<int>(
      'event_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES events (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, eventId, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hotels';
  @override
  VerificationContext validateIntegrity(Insertable<Hotel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('event_id')) {
      context.handle(_eventIdMeta,
          eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta));
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Hotel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Hotel(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      eventId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}event_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $HotelsTable createAlias(String alias) {
    return $HotelsTable(attachedDatabase, alias);
  }
}

class Hotel extends DataClass implements Insertable<Hotel> {
  final int id;
  final int eventId;
  final String name;
  const Hotel({required this.id, required this.eventId, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['event_id'] = Variable<int>(eventId);
    map['name'] = Variable<String>(name);
    return map;
  }

  HotelsCompanion toCompanion(bool nullToAbsent) {
    return HotelsCompanion(
      id: Value(id),
      eventId: Value(eventId),
      name: Value(name),
    );
  }

  factory Hotel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Hotel(
      id: serializer.fromJson<int>(json['id']),
      eventId: serializer.fromJson<int>(json['eventId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventId': serializer.toJson<int>(eventId),
      'name': serializer.toJson<String>(name),
    };
  }

  Hotel copyWith({int? id, int? eventId, String? name}) => Hotel(
        id: id ?? this.id,
        eventId: eventId ?? this.eventId,
        name: name ?? this.name,
      );
  Hotel copyWithCompanion(HotelsCompanion data) {
    return Hotel(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Hotel(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, eventId, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Hotel &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.name == this.name);
}

class HotelsCompanion extends UpdateCompanion<Hotel> {
  final Value<int> id;
  final Value<int> eventId;
  final Value<String> name;
  const HotelsCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.name = const Value.absent(),
  });
  HotelsCompanion.insert({
    this.id = const Value.absent(),
    required int eventId,
    required String name,
  })  : eventId = Value(eventId),
        name = Value(name);
  static Insertable<Hotel> custom({
    Expression<int>? id,
    Expression<int>? eventId,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (name != null) 'name': name,
    });
  }

  HotelsCompanion copyWith(
      {Value<int>? id, Value<int>? eventId, Value<String>? name}) {
    return HotelsCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<int>(eventId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HotelsCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $RoomsTable extends Rooms with TableInfo<$RoomsTable, Room> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _hotelIdMeta =
      const VerificationMeta('hotelId');
  @override
  late final GeneratedColumn<int> hotelId = GeneratedColumn<int>(
      'hotel_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES hotels (id)'));
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
      'number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('available'));
  @override
  List<GeneratedColumn> get $columns => [id, hotelId, number, category, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rooms';
  @override
  VerificationContext validateIntegrity(Insertable<Room> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('hotel_id')) {
      context.handle(_hotelIdMeta,
          hotelId.isAcceptableOrUnknown(data['hotel_id']!, _hotelIdMeta));
    } else if (isInserting) {
      context.missing(_hotelIdMeta);
    }
    if (data.containsKey('number')) {
      context.handle(_numberMeta,
          number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Room map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Room(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      hotelId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hotel_id'])!,
      number: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}number'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $RoomsTable createAlias(String alias) {
    return $RoomsTable(attachedDatabase, alias);
  }
}

class Room extends DataClass implements Insertable<Room> {
  final int id;
  final int hotelId;
  final String number;
  final String category;
  final String status;
  const Room(
      {required this.id,
      required this.hotelId,
      required this.number,
      required this.category,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['hotel_id'] = Variable<int>(hotelId);
    map['number'] = Variable<String>(number);
    map['category'] = Variable<String>(category);
    map['status'] = Variable<String>(status);
    return map;
  }

  RoomsCompanion toCompanion(bool nullToAbsent) {
    return RoomsCompanion(
      id: Value(id),
      hotelId: Value(hotelId),
      number: Value(number),
      category: Value(category),
      status: Value(status),
    );
  }

  factory Room.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Room(
      id: serializer.fromJson<int>(json['id']),
      hotelId: serializer.fromJson<int>(json['hotelId']),
      number: serializer.fromJson<String>(json['number']),
      category: serializer.fromJson<String>(json['category']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'hotelId': serializer.toJson<int>(hotelId),
      'number': serializer.toJson<String>(number),
      'category': serializer.toJson<String>(category),
      'status': serializer.toJson<String>(status),
    };
  }

  Room copyWith(
          {int? id,
          int? hotelId,
          String? number,
          String? category,
          String? status}) =>
      Room(
        id: id ?? this.id,
        hotelId: hotelId ?? this.hotelId,
        number: number ?? this.number,
        category: category ?? this.category,
        status: status ?? this.status,
      );
  Room copyWithCompanion(RoomsCompanion data) {
    return Room(
      id: data.id.present ? data.id.value : this.id,
      hotelId: data.hotelId.present ? data.hotelId.value : this.hotelId,
      number: data.number.present ? data.number.value : this.number,
      category: data.category.present ? data.category.value : this.category,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Room(')
          ..write('id: $id, ')
          ..write('hotelId: $hotelId, ')
          ..write('number: $number, ')
          ..write('category: $category, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, hotelId, number, category, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Room &&
          other.id == this.id &&
          other.hotelId == this.hotelId &&
          other.number == this.number &&
          other.category == this.category &&
          other.status == this.status);
}

class RoomsCompanion extends UpdateCompanion<Room> {
  final Value<int> id;
  final Value<int> hotelId;
  final Value<String> number;
  final Value<String> category;
  final Value<String> status;
  const RoomsCompanion({
    this.id = const Value.absent(),
    this.hotelId = const Value.absent(),
    this.number = const Value.absent(),
    this.category = const Value.absent(),
    this.status = const Value.absent(),
  });
  RoomsCompanion.insert({
    this.id = const Value.absent(),
    required int hotelId,
    required String number,
    required String category,
    this.status = const Value.absent(),
  })  : hotelId = Value(hotelId),
        number = Value(number),
        category = Value(category);
  static Insertable<Room> custom({
    Expression<int>? id,
    Expression<int>? hotelId,
    Expression<String>? number,
    Expression<String>? category,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hotelId != null) 'hotel_id': hotelId,
      if (number != null) 'number': number,
      if (category != null) 'category': category,
      if (status != null) 'status': status,
    });
  }

  RoomsCompanion copyWith(
      {Value<int>? id,
      Value<int>? hotelId,
      Value<String>? number,
      Value<String>? category,
      Value<String>? status}) {
    return RoomsCompanion(
      id: id ?? this.id,
      hotelId: hotelId ?? this.hotelId,
      number: number ?? this.number,
      category: category ?? this.category,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (hotelId.present) {
      map['hotel_id'] = Variable<int>(hotelId.value);
    }
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoomsCompanion(')
          ..write('id: $id, ')
          ..write('hotelId: $hotelId, ')
          ..write('number: $number, ')
          ..write('category: $category, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $GuestsTable extends Guests with TableInfo<$GuestsTable, Guest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GuestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _eventIdMeta =
      const VerificationMeta('eventId');
  @override
  late final GeneratedColumn<int> eventId = GeneratedColumn<int>(
      'event_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES events (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _assignedCategoryMeta =
      const VerificationMeta('assignedCategory');
  @override
  late final GeneratedColumn<String> assignedCategory = GeneratedColumn<String>(
      'assigned_category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isVipMeta = const VerificationMeta('isVip');
  @override
  late final GeneratedColumn<bool> isVip = GeneratedColumn<bool>(
      'is_vip', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_vip" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isCloseRelativeMeta =
      const VerificationMeta('isCloseRelative');
  @override
  late final GeneratedColumn<bool> isCloseRelative = GeneratedColumn<bool>(
      'is_close_relative', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_close_relative" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _specialRequestsMeta =
      const VerificationMeta('specialRequests');
  @override
  late final GeneratedColumn<String> specialRequests = GeneratedColumn<String>(
      'special_requests', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('not_checked_in'));
  static const VerificationMeta _currentHotelIdMeta =
      const VerificationMeta('currentHotelId');
  @override
  late final GeneratedColumn<int> currentHotelId = GeneratedColumn<int>(
      'current_hotel_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES hotels (id)'));
  static const VerificationMeta _currentRoomIdMeta =
      const VerificationMeta('currentRoomId');
  @override
  late final GeneratedColumn<int> currentRoomId = GeneratedColumn<int>(
      'current_room_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES rooms (id)'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        eventId,
        name,
        assignedCategory,
        isVip,
        isCloseRelative,
        specialRequests,
        status,
        currentHotelId,
        currentRoomId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'guests';
  @override
  VerificationContext validateIntegrity(Insertable<Guest> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('event_id')) {
      context.handle(_eventIdMeta,
          eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta));
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('assigned_category')) {
      context.handle(
          _assignedCategoryMeta,
          assignedCategory.isAcceptableOrUnknown(
              data['assigned_category']!, _assignedCategoryMeta));
    } else if (isInserting) {
      context.missing(_assignedCategoryMeta);
    }
    if (data.containsKey('is_vip')) {
      context.handle(
          _isVipMeta, isVip.isAcceptableOrUnknown(data['is_vip']!, _isVipMeta));
    }
    if (data.containsKey('is_close_relative')) {
      context.handle(
          _isCloseRelativeMeta,
          isCloseRelative.isAcceptableOrUnknown(
              data['is_close_relative']!, _isCloseRelativeMeta));
    }
    if (data.containsKey('special_requests')) {
      context.handle(
          _specialRequestsMeta,
          specialRequests.isAcceptableOrUnknown(
              data['special_requests']!, _specialRequestsMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('current_hotel_id')) {
      context.handle(
          _currentHotelIdMeta,
          currentHotelId.isAcceptableOrUnknown(
              data['current_hotel_id']!, _currentHotelIdMeta));
    }
    if (data.containsKey('current_room_id')) {
      context.handle(
          _currentRoomIdMeta,
          currentRoomId.isAcceptableOrUnknown(
              data['current_room_id']!, _currentRoomIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Guest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Guest(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      eventId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}event_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      assignedCategory: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}assigned_category'])!,
      isVip: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_vip'])!,
      isCloseRelative: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}is_close_relative'])!,
      specialRequests: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}special_requests']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      currentHotelId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_hotel_id']),
      currentRoomId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_room_id']),
    );
  }

  @override
  $GuestsTable createAlias(String alias) {
    return $GuestsTable(attachedDatabase, alias);
  }
}

class Guest extends DataClass implements Insertable<Guest> {
  final int id;
  final int eventId;
  final String name;
  final String assignedCategory;
  final bool isVip;
  final bool isCloseRelative;
  final String? specialRequests;
  final String status;
  final int? currentHotelId;
  final int? currentRoomId;
  const Guest(
      {required this.id,
      required this.eventId,
      required this.name,
      required this.assignedCategory,
      required this.isVip,
      required this.isCloseRelative,
      this.specialRequests,
      required this.status,
      this.currentHotelId,
      this.currentRoomId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['event_id'] = Variable<int>(eventId);
    map['name'] = Variable<String>(name);
    map['assigned_category'] = Variable<String>(assignedCategory);
    map['is_vip'] = Variable<bool>(isVip);
    map['is_close_relative'] = Variable<bool>(isCloseRelative);
    if (!nullToAbsent || specialRequests != null) {
      map['special_requests'] = Variable<String>(specialRequests);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || currentHotelId != null) {
      map['current_hotel_id'] = Variable<int>(currentHotelId);
    }
    if (!nullToAbsent || currentRoomId != null) {
      map['current_room_id'] = Variable<int>(currentRoomId);
    }
    return map;
  }

  GuestsCompanion toCompanion(bool nullToAbsent) {
    return GuestsCompanion(
      id: Value(id),
      eventId: Value(eventId),
      name: Value(name),
      assignedCategory: Value(assignedCategory),
      isVip: Value(isVip),
      isCloseRelative: Value(isCloseRelative),
      specialRequests: specialRequests == null && nullToAbsent
          ? const Value.absent()
          : Value(specialRequests),
      status: Value(status),
      currentHotelId: currentHotelId == null && nullToAbsent
          ? const Value.absent()
          : Value(currentHotelId),
      currentRoomId: currentRoomId == null && nullToAbsent
          ? const Value.absent()
          : Value(currentRoomId),
    );
  }

  factory Guest.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Guest(
      id: serializer.fromJson<int>(json['id']),
      eventId: serializer.fromJson<int>(json['eventId']),
      name: serializer.fromJson<String>(json['name']),
      assignedCategory: serializer.fromJson<String>(json['assignedCategory']),
      isVip: serializer.fromJson<bool>(json['isVip']),
      isCloseRelative: serializer.fromJson<bool>(json['isCloseRelative']),
      specialRequests: serializer.fromJson<String?>(json['specialRequests']),
      status: serializer.fromJson<String>(json['status']),
      currentHotelId: serializer.fromJson<int?>(json['currentHotelId']),
      currentRoomId: serializer.fromJson<int?>(json['currentRoomId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventId': serializer.toJson<int>(eventId),
      'name': serializer.toJson<String>(name),
      'assignedCategory': serializer.toJson<String>(assignedCategory),
      'isVip': serializer.toJson<bool>(isVip),
      'isCloseRelative': serializer.toJson<bool>(isCloseRelative),
      'specialRequests': serializer.toJson<String?>(specialRequests),
      'status': serializer.toJson<String>(status),
      'currentHotelId': serializer.toJson<int?>(currentHotelId),
      'currentRoomId': serializer.toJson<int?>(currentRoomId),
    };
  }

  Guest copyWith(
          {int? id,
          int? eventId,
          String? name,
          String? assignedCategory,
          bool? isVip,
          bool? isCloseRelative,
          Value<String?> specialRequests = const Value.absent(),
          String? status,
          Value<int?> currentHotelId = const Value.absent(),
          Value<int?> currentRoomId = const Value.absent()}) =>
      Guest(
        id: id ?? this.id,
        eventId: eventId ?? this.eventId,
        name: name ?? this.name,
        assignedCategory: assignedCategory ?? this.assignedCategory,
        isVip: isVip ?? this.isVip,
        isCloseRelative: isCloseRelative ?? this.isCloseRelative,
        specialRequests: specialRequests.present
            ? specialRequests.value
            : this.specialRequests,
        status: status ?? this.status,
        currentHotelId:
            currentHotelId.present ? currentHotelId.value : this.currentHotelId,
        currentRoomId:
            currentRoomId.present ? currentRoomId.value : this.currentRoomId,
      );
  Guest copyWithCompanion(GuestsCompanion data) {
    return Guest(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      name: data.name.present ? data.name.value : this.name,
      assignedCategory: data.assignedCategory.present
          ? data.assignedCategory.value
          : this.assignedCategory,
      isVip: data.isVip.present ? data.isVip.value : this.isVip,
      isCloseRelative: data.isCloseRelative.present
          ? data.isCloseRelative.value
          : this.isCloseRelative,
      specialRequests: data.specialRequests.present
          ? data.specialRequests.value
          : this.specialRequests,
      status: data.status.present ? data.status.value : this.status,
      currentHotelId: data.currentHotelId.present
          ? data.currentHotelId.value
          : this.currentHotelId,
      currentRoomId: data.currentRoomId.present
          ? data.currentRoomId.value
          : this.currentRoomId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Guest(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('name: $name, ')
          ..write('assignedCategory: $assignedCategory, ')
          ..write('isVip: $isVip, ')
          ..write('isCloseRelative: $isCloseRelative, ')
          ..write('specialRequests: $specialRequests, ')
          ..write('status: $status, ')
          ..write('currentHotelId: $currentHotelId, ')
          ..write('currentRoomId: $currentRoomId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, eventId, name, assignedCategory, isVip,
      isCloseRelative, specialRequests, status, currentHotelId, currentRoomId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Guest &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.name == this.name &&
          other.assignedCategory == this.assignedCategory &&
          other.isVip == this.isVip &&
          other.isCloseRelative == this.isCloseRelative &&
          other.specialRequests == this.specialRequests &&
          other.status == this.status &&
          other.currentHotelId == this.currentHotelId &&
          other.currentRoomId == this.currentRoomId);
}

class GuestsCompanion extends UpdateCompanion<Guest> {
  final Value<int> id;
  final Value<int> eventId;
  final Value<String> name;
  final Value<String> assignedCategory;
  final Value<bool> isVip;
  final Value<bool> isCloseRelative;
  final Value<String?> specialRequests;
  final Value<String> status;
  final Value<int?> currentHotelId;
  final Value<int?> currentRoomId;
  const GuestsCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.name = const Value.absent(),
    this.assignedCategory = const Value.absent(),
    this.isVip = const Value.absent(),
    this.isCloseRelative = const Value.absent(),
    this.specialRequests = const Value.absent(),
    this.status = const Value.absent(),
    this.currentHotelId = const Value.absent(),
    this.currentRoomId = const Value.absent(),
  });
  GuestsCompanion.insert({
    this.id = const Value.absent(),
    required int eventId,
    required String name,
    required String assignedCategory,
    this.isVip = const Value.absent(),
    this.isCloseRelative = const Value.absent(),
    this.specialRequests = const Value.absent(),
    this.status = const Value.absent(),
    this.currentHotelId = const Value.absent(),
    this.currentRoomId = const Value.absent(),
  })  : eventId = Value(eventId),
        name = Value(name),
        assignedCategory = Value(assignedCategory);
  static Insertable<Guest> custom({
    Expression<int>? id,
    Expression<int>? eventId,
    Expression<String>? name,
    Expression<String>? assignedCategory,
    Expression<bool>? isVip,
    Expression<bool>? isCloseRelative,
    Expression<String>? specialRequests,
    Expression<String>? status,
    Expression<int>? currentHotelId,
    Expression<int>? currentRoomId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (name != null) 'name': name,
      if (assignedCategory != null) 'assigned_category': assignedCategory,
      if (isVip != null) 'is_vip': isVip,
      if (isCloseRelative != null) 'is_close_relative': isCloseRelative,
      if (specialRequests != null) 'special_requests': specialRequests,
      if (status != null) 'status': status,
      if (currentHotelId != null) 'current_hotel_id': currentHotelId,
      if (currentRoomId != null) 'current_room_id': currentRoomId,
    });
  }

  GuestsCompanion copyWith(
      {Value<int>? id,
      Value<int>? eventId,
      Value<String>? name,
      Value<String>? assignedCategory,
      Value<bool>? isVip,
      Value<bool>? isCloseRelative,
      Value<String?>? specialRequests,
      Value<String>? status,
      Value<int?>? currentHotelId,
      Value<int?>? currentRoomId}) {
    return GuestsCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      name: name ?? this.name,
      assignedCategory: assignedCategory ?? this.assignedCategory,
      isVip: isVip ?? this.isVip,
      isCloseRelative: isCloseRelative ?? this.isCloseRelative,
      specialRequests: specialRequests ?? this.specialRequests,
      status: status ?? this.status,
      currentHotelId: currentHotelId ?? this.currentHotelId,
      currentRoomId: currentRoomId ?? this.currentRoomId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<int>(eventId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (assignedCategory.present) {
      map['assigned_category'] = Variable<String>(assignedCategory.value);
    }
    if (isVip.present) {
      map['is_vip'] = Variable<bool>(isVip.value);
    }
    if (isCloseRelative.present) {
      map['is_close_relative'] = Variable<bool>(isCloseRelative.value);
    }
    if (specialRequests.present) {
      map['special_requests'] = Variable<String>(specialRequests.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (currentHotelId.present) {
      map['current_hotel_id'] = Variable<int>(currentHotelId.value);
    }
    if (currentRoomId.present) {
      map['current_room_id'] = Variable<int>(currentRoomId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GuestsCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('name: $name, ')
          ..write('assignedCategory: $assignedCategory, ')
          ..write('isVip: $isVip, ')
          ..write('isCloseRelative: $isCloseRelative, ')
          ..write('specialRequests: $specialRequests, ')
          ..write('status: $status, ')
          ..write('currentHotelId: $currentHotelId, ')
          ..write('currentRoomId: $currentRoomId')
          ..write(')'))
        .toString();
  }
}

class $StaySegmentsTable extends StaySegments
    with TableInfo<$StaySegmentsTable, StaySegment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StaySegmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _guestIdMeta =
      const VerificationMeta('guestId');
  @override
  late final GeneratedColumn<int> guestId = GeneratedColumn<int>(
      'guest_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES guests (id)'));
  static const VerificationMeta _hotelIdMeta =
      const VerificationMeta('hotelId');
  @override
  late final GeneratedColumn<int> hotelId = GeneratedColumn<int>(
      'hotel_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES hotels (id)'));
  static const VerificationMeta _roomIdMeta = const VerificationMeta('roomId');
  @override
  late final GeneratedColumn<int> roomId = GeneratedColumn<int>(
      'room_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES rooms (id)'));
  static const VerificationMeta _checkInAtMeta =
      const VerificationMeta('checkInAt');
  @override
  late final GeneratedColumn<DateTime> checkInAt = GeneratedColumn<DateTime>(
      'check_in_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _checkOutAtMeta =
      const VerificationMeta('checkOutAt');
  @override
  late final GeneratedColumn<DateTime> checkOutAt = GeneratedColumn<DateTime>(
      'check_out_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, guestId, hotelId, roomId, checkInAt, checkOutAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stay_segments';
  @override
  VerificationContext validateIntegrity(Insertable<StaySegment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('guest_id')) {
      context.handle(_guestIdMeta,
          guestId.isAcceptableOrUnknown(data['guest_id']!, _guestIdMeta));
    } else if (isInserting) {
      context.missing(_guestIdMeta);
    }
    if (data.containsKey('hotel_id')) {
      context.handle(_hotelIdMeta,
          hotelId.isAcceptableOrUnknown(data['hotel_id']!, _hotelIdMeta));
    } else if (isInserting) {
      context.missing(_hotelIdMeta);
    }
    if (data.containsKey('room_id')) {
      context.handle(_roomIdMeta,
          roomId.isAcceptableOrUnknown(data['room_id']!, _roomIdMeta));
    } else if (isInserting) {
      context.missing(_roomIdMeta);
    }
    if (data.containsKey('check_in_at')) {
      context.handle(
          _checkInAtMeta,
          checkInAt.isAcceptableOrUnknown(
              data['check_in_at']!, _checkInAtMeta));
    } else if (isInserting) {
      context.missing(_checkInAtMeta);
    }
    if (data.containsKey('check_out_at')) {
      context.handle(
          _checkOutAtMeta,
          checkOutAt.isAcceptableOrUnknown(
              data['check_out_at']!, _checkOutAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StaySegment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StaySegment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      guestId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}guest_id'])!,
      hotelId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hotel_id'])!,
      roomId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}room_id'])!,
      checkInAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}check_in_at'])!,
      checkOutAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}check_out_at']),
    );
  }

  @override
  $StaySegmentsTable createAlias(String alias) {
    return $StaySegmentsTable(attachedDatabase, alias);
  }
}

class StaySegment extends DataClass implements Insertable<StaySegment> {
  final int id;
  final int guestId;
  final int hotelId;
  final int roomId;
  final DateTime checkInAt;
  final DateTime? checkOutAt;
  const StaySegment(
      {required this.id,
      required this.guestId,
      required this.hotelId,
      required this.roomId,
      required this.checkInAt,
      this.checkOutAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['guest_id'] = Variable<int>(guestId);
    map['hotel_id'] = Variable<int>(hotelId);
    map['room_id'] = Variable<int>(roomId);
    map['check_in_at'] = Variable<DateTime>(checkInAt);
    if (!nullToAbsent || checkOutAt != null) {
      map['check_out_at'] = Variable<DateTime>(checkOutAt);
    }
    return map;
  }

  StaySegmentsCompanion toCompanion(bool nullToAbsent) {
    return StaySegmentsCompanion(
      id: Value(id),
      guestId: Value(guestId),
      hotelId: Value(hotelId),
      roomId: Value(roomId),
      checkInAt: Value(checkInAt),
      checkOutAt: checkOutAt == null && nullToAbsent
          ? const Value.absent()
          : Value(checkOutAt),
    );
  }

  factory StaySegment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StaySegment(
      id: serializer.fromJson<int>(json['id']),
      guestId: serializer.fromJson<int>(json['guestId']),
      hotelId: serializer.fromJson<int>(json['hotelId']),
      roomId: serializer.fromJson<int>(json['roomId']),
      checkInAt: serializer.fromJson<DateTime>(json['checkInAt']),
      checkOutAt: serializer.fromJson<DateTime?>(json['checkOutAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'guestId': serializer.toJson<int>(guestId),
      'hotelId': serializer.toJson<int>(hotelId),
      'roomId': serializer.toJson<int>(roomId),
      'checkInAt': serializer.toJson<DateTime>(checkInAt),
      'checkOutAt': serializer.toJson<DateTime?>(checkOutAt),
    };
  }

  StaySegment copyWith(
          {int? id,
          int? guestId,
          int? hotelId,
          int? roomId,
          DateTime? checkInAt,
          Value<DateTime?> checkOutAt = const Value.absent()}) =>
      StaySegment(
        id: id ?? this.id,
        guestId: guestId ?? this.guestId,
        hotelId: hotelId ?? this.hotelId,
        roomId: roomId ?? this.roomId,
        checkInAt: checkInAt ?? this.checkInAt,
        checkOutAt: checkOutAt.present ? checkOutAt.value : this.checkOutAt,
      );
  StaySegment copyWithCompanion(StaySegmentsCompanion data) {
    return StaySegment(
      id: data.id.present ? data.id.value : this.id,
      guestId: data.guestId.present ? data.guestId.value : this.guestId,
      hotelId: data.hotelId.present ? data.hotelId.value : this.hotelId,
      roomId: data.roomId.present ? data.roomId.value : this.roomId,
      checkInAt: data.checkInAt.present ? data.checkInAt.value : this.checkInAt,
      checkOutAt:
          data.checkOutAt.present ? data.checkOutAt.value : this.checkOutAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StaySegment(')
          ..write('id: $id, ')
          ..write('guestId: $guestId, ')
          ..write('hotelId: $hotelId, ')
          ..write('roomId: $roomId, ')
          ..write('checkInAt: $checkInAt, ')
          ..write('checkOutAt: $checkOutAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, guestId, hotelId, roomId, checkInAt, checkOutAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StaySegment &&
          other.id == this.id &&
          other.guestId == this.guestId &&
          other.hotelId == this.hotelId &&
          other.roomId == this.roomId &&
          other.checkInAt == this.checkInAt &&
          other.checkOutAt == this.checkOutAt);
}

class StaySegmentsCompanion extends UpdateCompanion<StaySegment> {
  final Value<int> id;
  final Value<int> guestId;
  final Value<int> hotelId;
  final Value<int> roomId;
  final Value<DateTime> checkInAt;
  final Value<DateTime?> checkOutAt;
  const StaySegmentsCompanion({
    this.id = const Value.absent(),
    this.guestId = const Value.absent(),
    this.hotelId = const Value.absent(),
    this.roomId = const Value.absent(),
    this.checkInAt = const Value.absent(),
    this.checkOutAt = const Value.absent(),
  });
  StaySegmentsCompanion.insert({
    this.id = const Value.absent(),
    required int guestId,
    required int hotelId,
    required int roomId,
    required DateTime checkInAt,
    this.checkOutAt = const Value.absent(),
  })  : guestId = Value(guestId),
        hotelId = Value(hotelId),
        roomId = Value(roomId),
        checkInAt = Value(checkInAt);
  static Insertable<StaySegment> custom({
    Expression<int>? id,
    Expression<int>? guestId,
    Expression<int>? hotelId,
    Expression<int>? roomId,
    Expression<DateTime>? checkInAt,
    Expression<DateTime>? checkOutAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (guestId != null) 'guest_id': guestId,
      if (hotelId != null) 'hotel_id': hotelId,
      if (roomId != null) 'room_id': roomId,
      if (checkInAt != null) 'check_in_at': checkInAt,
      if (checkOutAt != null) 'check_out_at': checkOutAt,
    });
  }

  StaySegmentsCompanion copyWith(
      {Value<int>? id,
      Value<int>? guestId,
      Value<int>? hotelId,
      Value<int>? roomId,
      Value<DateTime>? checkInAt,
      Value<DateTime?>? checkOutAt}) {
    return StaySegmentsCompanion(
      id: id ?? this.id,
      guestId: guestId ?? this.guestId,
      hotelId: hotelId ?? this.hotelId,
      roomId: roomId ?? this.roomId,
      checkInAt: checkInAt ?? this.checkInAt,
      checkOutAt: checkOutAt ?? this.checkOutAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (guestId.present) {
      map['guest_id'] = Variable<int>(guestId.value);
    }
    if (hotelId.present) {
      map['hotel_id'] = Variable<int>(hotelId.value);
    }
    if (roomId.present) {
      map['room_id'] = Variable<int>(roomId.value);
    }
    if (checkInAt.present) {
      map['check_in_at'] = Variable<DateTime>(checkInAt.value);
    }
    if (checkOutAt.present) {
      map['check_out_at'] = Variable<DateTime>(checkOutAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StaySegmentsCompanion(')
          ..write('id: $id, ')
          ..write('guestId: $guestId, ')
          ..write('hotelId: $hotelId, ')
          ..write('roomId: $roomId, ')
          ..write('checkInAt: $checkInAt, ')
          ..write('checkOutAt: $checkOutAt')
          ..write(')'))
        .toString();
  }
}

class $ServiceTypesTable extends ServiceTypes
    with TableInfo<$ServiceTypesTable, ServiceType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _eventIdMeta =
      const VerificationMeta('eventId');
  @override
  late final GeneratedColumn<int> eventId = GeneratedColumn<int>(
      'event_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES events (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, eventId, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_types';
  @override
  VerificationContext validateIntegrity(Insertable<ServiceType> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('event_id')) {
      context.handle(_eventIdMeta,
          eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta));
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServiceType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceType(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      eventId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}event_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $ServiceTypesTable createAlias(String alias) {
    return $ServiceTypesTable(attachedDatabase, alias);
  }
}

class ServiceType extends DataClass implements Insertable<ServiceType> {
  final int id;
  final int eventId;
  final String name;
  const ServiceType(
      {required this.id, required this.eventId, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['event_id'] = Variable<int>(eventId);
    map['name'] = Variable<String>(name);
    return map;
  }

  ServiceTypesCompanion toCompanion(bool nullToAbsent) {
    return ServiceTypesCompanion(
      id: Value(id),
      eventId: Value(eventId),
      name: Value(name),
    );
  }

  factory ServiceType.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceType(
      id: serializer.fromJson<int>(json['id']),
      eventId: serializer.fromJson<int>(json['eventId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventId': serializer.toJson<int>(eventId),
      'name': serializer.toJson<String>(name),
    };
  }

  ServiceType copyWith({int? id, int? eventId, String? name}) => ServiceType(
        id: id ?? this.id,
        eventId: eventId ?? this.eventId,
        name: name ?? this.name,
      );
  ServiceType copyWithCompanion(ServiceTypesCompanion data) {
    return ServiceType(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceType(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, eventId, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceType &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.name == this.name);
}

class ServiceTypesCompanion extends UpdateCompanion<ServiceType> {
  final Value<int> id;
  final Value<int> eventId;
  final Value<String> name;
  const ServiceTypesCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.name = const Value.absent(),
  });
  ServiceTypesCompanion.insert({
    this.id = const Value.absent(),
    required int eventId,
    required String name,
  })  : eventId = Value(eventId),
        name = Value(name);
  static Insertable<ServiceType> custom({
    Expression<int>? id,
    Expression<int>? eventId,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (name != null) 'name': name,
    });
  }

  ServiceTypesCompanion copyWith(
      {Value<int>? id, Value<int>? eventId, Value<String>? name}) {
    return ServiceTypesCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<int>(eventId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceTypesCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $ServiceChargesTable extends ServiceCharges
    with TableInfo<$ServiceChargesTable, ServiceCharge> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceChargesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _guestIdMeta =
      const VerificationMeta('guestId');
  @override
  late final GeneratedColumn<int> guestId = GeneratedColumn<int>(
      'guest_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES guests (id)'));
  static const VerificationMeta _typeIdMeta = const VerificationMeta('typeId');
  @override
  late final GeneratedColumn<int> typeId = GeneratedColumn<int>(
      'type_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES service_types (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _loggedAtMeta =
      const VerificationMeta('loggedAt');
  @override
  late final GeneratedColumn<DateTime> loggedAt = GeneratedColumn<DateTime>(
      'logged_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _isLockedMeta =
      const VerificationMeta('isLocked');
  @override
  late final GeneratedColumn<bool> isLocked = GeneratedColumn<bool>(
      'is_locked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_locked" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, guestId, typeId, amount, loggedAt, isLocked];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_charges';
  @override
  VerificationContext validateIntegrity(Insertable<ServiceCharge> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('guest_id')) {
      context.handle(_guestIdMeta,
          guestId.isAcceptableOrUnknown(data['guest_id']!, _guestIdMeta));
    } else if (isInserting) {
      context.missing(_guestIdMeta);
    }
    if (data.containsKey('type_id')) {
      context.handle(_typeIdMeta,
          typeId.isAcceptableOrUnknown(data['type_id']!, _typeIdMeta));
    } else if (isInserting) {
      context.missing(_typeIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('logged_at')) {
      context.handle(_loggedAtMeta,
          loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta));
    }
    if (data.containsKey('is_locked')) {
      context.handle(_isLockedMeta,
          isLocked.isAcceptableOrUnknown(data['is_locked']!, _isLockedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServiceCharge map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceCharge(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      guestId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}guest_id'])!,
      typeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      loggedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}logged_at'])!,
      isLocked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_locked'])!,
    );
  }

  @override
  $ServiceChargesTable createAlias(String alias) {
    return $ServiceChargesTable(attachedDatabase, alias);
  }
}

class ServiceCharge extends DataClass implements Insertable<ServiceCharge> {
  final int id;
  final int guestId;
  final int typeId;
  final double amount;
  final DateTime loggedAt;
  final bool isLocked;
  const ServiceCharge(
      {required this.id,
      required this.guestId,
      required this.typeId,
      required this.amount,
      required this.loggedAt,
      required this.isLocked});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['guest_id'] = Variable<int>(guestId);
    map['type_id'] = Variable<int>(typeId);
    map['amount'] = Variable<double>(amount);
    map['logged_at'] = Variable<DateTime>(loggedAt);
    map['is_locked'] = Variable<bool>(isLocked);
    return map;
  }

  ServiceChargesCompanion toCompanion(bool nullToAbsent) {
    return ServiceChargesCompanion(
      id: Value(id),
      guestId: Value(guestId),
      typeId: Value(typeId),
      amount: Value(amount),
      loggedAt: Value(loggedAt),
      isLocked: Value(isLocked),
    );
  }

  factory ServiceCharge.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceCharge(
      id: serializer.fromJson<int>(json['id']),
      guestId: serializer.fromJson<int>(json['guestId']),
      typeId: serializer.fromJson<int>(json['typeId']),
      amount: serializer.fromJson<double>(json['amount']),
      loggedAt: serializer.fromJson<DateTime>(json['loggedAt']),
      isLocked: serializer.fromJson<bool>(json['isLocked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'guestId': serializer.toJson<int>(guestId),
      'typeId': serializer.toJson<int>(typeId),
      'amount': serializer.toJson<double>(amount),
      'loggedAt': serializer.toJson<DateTime>(loggedAt),
      'isLocked': serializer.toJson<bool>(isLocked),
    };
  }

  ServiceCharge copyWith(
          {int? id,
          int? guestId,
          int? typeId,
          double? amount,
          DateTime? loggedAt,
          bool? isLocked}) =>
      ServiceCharge(
        id: id ?? this.id,
        guestId: guestId ?? this.guestId,
        typeId: typeId ?? this.typeId,
        amount: amount ?? this.amount,
        loggedAt: loggedAt ?? this.loggedAt,
        isLocked: isLocked ?? this.isLocked,
      );
  ServiceCharge copyWithCompanion(ServiceChargesCompanion data) {
    return ServiceCharge(
      id: data.id.present ? data.id.value : this.id,
      guestId: data.guestId.present ? data.guestId.value : this.guestId,
      typeId: data.typeId.present ? data.typeId.value : this.typeId,
      amount: data.amount.present ? data.amount.value : this.amount,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
      isLocked: data.isLocked.present ? data.isLocked.value : this.isLocked,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceCharge(')
          ..write('id: $id, ')
          ..write('guestId: $guestId, ')
          ..write('typeId: $typeId, ')
          ..write('amount: $amount, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('isLocked: $isLocked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, guestId, typeId, amount, loggedAt, isLocked);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceCharge &&
          other.id == this.id &&
          other.guestId == this.guestId &&
          other.typeId == this.typeId &&
          other.amount == this.amount &&
          other.loggedAt == this.loggedAt &&
          other.isLocked == this.isLocked);
}

class ServiceChargesCompanion extends UpdateCompanion<ServiceCharge> {
  final Value<int> id;
  final Value<int> guestId;
  final Value<int> typeId;
  final Value<double> amount;
  final Value<DateTime> loggedAt;
  final Value<bool> isLocked;
  const ServiceChargesCompanion({
    this.id = const Value.absent(),
    this.guestId = const Value.absent(),
    this.typeId = const Value.absent(),
    this.amount = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.isLocked = const Value.absent(),
  });
  ServiceChargesCompanion.insert({
    this.id = const Value.absent(),
    required int guestId,
    required int typeId,
    required double amount,
    this.loggedAt = const Value.absent(),
    this.isLocked = const Value.absent(),
  })  : guestId = Value(guestId),
        typeId = Value(typeId),
        amount = Value(amount);
  static Insertable<ServiceCharge> custom({
    Expression<int>? id,
    Expression<int>? guestId,
    Expression<int>? typeId,
    Expression<double>? amount,
    Expression<DateTime>? loggedAt,
    Expression<bool>? isLocked,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (guestId != null) 'guest_id': guestId,
      if (typeId != null) 'type_id': typeId,
      if (amount != null) 'amount': amount,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (isLocked != null) 'is_locked': isLocked,
    });
  }

  ServiceChargesCompanion copyWith(
      {Value<int>? id,
      Value<int>? guestId,
      Value<int>? typeId,
      Value<double>? amount,
      Value<DateTime>? loggedAt,
      Value<bool>? isLocked}) {
    return ServiceChargesCompanion(
      id: id ?? this.id,
      guestId: guestId ?? this.guestId,
      typeId: typeId ?? this.typeId,
      amount: amount ?? this.amount,
      loggedAt: loggedAt ?? this.loggedAt,
      isLocked: isLocked ?? this.isLocked,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (guestId.present) {
      map['guest_id'] = Variable<int>(guestId.value);
    }
    if (typeId.present) {
      map['type_id'] = Variable<int>(typeId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<DateTime>(loggedAt.value);
    }
    if (isLocked.present) {
      map['is_locked'] = Variable<bool>(isLocked.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceChargesCompanion(')
          ..write('id: $id, ')
          ..write('guestId: $guestId, ')
          ..write('typeId: $typeId, ')
          ..write('amount: $amount, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('isLocked: $isLocked')
          ..write(')'))
        .toString();
  }
}

class $CheckoutUndoWindowsTable extends CheckoutUndoWindows
    with TableInfo<$CheckoutUndoWindowsTable, CheckoutUndoWindow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CheckoutUndoWindowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _guestIdMeta =
      const VerificationMeta('guestId');
  @override
  late final GeneratedColumn<int> guestId = GeneratedColumn<int>(
      'guest_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES guests (id)'));
  static const VerificationMeta _checkoutAtMeta =
      const VerificationMeta('checkoutAt');
  @override
  late final GeneratedColumn<DateTime> checkoutAt = GeneratedColumn<DateTime>(
      'checkout_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _expiresAtMeta =
      const VerificationMeta('expiresAt');
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
      'expires_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [guestId, checkoutAt, expiresAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checkout_undo_windows';
  @override
  VerificationContext validateIntegrity(Insertable<CheckoutUndoWindow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('guest_id')) {
      context.handle(_guestIdMeta,
          guestId.isAcceptableOrUnknown(data['guest_id']!, _guestIdMeta));
    }
    if (data.containsKey('checkout_at')) {
      context.handle(
          _checkoutAtMeta,
          checkoutAt.isAcceptableOrUnknown(
              data['checkout_at']!, _checkoutAtMeta));
    } else if (isInserting) {
      context.missing(_checkoutAtMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(_expiresAtMeta,
          expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta));
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {guestId};
  @override
  CheckoutUndoWindow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CheckoutUndoWindow(
      guestId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}guest_id'])!,
      checkoutAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}checkout_at'])!,
      expiresAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expires_at'])!,
    );
  }

  @override
  $CheckoutUndoWindowsTable createAlias(String alias) {
    return $CheckoutUndoWindowsTable(attachedDatabase, alias);
  }
}

class CheckoutUndoWindow extends DataClass
    implements Insertable<CheckoutUndoWindow> {
  final int guestId;
  final DateTime checkoutAt;
  final DateTime expiresAt;
  const CheckoutUndoWindow(
      {required this.guestId,
      required this.checkoutAt,
      required this.expiresAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['guest_id'] = Variable<int>(guestId);
    map['checkout_at'] = Variable<DateTime>(checkoutAt);
    map['expires_at'] = Variable<DateTime>(expiresAt);
    return map;
  }

  CheckoutUndoWindowsCompanion toCompanion(bool nullToAbsent) {
    return CheckoutUndoWindowsCompanion(
      guestId: Value(guestId),
      checkoutAt: Value(checkoutAt),
      expiresAt: Value(expiresAt),
    );
  }

  factory CheckoutUndoWindow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CheckoutUndoWindow(
      guestId: serializer.fromJson<int>(json['guestId']),
      checkoutAt: serializer.fromJson<DateTime>(json['checkoutAt']),
      expiresAt: serializer.fromJson<DateTime>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'guestId': serializer.toJson<int>(guestId),
      'checkoutAt': serializer.toJson<DateTime>(checkoutAt),
      'expiresAt': serializer.toJson<DateTime>(expiresAt),
    };
  }

  CheckoutUndoWindow copyWith(
          {int? guestId, DateTime? checkoutAt, DateTime? expiresAt}) =>
      CheckoutUndoWindow(
        guestId: guestId ?? this.guestId,
        checkoutAt: checkoutAt ?? this.checkoutAt,
        expiresAt: expiresAt ?? this.expiresAt,
      );
  CheckoutUndoWindow copyWithCompanion(CheckoutUndoWindowsCompanion data) {
    return CheckoutUndoWindow(
      guestId: data.guestId.present ? data.guestId.value : this.guestId,
      checkoutAt:
          data.checkoutAt.present ? data.checkoutAt.value : this.checkoutAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CheckoutUndoWindow(')
          ..write('guestId: $guestId, ')
          ..write('checkoutAt: $checkoutAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(guestId, checkoutAt, expiresAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CheckoutUndoWindow &&
          other.guestId == this.guestId &&
          other.checkoutAt == this.checkoutAt &&
          other.expiresAt == this.expiresAt);
}

class CheckoutUndoWindowsCompanion extends UpdateCompanion<CheckoutUndoWindow> {
  final Value<int> guestId;
  final Value<DateTime> checkoutAt;
  final Value<DateTime> expiresAt;
  const CheckoutUndoWindowsCompanion({
    this.guestId = const Value.absent(),
    this.checkoutAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
  });
  CheckoutUndoWindowsCompanion.insert({
    this.guestId = const Value.absent(),
    required DateTime checkoutAt,
    required DateTime expiresAt,
  })  : checkoutAt = Value(checkoutAt),
        expiresAt = Value(expiresAt);
  static Insertable<CheckoutUndoWindow> custom({
    Expression<int>? guestId,
    Expression<DateTime>? checkoutAt,
    Expression<DateTime>? expiresAt,
  }) {
    return RawValuesInsertable({
      if (guestId != null) 'guest_id': guestId,
      if (checkoutAt != null) 'checkout_at': checkoutAt,
      if (expiresAt != null) 'expires_at': expiresAt,
    });
  }

  CheckoutUndoWindowsCompanion copyWith(
      {Value<int>? guestId,
      Value<DateTime>? checkoutAt,
      Value<DateTime>? expiresAt}) {
    return CheckoutUndoWindowsCompanion(
      guestId: guestId ?? this.guestId,
      checkoutAt: checkoutAt ?? this.checkoutAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (guestId.present) {
      map['guest_id'] = Variable<int>(guestId.value);
    }
    if (checkoutAt.present) {
      map['checkout_at'] = Variable<DateTime>(checkoutAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CheckoutUndoWindowsCompanion(')
          ..write('guestId: $guestId, ')
          ..write('checkoutAt: $checkoutAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EventsTable events = $EventsTable(this);
  late final $HotelsTable hotels = $HotelsTable(this);
  late final $RoomsTable rooms = $RoomsTable(this);
  late final $GuestsTable guests = $GuestsTable(this);
  late final $StaySegmentsTable staySegments = $StaySegmentsTable(this);
  late final $ServiceTypesTable serviceTypes = $ServiceTypesTable(this);
  late final $ServiceChargesTable serviceCharges = $ServiceChargesTable(this);
  late final $CheckoutUndoWindowsTable checkoutUndoWindows =
      $CheckoutUndoWindowsTable(this);
  late final EventsDao eventsDao = EventsDao(this as AppDatabase);
  late final HotelsDao hotelsDao = HotelsDao(this as AppDatabase);
  late final GuestsDao guestsDao = GuestsDao(this as AppDatabase);
  late final ServiceDao serviceDao = ServiceDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        events,
        hotels,
        rooms,
        guests,
        staySegments,
        serviceTypes,
        serviceCharges,
        checkoutUndoWindows
      ];
}

typedef $$EventsTableCreateCompanionBuilder = EventsCompanion Function({
  Value<int> id,
  required String name,
  required String type,
  required DateTime startDate,
  required DateTime endDate,
  Value<DateTime> createdAt,
  Value<bool> isArchived,
});
typedef $$EventsTableUpdateCompanionBuilder = EventsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> type,
  Value<DateTime> startDate,
  Value<DateTime> endDate,
  Value<DateTime> createdAt,
  Value<bool> isArchived,
});

final class $$EventsTableReferences
    extends BaseReferences<_$AppDatabase, $EventsTable, Event> {
  $$EventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$HotelsTable, List<Hotel>> _hotelsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.hotels,
          aliasName: $_aliasNameGenerator(db.events.id, db.hotels.eventId));

  $$HotelsTableProcessedTableManager get hotelsRefs {
    final manager = $$HotelsTableTableManager($_db, $_db.hotels)
        .filter((f) => f.eventId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_hotelsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$GuestsTable, List<Guest>> _guestsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.guests,
          aliasName: $_aliasNameGenerator(db.events.id, db.guests.eventId));

  $$GuestsTableProcessedTableManager get guestsRefs {
    final manager = $$GuestsTableTableManager($_db, $_db.guests)
        .filter((f) => f.eventId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_guestsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ServiceTypesTable, List<ServiceType>>
      _serviceTypesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.serviceTypes,
              aliasName:
                  $_aliasNameGenerator(db.events.id, db.serviceTypes.eventId));

  $$ServiceTypesTableProcessedTableManager get serviceTypesRefs {
    final manager = $$ServiceTypesTableTableManager($_db, $_db.serviceTypes)
        .filter((f) => f.eventId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_serviceTypesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$EventsTableFilterComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnFilters(column));

  Expression<bool> hotelsRefs(
      Expression<bool> Function($$HotelsTableFilterComposer f) f) {
    final $$HotelsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.eventId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableFilterComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> guestsRefs(
      Expression<bool> Function($$GuestsTableFilterComposer f) f) {
    final $$GuestsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.guests,
        getReferencedColumn: (t) => t.eventId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GuestsTableFilterComposer(
              $db: $db,
              $table: $db.guests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> serviceTypesRefs(
      Expression<bool> Function($$ServiceTypesTableFilterComposer f) f) {
    final $$ServiceTypesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.serviceTypes,
        getReferencedColumn: (t) => t.eventId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiceTypesTableFilterComposer(
              $db: $db,
              $table: $db.serviceTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EventsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnOrderings(column));
}

class $$EventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => column);

  Expression<T> hotelsRefs<T extends Object>(
      Expression<T> Function($$HotelsTableAnnotationComposer a) f) {
    final $$HotelsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.eventId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableAnnotationComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> guestsRefs<T extends Object>(
      Expression<T> Function($$GuestsTableAnnotationComposer a) f) {
    final $$GuestsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.guests,
        getReferencedColumn: (t) => t.eventId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GuestsTableAnnotationComposer(
              $db: $db,
              $table: $db.guests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> serviceTypesRefs<T extends Object>(
      Expression<T> Function($$ServiceTypesTableAnnotationComposer a) f) {
    final $$ServiceTypesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.serviceTypes,
        getReferencedColumn: (t) => t.eventId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiceTypesTableAnnotationComposer(
              $db: $db,
              $table: $db.serviceTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EventsTable,
    Event,
    $$EventsTableFilterComposer,
    $$EventsTableOrderingComposer,
    $$EventsTableAnnotationComposer,
    $$EventsTableCreateCompanionBuilder,
    $$EventsTableUpdateCompanionBuilder,
    (Event, $$EventsTableReferences),
    Event,
    PrefetchHooks Function(
        {bool hotelsRefs, bool guestsRefs, bool serviceTypesRefs})> {
  $$EventsTableTableManager(_$AppDatabase db, $EventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime> endDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
          }) =>
              EventsCompanion(
            id: id,
            name: name,
            type: type,
            startDate: startDate,
            endDate: endDate,
            createdAt: createdAt,
            isArchived: isArchived,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String type,
            required DateTime startDate,
            required DateTime endDate,
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
          }) =>
              EventsCompanion.insert(
            id: id,
            name: name,
            type: type,
            startDate: startDate,
            endDate: endDate,
            createdAt: createdAt,
            isArchived: isArchived,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$EventsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {hotelsRefs = false,
              guestsRefs = false,
              serviceTypesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (hotelsRefs) db.hotels,
                if (guestsRefs) db.guests,
                if (serviceTypesRefs) db.serviceTypes
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (hotelsRefs)
                    await $_getPrefetchedData<Event, $EventsTable, Hotel>(
                        currentTable: table,
                        referencedTable:
                            $$EventsTableReferences._hotelsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EventsTableReferences(db, table, p0).hotelsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.eventId == item.id),
                        typedResults: items),
                  if (guestsRefs)
                    await $_getPrefetchedData<Event, $EventsTable, Guest>(
                        currentTable: table,
                        referencedTable:
                            $$EventsTableReferences._guestsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EventsTableReferences(db, table, p0).guestsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.eventId == item.id),
                        typedResults: items),
                  if (serviceTypesRefs)
                    await $_getPrefetchedData<Event, $EventsTable, ServiceType>(
                        currentTable: table,
                        referencedTable:
                            $$EventsTableReferences._serviceTypesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EventsTableReferences(db, table, p0)
                                .serviceTypesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.eventId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$EventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EventsTable,
    Event,
    $$EventsTableFilterComposer,
    $$EventsTableOrderingComposer,
    $$EventsTableAnnotationComposer,
    $$EventsTableCreateCompanionBuilder,
    $$EventsTableUpdateCompanionBuilder,
    (Event, $$EventsTableReferences),
    Event,
    PrefetchHooks Function(
        {bool hotelsRefs, bool guestsRefs, bool serviceTypesRefs})>;
typedef $$HotelsTableCreateCompanionBuilder = HotelsCompanion Function({
  Value<int> id,
  required int eventId,
  required String name,
});
typedef $$HotelsTableUpdateCompanionBuilder = HotelsCompanion Function({
  Value<int> id,
  Value<int> eventId,
  Value<String> name,
});

final class $$HotelsTableReferences
    extends BaseReferences<_$AppDatabase, $HotelsTable, Hotel> {
  $$HotelsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EventsTable _eventIdTable(_$AppDatabase db) => db.events
      .createAlias($_aliasNameGenerator(db.hotels.eventId, db.events.id));

  $$EventsTableProcessedTableManager get eventId {
    final $_column = $_itemColumn<int>('event_id')!;

    final manager = $$EventsTableTableManager($_db, $_db.events)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$RoomsTable, List<Room>> _roomsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.rooms,
          aliasName: $_aliasNameGenerator(db.hotels.id, db.rooms.hotelId));

  $$RoomsTableProcessedTableManager get roomsRefs {
    final manager = $$RoomsTableTableManager($_db, $_db.rooms)
        .filter((f) => f.hotelId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_roomsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$GuestsTable, List<Guest>> _guestsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.guests,
          aliasName:
              $_aliasNameGenerator(db.hotels.id, db.guests.currentHotelId));

  $$GuestsTableProcessedTableManager get guestsRefs {
    final manager = $$GuestsTableTableManager($_db, $_db.guests)
        .filter((f) => f.currentHotelId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_guestsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$StaySegmentsTable, List<StaySegment>>
      _staySegmentsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.staySegments,
              aliasName:
                  $_aliasNameGenerator(db.hotels.id, db.staySegments.hotelId));

  $$StaySegmentsTableProcessedTableManager get staySegmentsRefs {
    final manager = $$StaySegmentsTableTableManager($_db, $_db.staySegments)
        .filter((f) => f.hotelId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_staySegmentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$HotelsTableFilterComposer
    extends Composer<_$AppDatabase, $HotelsTable> {
  $$HotelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  $$EventsTableFilterComposer get eventId {
    final $$EventsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventId,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableFilterComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> roomsRefs(
      Expression<bool> Function($$RoomsTableFilterComposer f) f) {
    final $$RoomsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.rooms,
        getReferencedColumn: (t) => t.hotelId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoomsTableFilterComposer(
              $db: $db,
              $table: $db.rooms,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> guestsRefs(
      Expression<bool> Function($$GuestsTableFilterComposer f) f) {
    final $$GuestsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.guests,
        getReferencedColumn: (t) => t.currentHotelId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GuestsTableFilterComposer(
              $db: $db,
              $table: $db.guests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> staySegmentsRefs(
      Expression<bool> Function($$StaySegmentsTableFilterComposer f) f) {
    final $$StaySegmentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.staySegments,
        getReferencedColumn: (t) => t.hotelId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StaySegmentsTableFilterComposer(
              $db: $db,
              $table: $db.staySegments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$HotelsTableOrderingComposer
    extends Composer<_$AppDatabase, $HotelsTable> {
  $$HotelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  $$EventsTableOrderingComposer get eventId {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventId,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableOrderingComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HotelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HotelsTable> {
  $$HotelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  $$EventsTableAnnotationComposer get eventId {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventId,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableAnnotationComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> roomsRefs<T extends Object>(
      Expression<T> Function($$RoomsTableAnnotationComposer a) f) {
    final $$RoomsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.rooms,
        getReferencedColumn: (t) => t.hotelId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoomsTableAnnotationComposer(
              $db: $db,
              $table: $db.rooms,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> guestsRefs<T extends Object>(
      Expression<T> Function($$GuestsTableAnnotationComposer a) f) {
    final $$GuestsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.guests,
        getReferencedColumn: (t) => t.currentHotelId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GuestsTableAnnotationComposer(
              $db: $db,
              $table: $db.guests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> staySegmentsRefs<T extends Object>(
      Expression<T> Function($$StaySegmentsTableAnnotationComposer a) f) {
    final $$StaySegmentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.staySegments,
        getReferencedColumn: (t) => t.hotelId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StaySegmentsTableAnnotationComposer(
              $db: $db,
              $table: $db.staySegments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$HotelsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HotelsTable,
    Hotel,
    $$HotelsTableFilterComposer,
    $$HotelsTableOrderingComposer,
    $$HotelsTableAnnotationComposer,
    $$HotelsTableCreateCompanionBuilder,
    $$HotelsTableUpdateCompanionBuilder,
    (Hotel, $$HotelsTableReferences),
    Hotel,
    PrefetchHooks Function(
        {bool eventId,
        bool roomsRefs,
        bool guestsRefs,
        bool staySegmentsRefs})> {
  $$HotelsTableTableManager(_$AppDatabase db, $HotelsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HotelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HotelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HotelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> eventId = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) =>
              HotelsCompanion(
            id: id,
            eventId: eventId,
            name: name,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int eventId,
            required String name,
          }) =>
              HotelsCompanion.insert(
            id: id,
            eventId: eventId,
            name: name,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$HotelsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {eventId = false,
              roomsRefs = false,
              guestsRefs = false,
              staySegmentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (roomsRefs) db.rooms,
                if (guestsRefs) db.guests,
                if (staySegmentsRefs) db.staySegments
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
                if (eventId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.eventId,
                    referencedTable: $$HotelsTableReferences._eventIdTable(db),
                    referencedColumn:
                        $$HotelsTableReferences._eventIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (roomsRefs)
                    await $_getPrefetchedData<Hotel, $HotelsTable, Room>(
                        currentTable: table,
                        referencedTable:
                            $$HotelsTableReferences._roomsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HotelsTableReferences(db, table, p0).roomsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.hotelId == item.id),
                        typedResults: items),
                  if (guestsRefs)
                    await $_getPrefetchedData<Hotel, $HotelsTable, Guest>(
                        currentTable: table,
                        referencedTable:
                            $$HotelsTableReferences._guestsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HotelsTableReferences(db, table, p0).guestsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.currentHotelId == item.id),
                        typedResults: items),
                  if (staySegmentsRefs)
                    await $_getPrefetchedData<Hotel, $HotelsTable, StaySegment>(
                        currentTable: table,
                        referencedTable:
                            $$HotelsTableReferences._staySegmentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HotelsTableReferences(db, table, p0)
                                .staySegmentsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.hotelId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$HotelsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HotelsTable,
    Hotel,
    $$HotelsTableFilterComposer,
    $$HotelsTableOrderingComposer,
    $$HotelsTableAnnotationComposer,
    $$HotelsTableCreateCompanionBuilder,
    $$HotelsTableUpdateCompanionBuilder,
    (Hotel, $$HotelsTableReferences),
    Hotel,
    PrefetchHooks Function(
        {bool eventId,
        bool roomsRefs,
        bool guestsRefs,
        bool staySegmentsRefs})>;
typedef $$RoomsTableCreateCompanionBuilder = RoomsCompanion Function({
  Value<int> id,
  required int hotelId,
  required String number,
  required String category,
  Value<String> status,
});
typedef $$RoomsTableUpdateCompanionBuilder = RoomsCompanion Function({
  Value<int> id,
  Value<int> hotelId,
  Value<String> number,
  Value<String> category,
  Value<String> status,
});

final class $$RoomsTableReferences
    extends BaseReferences<_$AppDatabase, $RoomsTable, Room> {
  $$RoomsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HotelsTable _hotelIdTable(_$AppDatabase db) => db.hotels
      .createAlias($_aliasNameGenerator(db.rooms.hotelId, db.hotels.id));

  $$HotelsTableProcessedTableManager get hotelId {
    final $_column = $_itemColumn<int>('hotel_id')!;

    final manager = $$HotelsTableTableManager($_db, $_db.hotels)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_hotelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$GuestsTable, List<Guest>> _guestsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.guests,
          aliasName:
              $_aliasNameGenerator(db.rooms.id, db.guests.currentRoomId));

  $$GuestsTableProcessedTableManager get guestsRefs {
    final manager = $$GuestsTableTableManager($_db, $_db.guests)
        .filter((f) => f.currentRoomId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_guestsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$StaySegmentsTable, List<StaySegment>>
      _staySegmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.staySegments,
          aliasName: $_aliasNameGenerator(db.rooms.id, db.staySegments.roomId));

  $$StaySegmentsTableProcessedTableManager get staySegmentsRefs {
    final manager = $$StaySegmentsTableTableManager($_db, $_db.staySegments)
        .filter((f) => f.roomId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_staySegmentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RoomsTableFilterComposer extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  $$HotelsTableFilterComposer get hotelId {
    final $$HotelsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableFilterComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> guestsRefs(
      Expression<bool> Function($$GuestsTableFilterComposer f) f) {
    final $$GuestsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.guests,
        getReferencedColumn: (t) => t.currentRoomId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GuestsTableFilterComposer(
              $db: $db,
              $table: $db.guests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> staySegmentsRefs(
      Expression<bool> Function($$StaySegmentsTableFilterComposer f) f) {
    final $$StaySegmentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.staySegments,
        getReferencedColumn: (t) => t.roomId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StaySegmentsTableFilterComposer(
              $db: $db,
              $table: $db.staySegments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RoomsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  $$HotelsTableOrderingComposer get hotelId {
    final $$HotelsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableOrderingComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RoomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$HotelsTableAnnotationComposer get hotelId {
    final $$HotelsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableAnnotationComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> guestsRefs<T extends Object>(
      Expression<T> Function($$GuestsTableAnnotationComposer a) f) {
    final $$GuestsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.guests,
        getReferencedColumn: (t) => t.currentRoomId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GuestsTableAnnotationComposer(
              $db: $db,
              $table: $db.guests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> staySegmentsRefs<T extends Object>(
      Expression<T> Function($$StaySegmentsTableAnnotationComposer a) f) {
    final $$StaySegmentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.staySegments,
        getReferencedColumn: (t) => t.roomId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StaySegmentsTableAnnotationComposer(
              $db: $db,
              $table: $db.staySegments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RoomsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RoomsTable,
    Room,
    $$RoomsTableFilterComposer,
    $$RoomsTableOrderingComposer,
    $$RoomsTableAnnotationComposer,
    $$RoomsTableCreateCompanionBuilder,
    $$RoomsTableUpdateCompanionBuilder,
    (Room, $$RoomsTableReferences),
    Room,
    PrefetchHooks Function(
        {bool hotelId, bool guestsRefs, bool staySegmentsRefs})> {
  $$RoomsTableTableManager(_$AppDatabase db, $RoomsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> hotelId = const Value.absent(),
            Value<String> number = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> status = const Value.absent(),
          }) =>
              RoomsCompanion(
            id: id,
            hotelId: hotelId,
            number: number,
            category: category,
            status: status,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int hotelId,
            required String number,
            required String category,
            Value<String> status = const Value.absent(),
          }) =>
              RoomsCompanion.insert(
            id: id,
            hotelId: hotelId,
            number: number,
            category: category,
            status: status,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$RoomsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {hotelId = false, guestsRefs = false, staySegmentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (guestsRefs) db.guests,
                if (staySegmentsRefs) db.staySegments
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
                if (hotelId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.hotelId,
                    referencedTable: $$RoomsTableReferences._hotelIdTable(db),
                    referencedColumn:
                        $$RoomsTableReferences._hotelIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (guestsRefs)
                    await $_getPrefetchedData<Room, $RoomsTable, Guest>(
                        currentTable: table,
                        referencedTable:
                            $$RoomsTableReferences._guestsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RoomsTableReferences(db, table, p0).guestsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.currentRoomId == item.id),
                        typedResults: items),
                  if (staySegmentsRefs)
                    await $_getPrefetchedData<Room, $RoomsTable, StaySegment>(
                        currentTable: table,
                        referencedTable:
                            $$RoomsTableReferences._staySegmentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RoomsTableReferences(db, table, p0)
                                .staySegmentsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.roomId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$RoomsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RoomsTable,
    Room,
    $$RoomsTableFilterComposer,
    $$RoomsTableOrderingComposer,
    $$RoomsTableAnnotationComposer,
    $$RoomsTableCreateCompanionBuilder,
    $$RoomsTableUpdateCompanionBuilder,
    (Room, $$RoomsTableReferences),
    Room,
    PrefetchHooks Function(
        {bool hotelId, bool guestsRefs, bool staySegmentsRefs})>;
typedef $$GuestsTableCreateCompanionBuilder = GuestsCompanion Function({
  Value<int> id,
  required int eventId,
  required String name,
  required String assignedCategory,
  Value<bool> isVip,
  Value<bool> isCloseRelative,
  Value<String?> specialRequests,
  Value<String> status,
  Value<int?> currentHotelId,
  Value<int?> currentRoomId,
});
typedef $$GuestsTableUpdateCompanionBuilder = GuestsCompanion Function({
  Value<int> id,
  Value<int> eventId,
  Value<String> name,
  Value<String> assignedCategory,
  Value<bool> isVip,
  Value<bool> isCloseRelative,
  Value<String?> specialRequests,
  Value<String> status,
  Value<int?> currentHotelId,
  Value<int?> currentRoomId,
});

final class $$GuestsTableReferences
    extends BaseReferences<_$AppDatabase, $GuestsTable, Guest> {
  $$GuestsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EventsTable _eventIdTable(_$AppDatabase db) => db.events
      .createAlias($_aliasNameGenerator(db.guests.eventId, db.events.id));

  $$EventsTableProcessedTableManager get eventId {
    final $_column = $_itemColumn<int>('event_id')!;

    final manager = $$EventsTableTableManager($_db, $_db.events)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $HotelsTable _currentHotelIdTable(_$AppDatabase db) =>
      db.hotels.createAlias(
          $_aliasNameGenerator(db.guests.currentHotelId, db.hotels.id));

  $$HotelsTableProcessedTableManager? get currentHotelId {
    final $_column = $_itemColumn<int>('current_hotel_id');
    if ($_column == null) return null;
    final manager = $$HotelsTableTableManager($_db, $_db.hotels)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_currentHotelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $RoomsTable _currentRoomIdTable(_$AppDatabase db) => db.rooms
      .createAlias($_aliasNameGenerator(db.guests.currentRoomId, db.rooms.id));

  $$RoomsTableProcessedTableManager? get currentRoomId {
    final $_column = $_itemColumn<int>('current_room_id');
    if ($_column == null) return null;
    final manager = $$RoomsTableTableManager($_db, $_db.rooms)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_currentRoomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$StaySegmentsTable, List<StaySegment>>
      _staySegmentsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.staySegments,
              aliasName:
                  $_aliasNameGenerator(db.guests.id, db.staySegments.guestId));

  $$StaySegmentsTableProcessedTableManager get staySegmentsRefs {
    final manager = $$StaySegmentsTableTableManager($_db, $_db.staySegments)
        .filter((f) => f.guestId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_staySegmentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ServiceChargesTable, List<ServiceCharge>>
      _serviceChargesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.serviceCharges,
              aliasName: $_aliasNameGenerator(
                  db.guests.id, db.serviceCharges.guestId));

  $$ServiceChargesTableProcessedTableManager get serviceChargesRefs {
    final manager = $$ServiceChargesTableTableManager($_db, $_db.serviceCharges)
        .filter((f) => f.guestId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_serviceChargesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CheckoutUndoWindowsTable,
      List<CheckoutUndoWindow>> _checkoutUndoWindowsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.checkoutUndoWindows,
          aliasName: $_aliasNameGenerator(
              db.guests.id, db.checkoutUndoWindows.guestId));

  $$CheckoutUndoWindowsTableProcessedTableManager get checkoutUndoWindowsRefs {
    final manager =
        $$CheckoutUndoWindowsTableTableManager($_db, $_db.checkoutUndoWindows)
            .filter((f) => f.guestId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_checkoutUndoWindowsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$GuestsTableFilterComposer
    extends Composer<_$AppDatabase, $GuestsTable> {
  $$GuestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get assignedCategory => $composableBuilder(
      column: $table.assignedCategory,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isVip => $composableBuilder(
      column: $table.isVip, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCloseRelative => $composableBuilder(
      column: $table.isCloseRelative,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get specialRequests => $composableBuilder(
      column: $table.specialRequests,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  $$EventsTableFilterComposer get eventId {
    final $$EventsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventId,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableFilterComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$HotelsTableFilterComposer get currentHotelId {
    final $$HotelsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currentHotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableFilterComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RoomsTableFilterComposer get currentRoomId {
    final $$RoomsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currentRoomId,
        referencedTable: $db.rooms,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoomsTableFilterComposer(
              $db: $db,
              $table: $db.rooms,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> staySegmentsRefs(
      Expression<bool> Function($$StaySegmentsTableFilterComposer f) f) {
    final $$StaySegmentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.staySegments,
        getReferencedColumn: (t) => t.guestId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StaySegmentsTableFilterComposer(
              $db: $db,
              $table: $db.staySegments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> serviceChargesRefs(
      Expression<bool> Function($$ServiceChargesTableFilterComposer f) f) {
    final $$ServiceChargesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.serviceCharges,
        getReferencedColumn: (t) => t.guestId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiceChargesTableFilterComposer(
              $db: $db,
              $table: $db.serviceCharges,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> checkoutUndoWindowsRefs(
      Expression<bool> Function($$CheckoutUndoWindowsTableFilterComposer f) f) {
    final $$CheckoutUndoWindowsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.checkoutUndoWindows,
        getReferencedColumn: (t) => t.guestId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CheckoutUndoWindowsTableFilterComposer(
              $db: $db,
              $table: $db.checkoutUndoWindows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GuestsTableOrderingComposer
    extends Composer<_$AppDatabase, $GuestsTable> {
  $$GuestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get assignedCategory => $composableBuilder(
      column: $table.assignedCategory,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isVip => $composableBuilder(
      column: $table.isVip, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCloseRelative => $composableBuilder(
      column: $table.isCloseRelative,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get specialRequests => $composableBuilder(
      column: $table.specialRequests,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  $$EventsTableOrderingComposer get eventId {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventId,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableOrderingComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$HotelsTableOrderingComposer get currentHotelId {
    final $$HotelsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currentHotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableOrderingComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RoomsTableOrderingComposer get currentRoomId {
    final $$RoomsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currentRoomId,
        referencedTable: $db.rooms,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoomsTableOrderingComposer(
              $db: $db,
              $table: $db.rooms,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GuestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GuestsTable> {
  $$GuestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get assignedCategory => $composableBuilder(
      column: $table.assignedCategory, builder: (column) => column);

  GeneratedColumn<bool> get isVip =>
      $composableBuilder(column: $table.isVip, builder: (column) => column);

  GeneratedColumn<bool> get isCloseRelative => $composableBuilder(
      column: $table.isCloseRelative, builder: (column) => column);

  GeneratedColumn<String> get specialRequests => $composableBuilder(
      column: $table.specialRequests, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$EventsTableAnnotationComposer get eventId {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventId,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableAnnotationComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$HotelsTableAnnotationComposer get currentHotelId {
    final $$HotelsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currentHotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableAnnotationComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RoomsTableAnnotationComposer get currentRoomId {
    final $$RoomsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currentRoomId,
        referencedTable: $db.rooms,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoomsTableAnnotationComposer(
              $db: $db,
              $table: $db.rooms,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> staySegmentsRefs<T extends Object>(
      Expression<T> Function($$StaySegmentsTableAnnotationComposer a) f) {
    final $$StaySegmentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.staySegments,
        getReferencedColumn: (t) => t.guestId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StaySegmentsTableAnnotationComposer(
              $db: $db,
              $table: $db.staySegments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> serviceChargesRefs<T extends Object>(
      Expression<T> Function($$ServiceChargesTableAnnotationComposer a) f) {
    final $$ServiceChargesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.serviceCharges,
        getReferencedColumn: (t) => t.guestId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiceChargesTableAnnotationComposer(
              $db: $db,
              $table: $db.serviceCharges,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> checkoutUndoWindowsRefs<T extends Object>(
      Expression<T> Function($$CheckoutUndoWindowsTableAnnotationComposer a)
          f) {
    final $$CheckoutUndoWindowsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.checkoutUndoWindows,
            getReferencedColumn: (t) => t.guestId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CheckoutUndoWindowsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.checkoutUndoWindows,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$GuestsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GuestsTable,
    Guest,
    $$GuestsTableFilterComposer,
    $$GuestsTableOrderingComposer,
    $$GuestsTableAnnotationComposer,
    $$GuestsTableCreateCompanionBuilder,
    $$GuestsTableUpdateCompanionBuilder,
    (Guest, $$GuestsTableReferences),
    Guest,
    PrefetchHooks Function(
        {bool eventId,
        bool currentHotelId,
        bool currentRoomId,
        bool staySegmentsRefs,
        bool serviceChargesRefs,
        bool checkoutUndoWindowsRefs})> {
  $$GuestsTableTableManager(_$AppDatabase db, $GuestsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GuestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GuestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GuestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> eventId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> assignedCategory = const Value.absent(),
            Value<bool> isVip = const Value.absent(),
            Value<bool> isCloseRelative = const Value.absent(),
            Value<String?> specialRequests = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int?> currentHotelId = const Value.absent(),
            Value<int?> currentRoomId = const Value.absent(),
          }) =>
              GuestsCompanion(
            id: id,
            eventId: eventId,
            name: name,
            assignedCategory: assignedCategory,
            isVip: isVip,
            isCloseRelative: isCloseRelative,
            specialRequests: specialRequests,
            status: status,
            currentHotelId: currentHotelId,
            currentRoomId: currentRoomId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int eventId,
            required String name,
            required String assignedCategory,
            Value<bool> isVip = const Value.absent(),
            Value<bool> isCloseRelative = const Value.absent(),
            Value<String?> specialRequests = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int?> currentHotelId = const Value.absent(),
            Value<int?> currentRoomId = const Value.absent(),
          }) =>
              GuestsCompanion.insert(
            id: id,
            eventId: eventId,
            name: name,
            assignedCategory: assignedCategory,
            isVip: isVip,
            isCloseRelative: isCloseRelative,
            specialRequests: specialRequests,
            status: status,
            currentHotelId: currentHotelId,
            currentRoomId: currentRoomId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$GuestsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {eventId = false,
              currentHotelId = false,
              currentRoomId = false,
              staySegmentsRefs = false,
              serviceChargesRefs = false,
              checkoutUndoWindowsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (staySegmentsRefs) db.staySegments,
                if (serviceChargesRefs) db.serviceCharges,
                if (checkoutUndoWindowsRefs) db.checkoutUndoWindows
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
                if (eventId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.eventId,
                    referencedTable: $$GuestsTableReferences._eventIdTable(db),
                    referencedColumn:
                        $$GuestsTableReferences._eventIdTable(db).id,
                  ) as T;
                }
                if (currentHotelId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.currentHotelId,
                    referencedTable:
                        $$GuestsTableReferences._currentHotelIdTable(db),
                    referencedColumn:
                        $$GuestsTableReferences._currentHotelIdTable(db).id,
                  ) as T;
                }
                if (currentRoomId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.currentRoomId,
                    referencedTable:
                        $$GuestsTableReferences._currentRoomIdTable(db),
                    referencedColumn:
                        $$GuestsTableReferences._currentRoomIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (staySegmentsRefs)
                    await $_getPrefetchedData<Guest, $GuestsTable, StaySegment>(
                        currentTable: table,
                        referencedTable:
                            $$GuestsTableReferences._staySegmentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GuestsTableReferences(db, table, p0)
                                .staySegmentsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.guestId == item.id),
                        typedResults: items),
                  if (serviceChargesRefs)
                    await $_getPrefetchedData<Guest, $GuestsTable,
                            ServiceCharge>(
                        currentTable: table,
                        referencedTable: $$GuestsTableReferences
                            ._serviceChargesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GuestsTableReferences(db, table, p0)
                                .serviceChargesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.guestId == item.id),
                        typedResults: items),
                  if (checkoutUndoWindowsRefs)
                    await $_getPrefetchedData<Guest, $GuestsTable,
                            CheckoutUndoWindow>(
                        currentTable: table,
                        referencedTable: $$GuestsTableReferences
                            ._checkoutUndoWindowsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GuestsTableReferences(db, table, p0)
                                .checkoutUndoWindowsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.guestId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$GuestsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GuestsTable,
    Guest,
    $$GuestsTableFilterComposer,
    $$GuestsTableOrderingComposer,
    $$GuestsTableAnnotationComposer,
    $$GuestsTableCreateCompanionBuilder,
    $$GuestsTableUpdateCompanionBuilder,
    (Guest, $$GuestsTableReferences),
    Guest,
    PrefetchHooks Function(
        {bool eventId,
        bool currentHotelId,
        bool currentRoomId,
        bool staySegmentsRefs,
        bool serviceChargesRefs,
        bool checkoutUndoWindowsRefs})>;
typedef $$StaySegmentsTableCreateCompanionBuilder = StaySegmentsCompanion
    Function({
  Value<int> id,
  required int guestId,
  required int hotelId,
  required int roomId,
  required DateTime checkInAt,
  Value<DateTime?> checkOutAt,
});
typedef $$StaySegmentsTableUpdateCompanionBuilder = StaySegmentsCompanion
    Function({
  Value<int> id,
  Value<int> guestId,
  Value<int> hotelId,
  Value<int> roomId,
  Value<DateTime> checkInAt,
  Value<DateTime?> checkOutAt,
});

final class $$StaySegmentsTableReferences
    extends BaseReferences<_$AppDatabase, $StaySegmentsTable, StaySegment> {
  $$StaySegmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GuestsTable _guestIdTable(_$AppDatabase db) => db.guests
      .createAlias($_aliasNameGenerator(db.staySegments.guestId, db.guests.id));

  $$GuestsTableProcessedTableManager get guestId {
    final $_column = $_itemColumn<int>('guest_id')!;

    final manager = $$GuestsTableTableManager($_db, $_db.guests)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_guestIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $HotelsTable _hotelIdTable(_$AppDatabase db) => db.hotels
      .createAlias($_aliasNameGenerator(db.staySegments.hotelId, db.hotels.id));

  $$HotelsTableProcessedTableManager get hotelId {
    final $_column = $_itemColumn<int>('hotel_id')!;

    final manager = $$HotelsTableTableManager($_db, $_db.hotels)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_hotelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $RoomsTable _roomIdTable(_$AppDatabase db) => db.rooms
      .createAlias($_aliasNameGenerator(db.staySegments.roomId, db.rooms.id));

  $$RoomsTableProcessedTableManager get roomId {
    final $_column = $_itemColumn<int>('room_id')!;

    final manager = $$RoomsTableTableManager($_db, $_db.rooms)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_roomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$StaySegmentsTableFilterComposer
    extends Composer<_$AppDatabase, $StaySegmentsTable> {
  $$StaySegmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get checkInAt => $composableBuilder(
      column: $table.checkInAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get checkOutAt => $composableBuilder(
      column: $table.checkOutAt, builder: (column) => ColumnFilters(column));

  $$GuestsTableFilterComposer get guestId {
    final $$GuestsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.guestId,
        referencedTable: $db.guests,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GuestsTableFilterComposer(
              $db: $db,
              $table: $db.guests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$HotelsTableFilterComposer get hotelId {
    final $$HotelsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableFilterComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RoomsTableFilterComposer get roomId {
    final $$RoomsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.roomId,
        referencedTable: $db.rooms,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoomsTableFilterComposer(
              $db: $db,
              $table: $db.rooms,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StaySegmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $StaySegmentsTable> {
  $$StaySegmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get checkInAt => $composableBuilder(
      column: $table.checkInAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get checkOutAt => $composableBuilder(
      column: $table.checkOutAt, builder: (column) => ColumnOrderings(column));

  $$GuestsTableOrderingComposer get guestId {
    final $$GuestsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.guestId,
        referencedTable: $db.guests,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GuestsTableOrderingComposer(
              $db: $db,
              $table: $db.guests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$HotelsTableOrderingComposer get hotelId {
    final $$HotelsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableOrderingComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RoomsTableOrderingComposer get roomId {
    final $$RoomsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.roomId,
        referencedTable: $db.rooms,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoomsTableOrderingComposer(
              $db: $db,
              $table: $db.rooms,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StaySegmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StaySegmentsTable> {
  $$StaySegmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get checkInAt =>
      $composableBuilder(column: $table.checkInAt, builder: (column) => column);

  GeneratedColumn<DateTime> get checkOutAt => $composableBuilder(
      column: $table.checkOutAt, builder: (column) => column);

  $$GuestsTableAnnotationComposer get guestId {
    final $$GuestsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.guestId,
        referencedTable: $db.guests,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GuestsTableAnnotationComposer(
              $db: $db,
              $table: $db.guests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$HotelsTableAnnotationComposer get hotelId {
    final $$HotelsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.hotelId,
        referencedTable: $db.hotels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HotelsTableAnnotationComposer(
              $db: $db,
              $table: $db.hotels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RoomsTableAnnotationComposer get roomId {
    final $$RoomsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.roomId,
        referencedTable: $db.rooms,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoomsTableAnnotationComposer(
              $db: $db,
              $table: $db.rooms,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StaySegmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StaySegmentsTable,
    StaySegment,
    $$StaySegmentsTableFilterComposer,
    $$StaySegmentsTableOrderingComposer,
    $$StaySegmentsTableAnnotationComposer,
    $$StaySegmentsTableCreateCompanionBuilder,
    $$StaySegmentsTableUpdateCompanionBuilder,
    (StaySegment, $$StaySegmentsTableReferences),
    StaySegment,
    PrefetchHooks Function({bool guestId, bool hotelId, bool roomId})> {
  $$StaySegmentsTableTableManager(_$AppDatabase db, $StaySegmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StaySegmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StaySegmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StaySegmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> guestId = const Value.absent(),
            Value<int> hotelId = const Value.absent(),
            Value<int> roomId = const Value.absent(),
            Value<DateTime> checkInAt = const Value.absent(),
            Value<DateTime?> checkOutAt = const Value.absent(),
          }) =>
              StaySegmentsCompanion(
            id: id,
            guestId: guestId,
            hotelId: hotelId,
            roomId: roomId,
            checkInAt: checkInAt,
            checkOutAt: checkOutAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int guestId,
            required int hotelId,
            required int roomId,
            required DateTime checkInAt,
            Value<DateTime?> checkOutAt = const Value.absent(),
          }) =>
              StaySegmentsCompanion.insert(
            id: id,
            guestId: guestId,
            hotelId: hotelId,
            roomId: roomId,
            checkInAt: checkInAt,
            checkOutAt: checkOutAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$StaySegmentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {guestId = false, hotelId = false, roomId = false}) {
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
                if (guestId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.guestId,
                    referencedTable:
                        $$StaySegmentsTableReferences._guestIdTable(db),
                    referencedColumn:
                        $$StaySegmentsTableReferences._guestIdTable(db).id,
                  ) as T;
                }
                if (hotelId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.hotelId,
                    referencedTable:
                        $$StaySegmentsTableReferences._hotelIdTable(db),
                    referencedColumn:
                        $$StaySegmentsTableReferences._hotelIdTable(db).id,
                  ) as T;
                }
                if (roomId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.roomId,
                    referencedTable:
                        $$StaySegmentsTableReferences._roomIdTable(db),
                    referencedColumn:
                        $$StaySegmentsTableReferences._roomIdTable(db).id,
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

typedef $$StaySegmentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StaySegmentsTable,
    StaySegment,
    $$StaySegmentsTableFilterComposer,
    $$StaySegmentsTableOrderingComposer,
    $$StaySegmentsTableAnnotationComposer,
    $$StaySegmentsTableCreateCompanionBuilder,
    $$StaySegmentsTableUpdateCompanionBuilder,
    (StaySegment, $$StaySegmentsTableReferences),
    StaySegment,
    PrefetchHooks Function({bool guestId, bool hotelId, bool roomId})>;
typedef $$ServiceTypesTableCreateCompanionBuilder = ServiceTypesCompanion
    Function({
  Value<int> id,
  required int eventId,
  required String name,
});
typedef $$ServiceTypesTableUpdateCompanionBuilder = ServiceTypesCompanion
    Function({
  Value<int> id,
  Value<int> eventId,
  Value<String> name,
});

final class $$ServiceTypesTableReferences
    extends BaseReferences<_$AppDatabase, $ServiceTypesTable, ServiceType> {
  $$ServiceTypesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EventsTable _eventIdTable(_$AppDatabase db) => db.events
      .createAlias($_aliasNameGenerator(db.serviceTypes.eventId, db.events.id));

  $$EventsTableProcessedTableManager get eventId {
    final $_column = $_itemColumn<int>('event_id')!;

    final manager = $$EventsTableTableManager($_db, $_db.events)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ServiceChargesTable, List<ServiceCharge>>
      _serviceChargesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.serviceCharges,
              aliasName: $_aliasNameGenerator(
                  db.serviceTypes.id, db.serviceCharges.typeId));

  $$ServiceChargesTableProcessedTableManager get serviceChargesRefs {
    final manager = $$ServiceChargesTableTableManager($_db, $_db.serviceCharges)
        .filter((f) => f.typeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_serviceChargesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ServiceTypesTableFilterComposer
    extends Composer<_$AppDatabase, $ServiceTypesTable> {
  $$ServiceTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  $$EventsTableFilterComposer get eventId {
    final $$EventsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventId,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableFilterComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> serviceChargesRefs(
      Expression<bool> Function($$ServiceChargesTableFilterComposer f) f) {
    final $$ServiceChargesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.serviceCharges,
        getReferencedColumn: (t) => t.typeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiceChargesTableFilterComposer(
              $db: $db,
              $table: $db.serviceCharges,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ServiceTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $ServiceTypesTable> {
  $$ServiceTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  $$EventsTableOrderingComposer get eventId {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventId,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableOrderingComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ServiceTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServiceTypesTable> {
  $$ServiceTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  $$EventsTableAnnotationComposer get eventId {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventId,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableAnnotationComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> serviceChargesRefs<T extends Object>(
      Expression<T> Function($$ServiceChargesTableAnnotationComposer a) f) {
    final $$ServiceChargesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.serviceCharges,
        getReferencedColumn: (t) => t.typeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiceChargesTableAnnotationComposer(
              $db: $db,
              $table: $db.serviceCharges,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ServiceTypesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ServiceTypesTable,
    ServiceType,
    $$ServiceTypesTableFilterComposer,
    $$ServiceTypesTableOrderingComposer,
    $$ServiceTypesTableAnnotationComposer,
    $$ServiceTypesTableCreateCompanionBuilder,
    $$ServiceTypesTableUpdateCompanionBuilder,
    (ServiceType, $$ServiceTypesTableReferences),
    ServiceType,
    PrefetchHooks Function({bool eventId, bool serviceChargesRefs})> {
  $$ServiceTypesTableTableManager(_$AppDatabase db, $ServiceTypesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiceTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServiceTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServiceTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> eventId = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) =>
              ServiceTypesCompanion(
            id: id,
            eventId: eventId,
            name: name,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int eventId,
            required String name,
          }) =>
              ServiceTypesCompanion.insert(
            id: id,
            eventId: eventId,
            name: name,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ServiceTypesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {eventId = false, serviceChargesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (serviceChargesRefs) db.serviceCharges
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
                if (eventId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.eventId,
                    referencedTable:
                        $$ServiceTypesTableReferences._eventIdTable(db),
                    referencedColumn:
                        $$ServiceTypesTableReferences._eventIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (serviceChargesRefs)
                    await $_getPrefetchedData<ServiceType, $ServiceTypesTable,
                            ServiceCharge>(
                        currentTable: table,
                        referencedTable: $$ServiceTypesTableReferences
                            ._serviceChargesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ServiceTypesTableReferences(db, table, p0)
                                .serviceChargesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.typeId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ServiceTypesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ServiceTypesTable,
    ServiceType,
    $$ServiceTypesTableFilterComposer,
    $$ServiceTypesTableOrderingComposer,
    $$ServiceTypesTableAnnotationComposer,
    $$ServiceTypesTableCreateCompanionBuilder,
    $$ServiceTypesTableUpdateCompanionBuilder,
    (ServiceType, $$ServiceTypesTableReferences),
    ServiceType,
    PrefetchHooks Function({bool eventId, bool serviceChargesRefs})>;
typedef $$ServiceChargesTableCreateCompanionBuilder = ServiceChargesCompanion
    Function({
  Value<int> id,
  required int guestId,
  required int typeId,
  required double amount,
  Value<DateTime> loggedAt,
  Value<bool> isLocked,
});
typedef $$ServiceChargesTableUpdateCompanionBuilder = ServiceChargesCompanion
    Function({
  Value<int> id,
  Value<int> guestId,
  Value<int> typeId,
  Value<double> amount,
  Value<DateTime> loggedAt,
  Value<bool> isLocked,
});

final class $$ServiceChargesTableReferences
    extends BaseReferences<_$AppDatabase, $ServiceChargesTable, ServiceCharge> {
  $$ServiceChargesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $GuestsTable _guestIdTable(_$AppDatabase db) => db.guests.createAlias(
      $_aliasNameGenerator(db.serviceCharges.guestId, db.guests.id));

  $$GuestsTableProcessedTableManager get guestId {
    final $_column = $_itemColumn<int>('guest_id')!;

    final manager = $$GuestsTableTableManager($_db, $_db.guests)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_guestIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ServiceTypesTable _typeIdTable(_$AppDatabase db) =>
      db.serviceTypes.createAlias(
          $_aliasNameGenerator(db.serviceCharges.typeId, db.serviceTypes.id));

  $$ServiceTypesTableProcessedTableManager get typeId {
    final $_column = $_itemColumn<int>('type_id')!;

    final manager = $$ServiceTypesTableTableManager($_db, $_db.serviceTypes)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_typeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ServiceChargesTableFilterComposer
    extends Composer<_$AppDatabase, $ServiceChargesTable> {
  $$ServiceChargesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get loggedAt => $composableBuilder(
      column: $table.loggedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isLocked => $composableBuilder(
      column: $table.isLocked, builder: (column) => ColumnFilters(column));

  $$GuestsTableFilterComposer get guestId {
    final $$GuestsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.guestId,
        referencedTable: $db.guests,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GuestsTableFilterComposer(
              $db: $db,
              $table: $db.guests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ServiceTypesTableFilterComposer get typeId {
    final $$ServiceTypesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.typeId,
        referencedTable: $db.serviceTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiceTypesTableFilterComposer(
              $db: $db,
              $table: $db.serviceTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ServiceChargesTableOrderingComposer
    extends Composer<_$AppDatabase, $ServiceChargesTable> {
  $$ServiceChargesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get loggedAt => $composableBuilder(
      column: $table.loggedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isLocked => $composableBuilder(
      column: $table.isLocked, builder: (column) => ColumnOrderings(column));

  $$GuestsTableOrderingComposer get guestId {
    final $$GuestsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.guestId,
        referencedTable: $db.guests,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GuestsTableOrderingComposer(
              $db: $db,
              $table: $db.guests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ServiceTypesTableOrderingComposer get typeId {
    final $$ServiceTypesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.typeId,
        referencedTable: $db.serviceTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiceTypesTableOrderingComposer(
              $db: $db,
              $table: $db.serviceTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ServiceChargesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServiceChargesTable> {
  $$ServiceChargesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  GeneratedColumn<bool> get isLocked =>
      $composableBuilder(column: $table.isLocked, builder: (column) => column);

  $$GuestsTableAnnotationComposer get guestId {
    final $$GuestsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.guestId,
        referencedTable: $db.guests,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GuestsTableAnnotationComposer(
              $db: $db,
              $table: $db.guests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ServiceTypesTableAnnotationComposer get typeId {
    final $$ServiceTypesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.typeId,
        referencedTable: $db.serviceTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiceTypesTableAnnotationComposer(
              $db: $db,
              $table: $db.serviceTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ServiceChargesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ServiceChargesTable,
    ServiceCharge,
    $$ServiceChargesTableFilterComposer,
    $$ServiceChargesTableOrderingComposer,
    $$ServiceChargesTableAnnotationComposer,
    $$ServiceChargesTableCreateCompanionBuilder,
    $$ServiceChargesTableUpdateCompanionBuilder,
    (ServiceCharge, $$ServiceChargesTableReferences),
    ServiceCharge,
    PrefetchHooks Function({bool guestId, bool typeId})> {
  $$ServiceChargesTableTableManager(
      _$AppDatabase db, $ServiceChargesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiceChargesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServiceChargesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServiceChargesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> guestId = const Value.absent(),
            Value<int> typeId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<DateTime> loggedAt = const Value.absent(),
            Value<bool> isLocked = const Value.absent(),
          }) =>
              ServiceChargesCompanion(
            id: id,
            guestId: guestId,
            typeId: typeId,
            amount: amount,
            loggedAt: loggedAt,
            isLocked: isLocked,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int guestId,
            required int typeId,
            required double amount,
            Value<DateTime> loggedAt = const Value.absent(),
            Value<bool> isLocked = const Value.absent(),
          }) =>
              ServiceChargesCompanion.insert(
            id: id,
            guestId: guestId,
            typeId: typeId,
            amount: amount,
            loggedAt: loggedAt,
            isLocked: isLocked,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ServiceChargesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({guestId = false, typeId = false}) {
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
                if (guestId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.guestId,
                    referencedTable:
                        $$ServiceChargesTableReferences._guestIdTable(db),
                    referencedColumn:
                        $$ServiceChargesTableReferences._guestIdTable(db).id,
                  ) as T;
                }
                if (typeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.typeId,
                    referencedTable:
                        $$ServiceChargesTableReferences._typeIdTable(db),
                    referencedColumn:
                        $$ServiceChargesTableReferences._typeIdTable(db).id,
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

typedef $$ServiceChargesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ServiceChargesTable,
    ServiceCharge,
    $$ServiceChargesTableFilterComposer,
    $$ServiceChargesTableOrderingComposer,
    $$ServiceChargesTableAnnotationComposer,
    $$ServiceChargesTableCreateCompanionBuilder,
    $$ServiceChargesTableUpdateCompanionBuilder,
    (ServiceCharge, $$ServiceChargesTableReferences),
    ServiceCharge,
    PrefetchHooks Function({bool guestId, bool typeId})>;
typedef $$CheckoutUndoWindowsTableCreateCompanionBuilder
    = CheckoutUndoWindowsCompanion Function({
  Value<int> guestId,
  required DateTime checkoutAt,
  required DateTime expiresAt,
});
typedef $$CheckoutUndoWindowsTableUpdateCompanionBuilder
    = CheckoutUndoWindowsCompanion Function({
  Value<int> guestId,
  Value<DateTime> checkoutAt,
  Value<DateTime> expiresAt,
});

final class $$CheckoutUndoWindowsTableReferences extends BaseReferences<
    _$AppDatabase, $CheckoutUndoWindowsTable, CheckoutUndoWindow> {
  $$CheckoutUndoWindowsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $GuestsTable _guestIdTable(_$AppDatabase db) => db.guests.createAlias(
      $_aliasNameGenerator(db.checkoutUndoWindows.guestId, db.guests.id));

  $$GuestsTableProcessedTableManager get guestId {
    final $_column = $_itemColumn<int>('guest_id')!;

    final manager = $$GuestsTableTableManager($_db, $_db.guests)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_guestIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CheckoutUndoWindowsTableFilterComposer
    extends Composer<_$AppDatabase, $CheckoutUndoWindowsTable> {
  $$CheckoutUndoWindowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get checkoutAt => $composableBuilder(
      column: $table.checkoutAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnFilters(column));

  $$GuestsTableFilterComposer get guestId {
    final $$GuestsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.guestId,
        referencedTable: $db.guests,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GuestsTableFilterComposer(
              $db: $db,
              $table: $db.guests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CheckoutUndoWindowsTableOrderingComposer
    extends Composer<_$AppDatabase, $CheckoutUndoWindowsTable> {
  $$CheckoutUndoWindowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get checkoutAt => $composableBuilder(
      column: $table.checkoutAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnOrderings(column));

  $$GuestsTableOrderingComposer get guestId {
    final $$GuestsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.guestId,
        referencedTable: $db.guests,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GuestsTableOrderingComposer(
              $db: $db,
              $table: $db.guests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CheckoutUndoWindowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CheckoutUndoWindowsTable> {
  $$CheckoutUndoWindowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get checkoutAt => $composableBuilder(
      column: $table.checkoutAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  $$GuestsTableAnnotationComposer get guestId {
    final $$GuestsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.guestId,
        referencedTable: $db.guests,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GuestsTableAnnotationComposer(
              $db: $db,
              $table: $db.guests,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CheckoutUndoWindowsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CheckoutUndoWindowsTable,
    CheckoutUndoWindow,
    $$CheckoutUndoWindowsTableFilterComposer,
    $$CheckoutUndoWindowsTableOrderingComposer,
    $$CheckoutUndoWindowsTableAnnotationComposer,
    $$CheckoutUndoWindowsTableCreateCompanionBuilder,
    $$CheckoutUndoWindowsTableUpdateCompanionBuilder,
    (CheckoutUndoWindow, $$CheckoutUndoWindowsTableReferences),
    CheckoutUndoWindow,
    PrefetchHooks Function({bool guestId})> {
  $$CheckoutUndoWindowsTableTableManager(
      _$AppDatabase db, $CheckoutUndoWindowsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CheckoutUndoWindowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CheckoutUndoWindowsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CheckoutUndoWindowsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> guestId = const Value.absent(),
            Value<DateTime> checkoutAt = const Value.absent(),
            Value<DateTime> expiresAt = const Value.absent(),
          }) =>
              CheckoutUndoWindowsCompanion(
            guestId: guestId,
            checkoutAt: checkoutAt,
            expiresAt: expiresAt,
          ),
          createCompanionCallback: ({
            Value<int> guestId = const Value.absent(),
            required DateTime checkoutAt,
            required DateTime expiresAt,
          }) =>
              CheckoutUndoWindowsCompanion.insert(
            guestId: guestId,
            checkoutAt: checkoutAt,
            expiresAt: expiresAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CheckoutUndoWindowsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({guestId = false}) {
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
                if (guestId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.guestId,
                    referencedTable:
                        $$CheckoutUndoWindowsTableReferences._guestIdTable(db),
                    referencedColumn: $$CheckoutUndoWindowsTableReferences
                        ._guestIdTable(db)
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

typedef $$CheckoutUndoWindowsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CheckoutUndoWindowsTable,
    CheckoutUndoWindow,
    $$CheckoutUndoWindowsTableFilterComposer,
    $$CheckoutUndoWindowsTableOrderingComposer,
    $$CheckoutUndoWindowsTableAnnotationComposer,
    $$CheckoutUndoWindowsTableCreateCompanionBuilder,
    $$CheckoutUndoWindowsTableUpdateCompanionBuilder,
    (CheckoutUndoWindow, $$CheckoutUndoWindowsTableReferences),
    CheckoutUndoWindow,
    PrefetchHooks Function({bool guestId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db, _db.events);
  $$HotelsTableTableManager get hotels =>
      $$HotelsTableTableManager(_db, _db.hotels);
  $$RoomsTableTableManager get rooms =>
      $$RoomsTableTableManager(_db, _db.rooms);
  $$GuestsTableTableManager get guests =>
      $$GuestsTableTableManager(_db, _db.guests);
  $$StaySegmentsTableTableManager get staySegments =>
      $$StaySegmentsTableTableManager(_db, _db.staySegments);
  $$ServiceTypesTableTableManager get serviceTypes =>
      $$ServiceTypesTableTableManager(_db, _db.serviceTypes);
  $$ServiceChargesTableTableManager get serviceCharges =>
      $$ServiceChargesTableTableManager(_db, _db.serviceCharges);
  $$CheckoutUndoWindowsTableTableManager get checkoutUndoWindows =>
      $$CheckoutUndoWindowsTableTableManager(_db, _db.checkoutUndoWindows);
}
