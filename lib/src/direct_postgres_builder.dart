import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:postgres/postgres.dart';
import 'package:postgres_builder/postgres_builder.dart';

class DirectPostgresBuilder extends PostgresBuilder {
  DirectPostgresBuilder({
    required this.endpoint,
    this.settings,
    super.debug = false,
    super.logger,
    super.customTypeConverter,
    @visibleForTesting Connection? connection,
  }) {
    if (connection != null) {
      _connection = connection;
    } else {
      _connect();
    }
  }

  late final Connection _connection;

  final Endpoint endpoint;
  final ConnectionSettings? settings;

  Future<void> _connect() async {
    _connection = await Connection.open(
      endpoint,
      settings: settings,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> runQuery(ProcessedSql processed) async {
    try {
      final result = await _connection.execute(
        Sql.named(processed.query),
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
        {
          'code': e.code,
          'detail': e.detail,
          'columnName': e.columnName,
          'position': e.position,
          'internalPosition': e.internalPosition,
          'constraintName': e.constraintName,
          'dataTypeName': e.dataTypeName,
          'fileName': e.fileName,
          'hint': e.hint,
          'internalQuery': e.internalQuery,
          'lineNumber': e.lineNumber,
          'routineName': e.routineName,
          'schemaName': e.schemaName,
          'tableName': e.tableName,
          'pg_trace': e.trace,
          'pg_severity': e.severity,
        },
      );
    }
  }

  Future<void> close() async {
    await _connection.close();
  }
}
