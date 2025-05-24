import 'package:postgres_builder/postgres_builder.dart';

class AddColumn extends SqlStatement {
  AddColumn({
    required this.column,
    this.ifNotExists = false,
  });

  final ColumnDefinition column;
  final bool ifNotExists;

  @override
  ProcessedSql toSql() {
    final columnSql = column.toSql();
    final buffer = StringBuffer('ADD COLUMN ');
    if (ifNotExists) {
      buffer.write('IF NOT EXISTS ');
    }
    buffer.write(columnSql.query);

    return ProcessedSql(
      query: buffer.toString(),
      parameters: columnSql.parameters,
    );
  }
}
