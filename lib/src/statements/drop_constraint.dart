import 'package:postgres_builder/postgres_builder.dart';

class DropConstraint extends SqlStatement {
  DropConstraint({required this.constraintName});
  final String constraintName;

  @override
  ProcessedSql toSql() {
    return ProcessedSql(
      query: 'DROP CONSTRAINT $constraintName',
      parameters: {},
    );
  }
}
