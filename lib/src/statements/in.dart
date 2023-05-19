import 'package:postgres_builder/postgres_builder.dart';

class In implements FilterStatement {
  const In(this.column, this.values);

  final String column;
  final List<dynamic> values;

  @override
  ProcessedSql toSql() {
    final columnParams = List<int>.generate(values.length, (i) => i)
        .map((i) => '@${i}I$column')
        .toList();
    return ProcessedSql(
      query: '$column IN (${columnParams.join(', ')})',
      parameters: {
        for (var i = 0; i < columnParams.length; i++)
          columnParams[i]: values[i],
      },
    );
  }
}
