import 'package:postgres_builder/postgres_builder.dart';
import 'package:postgres_builder/src/random_keys.dart';

class In implements FilterStatement {
  const In(this.column, this.values);

  final String column;
  final List<dynamic> values;

  @override
  ProcessedSql toSql() {
    final columnParams = List<String>.generate(
      values.length,
      (_) => '@$column${generateRandomString(6)}',
    );
    return ProcessedSql(
      query: '$column IN (${columnParams.join(', ')})',
      parameters: {
        for (var i = 0; i < values.length; i++) columnParams[i]: values[i],
      },
    );
  }
}
