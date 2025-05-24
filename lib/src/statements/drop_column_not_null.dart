import 'package:postgres_builder/postgres_builder.dart';

class DropColumnNotNull extends AlterTableOperation {
  DropColumnNotNull({required this.column});
  final String column;
  @override
  ProcessedSql toSql() {
    return ProcessedSql(
      query: 'ALTER COLUMN $column DROP NOT NULL',
      parameters: {},
    );
  }
}
