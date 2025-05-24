import 'package:postgres_builder/postgres_builder.dart';

class SetNotNull extends SqlStatement {
  SetNotNull();
  @override
  ProcessedSql toSql() {
    return const ProcessedSql(
      query: 'SET NOT NULL',
      parameters: {},
    );
  }
}
