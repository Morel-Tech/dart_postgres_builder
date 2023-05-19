import 'package:postgres_builder/postgres_builder.dart';

class Not implements FilterStatement {
  const Not(this.column);

  final String column;

  @override
  ProcessedSql toSql() {
    return ProcessedSql(
      query: 'NOT $column',
      parameters: {},
    );
  }
}
