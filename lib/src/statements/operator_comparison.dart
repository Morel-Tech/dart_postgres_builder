import 'package:postgres_builder/postgres_builder.dart';

class OperatorComparision implements FilterStatement {
  const OperatorComparision(
    this.column,
    this.value, {
    required this.operator,
    this.columnFirst = true,
  }) : useParameter = true;
  const OperatorComparision.otherColumn(
    Column column1,
    Column column2, {
    required this.operator,
  })  : column = column1,
        value = column2,
        useParameter = false,
        columnFirst = false;

  final Column column;
  final dynamic value;
  final bool useParameter;
  final String operator;
  final bool columnFirst;

  @override
  ProcessedSql toSql() {
    if (useParameter) {
      return ProcessedSql(
        query: columnFirst
            ? '$column $operator @${column.parameterName}'
            : '@${column.parameterName} $operator $column',
        parameters: {column.parameterName: value},
      );
    }
    return ProcessedSql(
      query: '$column $operator $value',
      parameters: {},
    );
  }
}
