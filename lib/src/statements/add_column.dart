import 'package:postgres_builder/postgres_builder.dart';

class AddColumn extends SqlStatement {
  AddColumn({
    required this.table,
    required this.column,
    this.ifNotExists = false,
  });
  final String table;
  final ColumnDefinition column;
  final bool ifNotExists;

  @override
  ProcessedSql toSql() {
    final columnSql = column.toSql();
    final query = StringBuffer('ALTER TABLE $table ADD COLUMN ');
    if (ifNotExists) {
      query.write('IF NOT EXISTS ');
    }
    query.write('${columnSql.query};');
    return ProcessedSql(
      query: query.toString(),
      parameters: {
        ...columnSql.parameters,
      },
    );
  }
}
