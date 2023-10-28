import 'package:postgres_builder/postgres_builder.dart';

class Group extends SqlStatement {
  Group(this.columns);

  final List<Column> columns;
  @override
  ProcessedSql toSql() {
    final columnNames = columns.map((e) => e.parameterName);
    return ProcessedSql(
      query: 'GROUP BY ${columnNames.join(', ')}',
      parameters: const {},
    );
  }
}
