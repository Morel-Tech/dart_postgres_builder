import 'package:postgres_builder/postgres_builder.dart';

class IsNotNull extends FilterStatement {
  const IsNotNull(this.column);

  final Column column;

  @override
  ProcessedSql toSql() {
    final columnSql = column.toSql();
    return ProcessedSql(
      query: '${columnSql.query} IS NOT NULL',
      parameters: columnSql.parameters,
    );
  }
}
