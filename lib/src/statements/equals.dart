import 'package:postgres_builder/src/statements/operator_comparison.dart';

class Equals extends OperatorComparison {
  const Equals(super.column, super.value)
      : super(operator: '=', columnFirst: true);
  const Equals.otherColumn(
    super.column1,
    super.column2,
  ) : super.otherColumn(operator: '=');
}

class NotEquals extends OperatorComparison {
  const NotEquals(super.column, super.value)
      : super(operator: '!=', columnFirst: true);
  const NotEquals.otherColumn(
    super.column1,
    super.column2,
  ) : super.otherColumn(operator: '!=');
}
