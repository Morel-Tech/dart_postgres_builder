import 'package:postgres_builder/postgres_builder.dart';

class RenameColumn extends SqlStatement {
  RenameColumn({required this.column, required this.newName});
  final String column;
  final String newName;
  @override
  ProcessedSql toSql() {
    return ProcessedSql(
      query: 'RENAME COLUMN $column TO $newName',
      parameters: {},
    );
  }
}
