import 'package:postgres_builder/postgres_builder.dart';

class DropDefault extends SqlStatement {
  DropDefault();

  @override
  ProcessedSql toSql() {
    return const ProcessedSql(
      query: 'DROP DEFAULT',
      parameters: {},
    );
  }
}
