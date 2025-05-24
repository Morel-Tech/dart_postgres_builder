import 'package:postgres_builder/postgres_builder.dart';

class SetColumnDefault extends AlterTableOperation {
  SetColumnDefault({required this.column, required this.defaultValue});
  final String column;
  final String defaultValue;
  @override
  ProcessedSql toSql() {
    return ProcessedSql(
      query: 'ALTER COLUMN $column SET DEFAULT $defaultValue',
      parameters: {},
    );
  }
}
