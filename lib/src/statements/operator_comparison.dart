import 'package:postgres_builder/postgres_builder.dart';

class OperatorComparision implements FilterStatement {
  const OperatorComparision(this.column, this.value, {required this.operator})
      : useParameter = true;
  const OperatorComparision.otherColumn(
    Column column1,
    Column column2, {
    required this.operator,
  })  : column = column1,
        value = column2,
        useParameter = false;

  final Column column;
  final dynamic value;
  final bool useParameter;
  final String operator;

  @override
  ProcessedSql toSql() {
    if (useParameter) {
      return ProcessedSql(
        query: '$column $operator @${column.parameterName}',
        parameters: {column.parameterName: value},
      );
    }
    return ProcessedSql(
      query: '$column $operator $value',
      parameters: {},
    );
  }
}
