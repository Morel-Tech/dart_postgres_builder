import 'package:postgres_builder/postgres_builder.dart';

class In implements FilterStatement {
  const In(this.column, this.values);

  final Column column;
  final List<dynamic> values;

  @override
  ProcessedSql toSql() {
    final columnParams = List<String>.generate(
      values.length,
      (i) => '${column.parameterName}$i',
    );
    return ProcessedSql(
      query: '$column IN (${columnParams.map((e) => '@$e').join(', ')})',
      parameters: {
        for (var i = 0; i < values.length; i++) columnParams[i]: values[i],
      },
    );
  }
}
