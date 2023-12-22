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
    final columnSql = column.toSql().query;
    if (useParameter) {
      final parameterName = column.parameterName ?? 'parameter';
      return ProcessedSql(
        query: columnFirst
            ? '$columnSql $operator @$parameterName'
            : '@$parameterName $operator $columnSql',
        parameters: {parameterName: value},
      );
    }

    return ProcessedSql(
      query: '$columnSql $operator $value',
      parameters: {},
    );
  }
}
