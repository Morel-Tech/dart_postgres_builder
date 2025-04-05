import 'package:postgres_builder/postgres_builder.dart';

class Group extends SqlStatement {
  Group(this.columns);

  final List<Column> columns;
  @override
  ProcessedSql toSql() {
    final columnsSql = columns.map((e) => e.toSql()).toList();
    return ProcessedSql(
      query: 'GROUP BY ${columnsSql.map((e) => e.query).join(', ')}',
      parameters: {
        for (final columnSql in columnsSql) ...columnSql.parameters,
      },
    );
  }
}
