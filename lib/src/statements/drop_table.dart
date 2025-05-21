import 'package:postgres_builder/postgres_builder.dart';

class DropTable extends SqlStatement {
  const DropTable({
    required this.name,
    this.ifExists = false,
  });

  final String name;
  final bool ifExists;

  @override
  ProcessedSql toSql() {
    final query = StringBuffer('DROP TABLE ');
    if (ifExists) {
      query.write('IF EXISTS ');
    }
    query.write('$name;');
    return ProcessedSql(
      query: query.toString(),
      parameters: {},
    );
  }
}
