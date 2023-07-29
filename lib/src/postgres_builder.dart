import 'dart:async';
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:postgres_builder/postgres_builder.dart';
import 'package:postgres_pool/postgres_pool.dart';

/// {@template postgres_builder}
/// A tool designed to make writing SQL statements easier.
/// {@endtemplate}
class PostgresBuilder {
  /// {@macro postgres_builder}
  PostgresBuilder({
    this.debug = false,
    this.host = 'localhost',
    this.databaseName = 'postgres',
    this.port = 5432,
    this.username,
    this.password,
    this.connectTimeout = const Duration(seconds: 30),
    this.queryTimeout = const Duration(seconds: 30),
    this.maxConnectionAge = const Duration(hours: 1),
    this.isUnixSocket = false,
    FutureOr<void> Function(ProcessedSql message)? logger,
    T Function<T>(dynamic input)? customTypesConverters,
  })  : _customTypesConverter = customTypesConverters,
        _logger = logger ??
            ((value) => stdout.writeln(
                  '''
--EXECUTING--
${value.query}
--WITH--
'${value.parameters}
''',
                )),
        _connection = PgPool(
          PgEndpoint(
            host: host,
            port: port,
            database: databaseName,
            username: username,
            password: password,
            isUnixSocket: isUnixSocket,
          ),
          settings: PgPoolSettings()
            ..queryTimeout = queryTimeout
            ..connectTimeout = connectTimeout
            ..maxConnectionAge = maxConnectionAge,
        );

  final bool debug;
  final String host;
  final String databaseName;
  final int port;
  final String? username;
  final String? password;
  final Duration connectTimeout;
  final Duration queryTimeout;
  final Duration maxConnectionAge;
  final bool isUnixSocket;
  final FutureOr<void> Function(ProcessedSql message) _logger;
  final T Function<T>(dynamic input)? _customTypesConverter;

  late final PgPool _connection;

  Future<void> close() => _connection.close();
  PgPoolStatus status() => _connection.status();

  Future<void> execute(SqlStatement statement) => query(statement);

  Future<List<Map<String, dynamic>>> query(SqlStatement statement) async {
    try {
      final processed = statement.toSql();
      if (debug) {
        _logger(processed);
      }
      final result = await _connection.query(
        processed.query,
        substitutionValues: processed.parameters,
      );
      if (result.isEmpty) return [];
      final columns =
          result.columnDescriptions.map((e) => e.columnName).toList();
      return [
        for (var row = 0; row < result.length; row++)
          {
            for (var i = 0; i < columns.length; i++)
              columns[i]: _customTypesConverter != null
                  ? _customTypesConverter!.call(result[row][i])
                  : result[row][i]
          }
      ];
    } on CheckedFromJsonException catch (e) {
      throw PostgresBuilderException(
        e.message,
        {'key': e.key, 'badKey': e.badKey, 'map': e.map},
      );
    } on PostgreSQLException catch (e) {
      throw PostgresBuilderException(
        e.message,
        {'code': e.code, 'detail': e.detail},
      );
    }
  }

  Future<Map<String, dynamic>> singleQuery(SqlStatement statement) async =>
      (await query(statement)).single;

  Future<List<T>> mappedQuery<T>(
    SqlStatement statement, {
    required T Function(Map<String, dynamic> json) fromJson,
  }) async =>
      (await query(statement)).map(fromJson).toList();

  Future<T> mappedSingleQuery<T>(
    SqlStatement statement, {
    required T Function(Map<String, dynamic> json) fromJson,
  }) async =>
      fromJson(await singleQuery(statement));

  Future<List<Map<String, dynamic>>> rawQuery(
    String query, {
    Map<String, dynamic> substitutionValues = const {},
  }) async {
    if (debug) {
      _logger(ProcessedSql(query: query, parameters: substitutionValues));
    }
    final result = await _connection.query(
      query,
      substitutionValues: substitutionValues,
    );
    final rawList = result.first.first as List?;
    return List<Map<String, dynamic>>.from(rawList ?? []);
  }

  Future<Map<String, dynamic>> rawSingleQuery(
    String query, {
    Map<String, dynamic> substitutionValues = const {},
  }) async =>
      (await rawQuery(query, substitutionValues: substitutionValues)).single;

  Future<List<T>> rawMappedQuery<T>(
    String query, {
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, dynamic> substitutionValues = const {},
  }) async =>
      (await rawQuery(query, substitutionValues: substitutionValues))
          .map(fromJson)
          .toList();

  Future<T> rawMappedSingleQuery<T>(
    String query, {
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, dynamic> substitutionValues = const {},
  }) async =>
      fromJson(
        await rawSingleQuery(query, substitutionValues: substitutionValues),
      );
}
