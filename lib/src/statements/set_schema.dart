import 'package:postgres_builder/postgres_builder.dart';

class SetSchema extends SqlStatement {
  SetSchema({required this.schema});
  final String schema;

  @override
  ProcessedSql toSql() {
    return ProcessedSql(
      query: 'SET SCHEMA $schema',
      parameters: {},
    );
  }
}
