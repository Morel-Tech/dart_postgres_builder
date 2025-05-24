import 'package:postgres_builder/postgres_builder.dart';

class DropColumnDefault extends AlterTableOperation {
  DropColumnDefault({required this.column});
  final String column;
  @override
  ProcessedSql toSql() {
    return ProcessedSql(
      query: 'ALTER COLUMN $column DROP DEFAULT',
      parameters: {},
    );
  }
}
