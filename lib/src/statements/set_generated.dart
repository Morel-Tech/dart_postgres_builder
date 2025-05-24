import 'package:postgres_builder/postgres_builder.dart';

class SetGenerated extends SqlStatement {
  SetGenerated({required this.expression});
  final String expression;

  @override
  ProcessedSql toSql() {
    return ProcessedSql(
      query: 'SET GENERATED ALWAYS AS ($expression) STORED',
      parameters: {},
    );
  }
}
