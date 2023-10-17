import 'dart:async';

import 'package:meta/meta.dart';
import 'package:postgres_builder/postgres_builder.dart';
import 'package:postgres_pool/postgres_pool.dart';

/// {@template pg_postgres_builder}
/// A tool designed to make writing SQL statements easier.
/// {@endtemplate}
class PgPoolPostgresBuilder extends PostgresBuilder {
  /// {@macro pg_postgres_builder}
  PgPoolPostgresBuilder({
    super.debug = false,
    this.host = 'localhost',
    this.databaseName = 'postgres',
    this.port = 5432,
    this.username,
    this.password,
    this.connectTimeout = const Duration(seconds: 30),
    this.queryTimeout = const Duration(seconds: 30),
    this.maxConnectionAge = const Duration(hours: 1),
    this.isUnixSocket = false,
    super.logger,
    dynamic Function(dynamic input)? customTypesConverters,
    @visibleForTesting PgPool? connection,
  })  : _connection = connection ??
            PgPool(
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
            ),
        super(customTypeConverter: customTypesConverters);

  final String host;
  final String databaseName;
  final int port;
  final String? username;
  final String? password;
  final Duration connectTimeout;
  final Duration queryTimeout;
  final Duration maxConnectionAge;
  final bool isUnixSocket;

  final PgPool _connection;

  Future<void> close() => _connection.close();
  PgPoolStatus status() => _connection.status();

  @override
  Future<List<Map<String, dynamic>>> runQuery(
    ProcessedSql processed,
  ) async {
    try {
      final result = await _connection.query(
        processed.query,
        substitutionValues: processed.parameters,
      );
      if (result.isEmpty) return [];
      final columns =
          result.columnDescriptions.map((e) => e.columnName).toList();
      return [
        for (var row = 0; row < result.length; row++)
          {for (var i = 0; i < columns.length; i++) columns[i]: result[row][i]},
      ];
    } on PostgreSQLException catch (e) {
      throw PostgresBuilderException(
        e.message,
        {'code': e.code, 'detail': e.detail},
      );
    }
  }
}
