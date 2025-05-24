import 'package:postgres_builder/postgres_builder.dart';

class SetType extends SqlStatement {
  SetType({required this.newType, this.using});
  final String newType;
  final String? using;

  @override
  ProcessedSql toSql() {
    final buffer = StringBuffer('TYPE $newType');
    if (using != null) {
      buffer.write(' USING $using');
    }
    return ProcessedSql(
      query: buffer.toString(),
      parameters: {},
    );
  }
}
