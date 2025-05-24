import 'package:postgres_builder/postgres_builder.dart';

class DropNotNull extends SqlStatement {
  DropNotNull();
  @override
  ProcessedSql toSql() {
    return const ProcessedSql(
      query: 'DROP NOT NULL',
      parameters: {},
    );
  }
}
