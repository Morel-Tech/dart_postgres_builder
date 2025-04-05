import 'package:postgres_builder/postgres_builder.dart';

class And extends FilterStatement {
  const And(this.statements);

  final List<SqlStatement> statements;

  @override
  ProcessedSql toSql() {
    final processed = statements.map((e) => e.toSql()).toList();
    return ProcessedSql(
      query: '(${processed.map((e) => e.query).join(' AND ')})',
      parameters: {
        for (final current in processed) ...current.parameters,
      },
    );
  }
}
