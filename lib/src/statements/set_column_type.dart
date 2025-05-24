import 'package:postgres_builder/postgres_builder.dart';

class SetColumnType extends AlterTableOperation {
  SetColumnType({required this.column, required this.newType, this.using});
  final String column;
  final String newType;
  final String? using;
  @override
  ProcessedSql toSql() {
    final buffer = StringBuffer('ALTER COLUMN $column TYPE $newType');
    if (using != null) {
      buffer.write(' USING $using');
    }
    return ProcessedSql(
      query: buffer.toString(),
      parameters: {},
    );
  }
}
