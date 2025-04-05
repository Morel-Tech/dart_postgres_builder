import 'package:postgres_builder/postgres_builder.dart';

class Or extends FilterStatement {
  const Or(this.statements);

  final List<SqlStatement> statements;

  @override
  ProcessedSql toSql() {
    final processed = statements.map((e) => e.toSql()).toList();
    return ProcessedSql(
      query: '(${processed.map((e) => e.query).join(' OR ')})',
      parameters: {
        for (final current in processed) ...current.parameters,
      },
    );
  }
}
