import 'package:postgres_builder/postgres_builder.dart';

class Equals implements FilterStatement {
  const Equals(this.column, this.value);

  final String column;
  final dynamic value;

  @override
  ProcessedSql toSql() {
    return ProcessedSql(
      query: '$column = @$column',
      parameters: {column: value},
    );
  }
}
