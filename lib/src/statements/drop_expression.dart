import 'package:postgres_builder/postgres_builder.dart';

class DropExpression extends SqlStatement {
  DropExpression();

  @override
  ProcessedSql toSql() {
    return const ProcessedSql(
      query: 'DROP EXPRESSION',
      parameters: {},
    );
  }
}
