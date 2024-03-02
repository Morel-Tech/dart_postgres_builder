import 'dart:async';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:postgres/postgres.dart';
import 'package:postgres_builder/postgres_builder.dart';

/// {@template pg_postgres_builder}
/// A [PostgresBuilder] that uses a [Pool] to execute the queries.
/// {@endtemplate}
class PgPoolPostgresBuilder extends PostgresBuilder {
  /// {@macro pg_postgres_builder}
  PgPoolPostgresBuilder({
    required Endpoint pgEndpoint,
    PoolSettings? pgPoolSettings,
    super.debug = false,
    super.logger,
    super.customTypeConverter,
    @visibleForTesting Pool<void>? pool,
  }) : _pool = pool ??
            Pool.withEndpoints(
              [pgEndpoint],
              settings: pgPoolSettings,
            );

  final Pool<void> _pool;

  /// Closes the [Connection]
  Future<void> close() => _pool.close();

  @override
  Future<List<Map<String, dynamic>>> runQuery(
    ProcessedSql processed,
  ) async {
    try {
      final result = await _pool.execute(
        processed.query,
        parameters: processed.parameters,
      );
      if (result.isEmpty) return [];
      final columns = result.schema.columns
          .mapIndexed((i, e) => e.columnName ?? 'column$i')
          .toList();
      return [
        for (var row = 0; row < result.length; row++)
          {for (var i = 0; i < columns.length; i++) columns[i]: result[row][i]},
      ];
    } on ServerException catch (e) {
      throw PostgresBuilderException(
        e.message,
        {'code': e.code, 'detail': e.detail},
      );
    }
  }
}
