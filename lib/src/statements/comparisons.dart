import 'package:postgres_builder/postgres_builder.dart';

class GreaterThan extends OperatorComparison {
  const GreaterThan(super.column, super.value)
      : super(operator: '>', columnFirst: true);
}

class GreaterThanOrEqual extends OperatorComparison {
  const GreaterThanOrEqual(super.column, super.value)
      : super(operator: '>=', columnFirst: true);
}

class LessThan extends OperatorComparison {
  const LessThan(super.column, super.value)
      : super(operator: '<', columnFirst: true);
}

class LessThanOrEqual extends OperatorComparison {
  const LessThanOrEqual(super.column, super.value)
      : super(operator: '<=', columnFirst: true);
}

class Between extends FilterStatement {
  const Between(this.column, this.lowerValue, this.upperValue);

  final Column column;
  final dynamic lowerValue;
  final dynamic upperValue;

  @override
  ProcessedSql toSql() {
    final columnSql = column.toSql().query;

    return ProcessedSql(
      query: '$columnSql BETWEEN @${column.parameterName}_lower '
          'AND @${column.parameterName}_upper',
      parameters: {
        '${column.parameterName}_lower': lowerValue,
        '${column.parameterName}_upper': upperValue,
      },
    );
  }
}
