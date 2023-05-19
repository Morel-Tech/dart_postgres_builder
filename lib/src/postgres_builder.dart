import 'dart:async';
import 'dart:io';

import 'package:postgres/postgres.dart';
import 'package:postgres_builder/postgres_builder.dart';

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
    this.timeout = const Duration(seconds: 30),
    this.queryTimeout = const Duration(seconds: 30),
    this.isUnixSocket = false,
    FutureOr<void> Function(ProcessedSql message)? logger,
  }) : _logger = logger ??
            ((value) => stdout.writeln(
                  '''
--EXECUTING--
${value.query}
--WITH--
'${value.parameters}
''',
                ));

  final bool debug;
  final String host;
  final String databaseName;
  final int port;
  final String? username;
  final String? password;
  final Duration timeout;
  final Duration queryTimeout;
  final bool isUnixSocket;
  final FutureOr<void> Function(ProcessedSql message) _logger;

  late final PostgreSQLConnection _connection;

  Future<void> connect() async {
    _connection = PostgreSQLConnection(
      host,
      port,
      databaseName,
      username: username,
      password: password,
      timeoutInSeconds: timeout.inSeconds,
      queryTimeoutInSeconds: queryTimeout.inSeconds,
      isUnixSocket: isUnixSocket,
    );
    await _connection.open();
  }

  Future<void> disconnect() => _connection.close();

  bool get isClosed => _connection.isClosed;

  Future<List<Map<String, dynamic>>> query(SqlStatement statement) async {
    final processed = statement.toSql();
    if (debug) {
      _logger(processed);
    }
    final result = await _connection.query(
      processed.query,
      substitutionValues: processed.parameters,
    );
    if (result.isEmpty) return [];
    final columns = result.columnDescriptions.map((e) => e.columnName).toList();
    return [
      for (var row = 0; row < result.length; row++)
        {for (var i = 0; i < columns.length; i++) columns[i]: result[row][i]}
    ];
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
    return List<Map<String, dynamic>>.from(result.first.first as List);
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
