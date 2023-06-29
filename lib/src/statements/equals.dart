import 'package:postgres_builder/postgres_builder.dart';
import 'package:postgres_builder/src/random_keys.dart';

class Equals implements FilterStatement {
  const Equals(this.column, this.value) : useParameter = true;
  const Equals.otherColumn(
    Column column1,
    Column column2,
  )   : column = column1,
        value = column2,
        useParameter = false;

  final Column column;
  final dynamic value;
  final bool useParameter;

  @override
  ProcessedSql toSql() {
    if (useParameter) {
      final randomString = '${column.name}${generateRandomString(6)}';
      return ProcessedSql(
        query: '$column = @$randomString',
        parameters: {randomString: value},
      );
    }
    return ProcessedSql(
      query: '$column = $value',
      parameters: {},
    );
  }
}
