import 'dart:async';

import 'package:meta/meta.dart';
import 'package:postgres_builder/postgres_builder.dart';
import 'package:postgres_pool/postgres_pool.dart';

/// {@template pg_postgres_builder}
/// A [PostgresBuilder] that uses a [PgPool] to execute the queries.
/// {@endtemplate}
class PgPoolPostgresBuilder extends PostgresBuilder {
  /// {@macro pg_postgres_builder}
  PgPoolPostgresBuilder({
    required PgEndpoint pgEndpoint,
    PgPoolSettings? pgPoolSettings,
    super.debug = false,
    super.logger,
    super.customTypeConverter,
    @visibleForTesting PgPool? connection,
  }) : _connection = connection ??
            PgPool(
              pgEndpoint,
              settings: pgPoolSettings,
            );

  final PgPool _connection;

  /// Closes the [PgPool] connection
  Future<void> close() => _connection.close();

  /// The status of the [PgPool] connection
  PgPoolStatus get status => _connection.status();

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
