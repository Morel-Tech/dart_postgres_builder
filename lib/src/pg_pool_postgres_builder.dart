import 'dart:async';
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:postgres_builder/postgres_builder.dart';
import 'package:postgres_pool/postgres_pool.dart';

/// {@template pg_postgres_builder}
/// A tool designed to make writing SQL statements easier.
/// {@endtemplate}
class PgPoolPostgresBuilder extends PostgresBuilder {
  /// {@macro pg_postgres_builder}
  PgPoolPostgresBuilder({
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
    dynamic Function(dynamic input)? customTypesConverters,
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
  final dynamic Function(dynamic input)? _customTypesConverter;

  late final PgPool _connection;

  Future<void> close() => _connection.close();
  PgPoolStatus status() => _connection.status();

  Future<void> execute(SqlStatement statement) => query(statement);

  @override
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

  @override
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
}
