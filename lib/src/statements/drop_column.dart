import 'package:postgres_builder/postgres_builder.dart';

class DropColumn extends SqlStatement {
  DropColumn({
    required this.column,
    this.ifExists = false,
  });

  final String column;
  final bool ifExists;

  @override
  ProcessedSql toSql() {
    final queries = <String>[];

    final buffer = StringBuffer('DROP COLUMN ');
    if (ifExists) {
      buffer.write('IF EXISTS ');
    }
    buffer.write(column);
    queries.add(buffer.toString());

    return ProcessedSql(
      query: buffer.toString(),
      parameters: {},
    );
  }
}
