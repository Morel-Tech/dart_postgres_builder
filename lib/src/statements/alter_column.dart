import 'package:postgres_builder/postgres_builder.dart';

class AlterColumn extends SqlStatement {
  AlterColumn({required this.column, required this.operations});

  final String column;
  final List<SqlStatement> operations;

  @override
  ProcessedSql toSql() {
    final mappedOperations = operations.map((e) => e.toSql());
    return ProcessedSql(
      query:
          '''ALTER COLUMN $column ${mappedOperations.map((e) => e.query).join(', ')}''',
      parameters: {
        for (final operation in mappedOperations) ...operation.parameters,
      },
    );
  }
}
