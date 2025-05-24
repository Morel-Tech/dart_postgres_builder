import 'package:postgres_builder/postgres_builder.dart';

class AlterTable extends SqlStatement {
  AlterTable({
    required this.table,
    required this.operations,
  });

  final String table;
  final List<SqlStatement> operations;

  @override
  ProcessedSql toSql() {
    final queries = <String>[];
    final parameters = <String, dynamic>{};
    for (final operation in operations) {
      final opSql = operation.toSql();
      queries.add(opSql.query);
      parameters.addAll(opSql.parameters);
    }
    final query = operations.isNotEmpty
        ? 'ALTER TABLE $table ${queries.join(', ')}'
        : 'ALTER TABLE $table';
    return ProcessedSql(
      query: query,
      parameters: parameters,
    );
  }
}
