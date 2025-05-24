import 'package:postgres_builder/postgres_builder.dart';

class SetColumnNotNull extends AlterTableOperation {
  SetColumnNotNull({required this.column});
  final String column;
  @override
  ProcessedSql toSql() {
    return ProcessedSql(
      query: 'ALTER COLUMN $column SET NOT NULL',
      parameters: {},
    );
  }
}
