import 'package:postgres_builder/postgres_builder.dart';

class AddConstraint extends SqlStatement {
  AddConstraint({required this.constraint});
  final String constraint;

  @override
  ProcessedSql toSql() {
    return ProcessedSql(
      query: 'ADD $constraint',
      parameters: {},
    );
  }
}
