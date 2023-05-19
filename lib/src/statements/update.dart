import 'package:postgres_builder/postgres_builder.dart';

class Update implements SqlStatement {
  const Update(
    this.values, {
    required String from,
    required this.where,
  }) : table = from;

  final Map<String, dynamic> values;
  final String table;
  final FilterStatement where;

  @override
  ProcessedSql toSql() {
    final whereSql = where.toSql();
    final query = [
      'UPDATE',
      table,
      'SET',
      values.keys.map((row) => '$row=@val$row').join(', '),
      'WHERE',
      whereSql.query,
      'RETURNING *'
    ].join(' ');
    return ProcessedSql(
      query: query,
      parameters: {
        for (final entry in values.entries) 'val${entry.key}': entry.value,
        ...whereSql.parameters,
      },
    );
  }
}
