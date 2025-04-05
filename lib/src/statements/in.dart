import 'package:postgres_builder/postgres_builder.dart';

class In<T> extends FilterStatement {
  const In(this.column, this.values);

  final Column column;
  final List<T> values;

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
