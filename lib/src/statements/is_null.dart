import 'package:postgres_builder/postgres_builder.dart';

class IsNull extends FilterStatement {
  const IsNull(this.column);

  final Column column;

  @override
  ProcessedSql toSql() {
    final columnSql = column.toSql();
    return ProcessedSql(
      query: '${columnSql.query} IS NULL',
      parameters: columnSql.parameters,
    );
  }
}
