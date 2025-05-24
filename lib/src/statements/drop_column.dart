import 'package:postgres_builder/postgres_builder.dart';

class DropColumn extends SqlStatement {
  DropColumn({
    required this.table,
    required this.column,
    this.ifExists = false,
  });
  final String table;
  final String column;
  final bool ifExists;

  @override
  ProcessedSql toSql() {
    final query = StringBuffer('ALTER TABLE $table DROP COLUMN ');
    if (ifExists) {
      query.write('IF EXISTS ');
    }
    query.write('$column;');
    return ProcessedSql(
      query: query.toString(),
      parameters: {},
    );
  }
}
