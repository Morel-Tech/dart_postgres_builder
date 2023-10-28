import 'package:postgres_builder/postgres_builder.dart';

class Group extends SqlStatement {
  Group(this.columns);

  final List<Column> columns;
  @override
  ProcessedSql toSql() {
    return ProcessedSql(
      query: 'GROUP BY ${columns.join(', ')}',
      parameters: const {},
    );
  }
}
