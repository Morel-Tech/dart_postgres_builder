import 'package:postgres_builder/postgres_builder.dart';

class SetDefault extends SqlStatement {
  SetDefault({required this.defaultValue});
  final String defaultValue;

  @override
  ProcessedSql toSql() {
    return ProcessedSql(
      query: 'SET DEFAULT $defaultValue',
      parameters: {},
    );
  }
}
