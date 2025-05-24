import 'package:postgres_builder/postgres_builder.dart';

class RenameTable extends SqlStatement {
  RenameTable({required this.newName});
  final String newName;

  @override
  ProcessedSql toSql() {
    return ProcessedSql(
      query: 'RENAME TO $newName',
      parameters: {},
    );
  }
}
