import 'package:postgres_builder/postgres_builder.dart';

class Or implements FilterStatement {
  const Or(this.first, this.second);

  final SqlStatement first;
  final SqlStatement second;

  @override
  ProcessedSql toSql() {
    final firstSql = first.toSql();
    final secondSql = second.toSql();
    return ProcessedSql(
      query: '(${firstSql.query} OR ${secondSql.query})',
      parameters: {...firstSql.parameters, ...secondSql.parameters},
    );
  }
}
