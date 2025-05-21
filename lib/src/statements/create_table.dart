import 'package:postgres_builder/postgres_builder.dart';

class CreateTable extends SqlStatement {
  const CreateTable({
    required this.name,
    required this.columns,
    this.ifNotExists = false,
  });

  final String name;
  final bool ifNotExists;
  final List<ColumnDefinition> columns;

  @override
  ProcessedSql toSql() {
    final query = StringBuffer(
      'CREATE TABLE ',
    );
    if (ifNotExists) {
      query.write('IF NOT EXISTS ');
    }
    query.write('$name (');
    final mappedQuery = columns.map((e) => e.toSql());
    for (final (index, column) in mappedQuery.indexed) {
      final isLast = index == mappedQuery.length - 1;
      query.write(column.query);
      if (!isLast) {
        query.write(', ');
      }
    }
    query.write(');');
    return ProcessedSql(
      query: query.toString(),
      parameters: {
        for (final current in mappedQuery) ...current.parameters,
      },
    );
  }
}
